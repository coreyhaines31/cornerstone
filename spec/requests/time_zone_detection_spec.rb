require "rails_helper"

RSpec.describe "Time zone detection", type: :request do
  # Get the Inertia version dynamically right before each request
  def inertia_headers
    version = InertiaRails.configuration.version
    version_string = version.is_a?(Proc) ? version.call : version
    { "X-Inertia" => "true", "X-Inertia-Version" => version_string }
  end

  around do |example|
    original_zone = Time.zone
    begin
      example.run
    ensure
      Time.zone = original_zone
      Current.reset
    end
  end

  describe "GET /styleguide" do
    it "applies a valid timezone cookie and exposes it to Inertia" do
      target_zone = "America/Chicago"
      cookies[:time_zone] = target_zone

      get "/styleguide", headers: inertia_headers

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json.dig("props", "time_zone")).to eq(target_zone)
    end

    it "ignores invalid timezone values and clears the cookie" do
      original_zone_name = Time.zone.name
      cookies[:time_zone] = "Invalid/Zone"

      get "/styleguide", headers: inertia_headers

      json = JSON.parse(response.body)
      expect(json.dig("props", "time_zone")).to eq(original_zone_name)

      set_cookie_header = response.headers["Set-Cookie"]
      # Set-Cookie header can be an array or string
      cookie_string = set_cookie_header.is_a?(Array) ? set_cookie_header.join("; ") : set_cookie_header
      expect(cookie_string).to include("time_zone=")
      expect(cookie_string).to match(/time_zone=;.*expires=/)
    end

    it "exposes the default timezone when no cookie is provided" do
      get "/styleguide", headers: inertia_headers

      json = JSON.parse(response.body)
      expect(json.dig("props", "time_zone")).to eq(Time.zone.name)
    end
  end
end
