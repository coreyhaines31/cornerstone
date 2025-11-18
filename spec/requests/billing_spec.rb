require "rails_helper"

RSpec.describe "Billing", type: :request do
  include_context "requires table", "users"

  let(:user) { create(:user, :with_account) }

  describe "GET /billing" do
    it "renders when authenticated" do
      post user_session_path, params: { user: { email: user.email, password: "Password123!" } }
      follow_redirect!

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
