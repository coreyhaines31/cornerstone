require 'rails_helper'

RSpec.describe "Sign Up", type: :request do
  describe "GET /sign-up" do
    it "renders the sign up page via Inertia" do
      get "/sign-up", headers: { 'X-Inertia' => 'true', 'X-Inertia-Version' => '1' }

      expect(response).to have_http_status(:success)
      expect(response.headers['X-Inertia']).to eq('true')

      json = JSON.parse(response.body)
      expect(json['component']).to eq('Auth/SignUp')
      expect(json['props']['minPasswordLength']).to eq(6)
    end
  end

  describe "POST /sign-up" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            email: 'newuser@example.com',
            password: 'SecureP@ss123'
          }
        }
      end

      it "creates a new user" do
        expect {
          post "/sign-up", params: valid_params
        }.to change(User, :count).by(1)
      end

      it "creates a default account for the user" do
        expect {
          post "/sign-up", params: valid_params
        }.to change(Account, :count).by(1)

        user = User.last
        account = Account.last
        expect(account.name).to eq("My Account")
        expect(account.memberships.first.user).to eq(user)
        expect(account.memberships.first.role).to eq('owner')
      end

      it "signs in the user" do
        post "/sign-up", params: valid_params
        expect(controller.current_user).to eq(User.last)
      end

      it "redirects to dashboard" do
        post "/sign-up", params: valid_params
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            email: 'invalid',
            password: 'short'
          }
        }
      end

      it "does not create a user" do
        expect {
          post "/sign-up", params: invalid_params
        }.not_to change(User, :count)
      end

      it "renders errors via Inertia" do
        post "/sign-up", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['component']).to eq('Auth/SignUp')
        expect(json['props']['errors']).to be_present
      end
    end

    context "with duplicate email" do
      let!(:existing_user) { create(:user, email: 'existing@example.com') }

      let(:duplicate_params) do
        {
          user: {
            email: 'existing@example.com',
            password: 'SecureP@ss123'
          }
        }
      end

      it "does not create a user" do
        expect {
          post "/sign-up", params: duplicate_params
        }.not_to change(User, :count)
      end

      it "renders email validation error" do
        post "/sign-up", params: duplicate_params

        json = JSON.parse(response.body)
        expect(json['props']['errors']['email']).to include('has already been taken')
      end
    end

    context "password strength requirements" do
      it "accepts password meeting minimum length" do
        params = {
          user: {
            email: 'test@example.com',
            password: 'Abc123!'
          }
        }

        expect {
          post "/sign-up", params: params
        }.to change(User, :count).by(1)
      end

      it "rejects password below minimum length" do
        params = {
          user: {
            email: 'test@example.com',
            password: 'Ab1!'
          }
        }

        expect {
          post "/sign-up", params: params
        }.not_to change(User, :count)
      end
    end
  end
end
