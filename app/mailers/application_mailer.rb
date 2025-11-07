class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEFAULT_FROM_EMAIL', 'noreply@example.com')
  layout "mailer"

  private

  def default_url_options
    if Rails.env.production?
      { host: ENV.fetch('APP_HOST', 'example.com'), protocol: 'https' }
    else
      { host: 'localhost', port: 3000, protocol: 'http' }
    end
  end
end