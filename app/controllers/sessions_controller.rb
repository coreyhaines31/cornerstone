class SessionsController < Devise::SessionsController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  # GET /sign-in
  def new
    render inertia: 'Auth/SignIn'
  end

  # POST /sign-in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    redirect_to after_sign_in_path_for(resource)
  rescue StandardError => e
    render inertia: 'Auth/SignIn', props: {
      errors: { base: ['Invalid email or password'] }
    }
  end

  # Magic link: request a sign-in link via email
  def new_magic_link
    render inertia: "Auth/MagicLink"
  rescue NameError
    # Fallback to HTML if front-end view is not present
    render plain: "Request a magic link by POSTing your email to /users/magic_link", status: :ok
  end

  def create_magic_link
    email = params[:email].to_s.downcase.strip
    user = User.find_by(email: email)

    if user
      token = user.generate_magic_link_token
      UserMailer.magic_link(user, token).deliver_later
      flash[:notice] = "Check your email for a login link."
    else
      flash[:alert] = "We couldn’t find an account with that email."
    end

    redirect_to new_user_session_path
  end

  def verify_magic_link
    token = params[:token].to_s
    user = User.find_by(login_token: Digest::SHA256.hexdigest(token))

    if user&.valid_magic_link_token?(token)
      user.clear_magic_link_token!
      sign_in(user)
      redirect_to after_sign_in_path_for(user), notice: "Signed in successfully."
    else
      redirect_to new_user_session_path, alert: "Invalid or expired link."
    end
  end

  # Placeholder 2FA endpoints (no-op until OTP is enabled)
  def new_otp
    redirect_to new_user_session_path, alert: "Two-factor authentication is currently disabled."
  end

  def verify_otp
    redirect_to new_user_session_path, alert: "Two-factor authentication is currently disabled."
  end
end
