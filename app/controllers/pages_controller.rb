class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    if user_signed_in?
      redirect_to dashboard_path
    end
  end

  def pricing
    @plans = Rails.application.config_for(:plans)['plans']
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
  end

  def styleguide
  end

  def contact_submit
    name = params[:name]
    email = params[:email]
    message = params[:message]

    if name.present? && email.present? && message.present?
      ContactMailer.contact_form(name: name, email: email, message: message).deliver_later

      flash[:notice] = "Thank you for your message. We'll get back to you soon!"
      redirect_to contact_path
    else
      flash[:alert] = "Please fill in all fields."
      redirect_to contact_path
    end
  end
end