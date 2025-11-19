class RegistrationsController < Devise::RegistrationsController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /users/sign_up
  def new
    super
  end

  # POST /users
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
      # Create default account for new user
      account_name = resource.first_name.present? ? "#{resource.first_name}'s Account" : "My Account"
      account = Account.create!(
        name: account_name,
        slug: generate_slug(resource.email)
      )

      # Create owner membership
      account.memberships.create!(
        user: resource,
        role: 'owner',
        accepted_at: Time.current
      )

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /users/edit
  def edit
    super
  end

  # PUT /users
  def update
    super
  end

  # DELETE /users
  def destroy
    super
  end

  # GET /users/cancel
  def cancel
    super
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :avatar])
  end

  def after_sign_up_path_for(resource)
    onboarding_path # or dashboard_path
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  private

  def generate_slug(email)
    base_slug = email.split('@').first.parameterize
    slug = base_slug
    counter = 1

    while Account.exists?(slug: slug)
      slug = "#{base_slug}-#{counter}"
      counter += 1
    end

    slug
  end
end