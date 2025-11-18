require "rails_helper"

RSpec.describe "Billing", type: :request do
  let(:user) { create(:user, :with_account) }

  describe "GET /billing" do
    it "renders when authenticated" do
      sign_in user

      get billing_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Billing")
    end

    it "redirects when unauthenticated" do
      get billing_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
