require "rails_helper"

RSpec.describe "Team", type: :request do
  let(:user) { create(:user, :with_account) }

  describe "GET /team" do
    it "renders when authenticated" do
      sign_in user

      get team_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Team")
    end

    it "redirects when unauthenticated" do
      get team_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
