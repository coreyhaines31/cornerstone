RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :request

  config.before(:suite) do
    Warden.test_mode!
  end

  config.after(type: :request) do
    Warden.test_reset!
  end
end
