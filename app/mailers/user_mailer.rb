class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to #{Rails.application.config.application_name}!")
  end

  def password_reset(user)
    @user = user
    @reset_url = edit_user_password_url(reset_password_token: user.reset_password_token)
    mail(to: @user.email, subject: "Password reset instructions")
  end

  def email_confirmation(user)
    @user = user
    @confirmation_url = user_confirmation_url(confirmation_token: user.confirmation_token)
    mail(to: @user.email, subject: "Confirm your email address")
  end

  def magic_link(user, token)
    @user = user
    @magic_link_url = verify_magic_link_url(token: token)
    mail(to: @user.email, subject: "Your login link")
  end
end