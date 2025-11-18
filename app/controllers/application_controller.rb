class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include InertiaRails::Controller

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :set_current_attributes
  before_action :configure_permitted_parameters, if: :devise_controller?

  inertia_share do
    {
      flash: flash.to_hash.slice(:alert, :notice),
      current_user: current_user && {
        id: current_user.id,
        email: current_user.email,
        first_name: current_user.first_name,
        last_name: current_user.last_name
      }
    }
  end

  after_action :verify_authorized, except: :index, unless: :skip_authorization?
  after_action :verify_policy_scoped, only: :index, unless: :skip_authorization?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  impersonates :user

  private

  def set_current_attributes
    Current.user = current_user
    Current.account = current_account if respond_to?(:current_account)
    Current.ip_address = request.remote_ip
    Current.user_agent = request.user_agent
  end

  def current_account
    return @current_account if defined?(@current_account)

    @current_account = if session[:current_account_id].present?
      current_user&.accounts&.find_by(id: session[:current_account_id])
    else
      current_user&.accounts&.first
    end

    # Store in session for next request
    session[:current_account_id] = @current_account&.id

    @current_account
  end
  helper_method :current_account

  def switch_account(account)
    if current_user.accounts.include?(account)
      session[:current_account_id] = account.id
      @current_account = account
      Current.account = account

      # Log account switch
      AuditEvent.create!(
        account: account,
        user: current_user,
        action: 'account_switched',
        metadata: { from_account_id: session[:previous_account_id] },
        ip_address: request.remote_ip
      )

      true
    else
      false
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :avatar])
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    message = t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)

    respond_to do |format|
      format.html do
        flash[:alert] = message
        redirect_back(fallback_location: root_path)
      end
      format.json { render json: { error: message }, status: :forbidden }
    end
  end

  def not_found
    respond_to do |format|
      format.html { render file: Rails.public_path.join('404.html'), status: :not_found, layout: false }
      format.json { render json: { error: 'Not found' }, status: :not_found }
    end
  end

  def skip_authorization?
    devise_controller? || is_a?(HealthController)
  end

  def require_admin!
    unless current_user&.admin?
      flash[:alert] = "You must be an admin to access this page."
      redirect_to root_path
    end
  end

  def require_account_owner!
    unless current_user&.owner_of?(current_account)
      flash[:alert] = "You must be an account owner to perform this action."
      redirect_back(fallback_location: dashboard_path)
    end
  end

end
