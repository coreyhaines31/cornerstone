require 'rails_helper'

RSpec.describe "Sign In", type: :request do
  let!(:user) { create(:user, email: 'user@example.com', password: 'SecureP@ss123') }

  describe "GET /sign-in" do
    it "renders the sign in page via Inertia" do
      get "/sign-in"

      expect(response).to have_http_status(:success)
      expect(response.headers['X-Inertia']).to eq('true')

      json = JSON.parse(response.body)
      expect(json['component']).to eq('Auth/SignIn')
    end
  end

  describe "POST /sign-in" do
    context "with valid credentials" do
      let(:valid_params) do
        {
          user: {
            email: 'user@example.com',
            password: 'SecureP@ss123'
          }
        }
      end

      it "signs in the user" do
        post "/sign-in", params: valid_params
        expect(controller.current_user).to eq(user)
      end

      it "redirects to dashboard" do
        post "/sign-in", params: valid_params
        expect(response).to redirect_to(dashboard_path)
      end

      it "sets flash notice" do
        post "/sign-in", params: valid_params
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid email" do
      let(:invalid_params) do
        {
          user: {
            email: 'wrong@example.com',
            password: 'SecureP@ss123'
          }
        }
      end

      it "does not sign in the user" do
        post "/sign-in", params: invalid_params
        expect(controller.current_user).to be_nil
      end

      it "renders errors via Inertia" do
        post "/sign-in", params: invalid_params

        json = JSON.parse(response.body)
        expect(json['component']).to eq('Auth/SignIn')
        expect(json['props']['errors']).to be_present
        expect(json['props']['errors']['base']).to include('Invalid email or password')
      end
    end

    context "with invalid password" do
      let(:invalid_params) do
        {
          user: {
            email: 'user@example.com',
            password: 'WrongPassword'
          }
        }
      end

      it "does not sign in the user" do
        post "/sign-in", params: invalid_params
        expect(controller.current_user).to be_nil
      end

      it "renders generic error message" do
        post "/sign-in", params: invalid_params

        json = JSON.parse(response.body)
        expect(json['props']['errors']['base']).to include('Invalid email or password')
      end
    end

    context "with case-insensitive email" do
      it "signs in with uppercase email" do
        params = {
          user: {
            email: 'USER@EXAMPLE.COM',
            password: 'SecureP@ss123'
          }
        }

        post "/sign-in", params: params
        expect(controller.current_user).to eq(user)
      end
    end
  end

  describe "DELETE /sign-out" do
    before { sign_in user }

    it "signs out the user" do
      delete "/sign-out"
      expect(controller.current_user).to be_nil
    end

    it "redirects to root path" do
      delete "/sign-out"
      expect(response).to redirect_to(root_path)
    end
  end
end
