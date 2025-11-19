class PasswordsController < Devise::PasswordsController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  # GET /forgot-password
  def new
    render inertia: 'Auth/ForgotPassword'
  end

  # POST /forgot-password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      redirect_to new_session_path(resource_name), notice: 'You will receive an email with instructions on how to reset your password in a few minutes.'
    else
      render inertia: 'Auth/ForgotPassword', props: {
        errors: resource.errors.messages
      }
    end
  end

  # GET /reset-password?reset_password_token=...
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]

    render inertia: 'Auth/ResetPassword', props: {
      resetPasswordToken: params[:reset_password_token],
      minPasswordLength: @minimum_password_length || 6
    }
  end

  # PUT /reset-password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if resource_class.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      redirect_to after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      render inertia: 'Auth/ResetPassword', props: {
        resetPasswordToken: params[:user][:reset_password_token],
        errors: resource.errors.messages,
        minPasswordLength: @minimum_password_length || 6
      }
    end
  end

  protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name) if is_navigational_format?
  end
end
