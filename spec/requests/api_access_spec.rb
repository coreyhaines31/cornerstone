require "rails_helper"

RSpec.describe "API Access", type: :request do
  let(:user) { create(:user, :with_account) }

  describe "GET /api-access" do
    it "renders when authenticated" do
      sign_in user

      get api_access_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("API")
    end

    it "redirects when unauthenticated" do
      get api_access_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
