require 'rails_helper'

RSpec.describe "Password Reset", type: :request do
  let!(:user) { create(:user, email: 'user@example.com', password: 'OldP@ss123') }

  describe "GET /forgot-password" do
    it "renders the forgot password page via Inertia" do
      get "/forgot-password"

      expect(response).to have_http_status(:success)
      expect(response.headers['X-Inertia']).to eq('true')

      json = JSON.parse(response.body)
      expect(json['component']).to eq('Auth/ForgotPassword')
    end
  end

  describe "POST /forgot-password" do
    context "with valid email" do
      let(:valid_params) do
        {
          user: {
            email: 'user@example.com'
          }
        }
      end

      it "sends password reset email" do
        expect {
          post "/forgot-password", params: valid_params
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end

      it "redirects to sign in with notice" do
        post "/forgot-password", params: valid_params
        expect(response).to redirect_to(new_session_path(:user))
        expect(flash[:notice]).to match(/reset your password/)
      end

      it "generates reset password token" do
        post "/forgot-password", params: valid_params
        user.reload
        expect(user.reset_password_token).to be_present
      end
    end

    context "with invalid email" do
      let(:invalid_params) do
        {
          user: {
            email: 'nonexistent@example.com'
          }
        }
      end

      it "renders errors via Inertia" do
        post "/forgot-password", params: invalid_params

        json = JSON.parse(response.body)
        expect(json['component']).to eq('Auth/ForgotPassword')
        expect(json['props']['errors']).to be_present
      end
    end

    context "with blank email" do
      it "renders validation error" do
        post "/forgot-password", params: { user: { email: '' } }

        json = JSON.parse(response.body)
        expect(json['props']['errors']['email']).to include("can't be blank")
      end
    end
  end

  describe "GET /reset-password" do
    let(:raw_token) { user.send_reset_password_instructions }

    it "renders the reset password page via Inertia" do
      get "/reset-password", params: { reset_password_token: raw_token }

      expect(response).to have_http_status(:success)
      expect(response.headers['X-Inertia']).to eq('true')

      json = JSON.parse(response.body)
      expect(json['component']).to eq('Auth/ResetPassword')
      expect(json['props']['resetPasswordToken']).to eq(raw_token)
      expect(json['props']['minPasswordLength']).to eq(6)
    end
  end

  describe "PUT /reset-password" do
    let(:raw_token) { user.send_reset_password_instructions }

    context "with valid token and password" do
      let(:valid_params) do
        {
          user: {
            reset_password_token: raw_token,
            password: 'NewP@ss123',
            password_confirmation: 'NewP@ss123'
          }
        }
      end

      it "updates the user's password" do
        put "/reset-password", params: valid_params
        user.reload
        expect(user.valid_password?('NewP@ss123')).to be true
      end

      it "signs in the user" do
        put "/reset-password", params: valid_params
        expect(controller.current_user).to eq(user)
      end

      it "clears the reset password token" do
        put "/reset-password", params: valid_params
        user.reload
        expect(user.reset_password_token).to be_nil
      end

      it "redirects to dashboard" do
        put "/reset-password", params: valid_params
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "with mismatched passwords" do
      let(:invalid_params) do
        {
          user: {
            reset_password_token: raw_token,
            password: 'NewP@ss123',
            password_confirmation: 'DifferentP@ss123'
          }
        }
      end

      it "does not update the password" do
        original_encrypted_password = user.encrypted_password
        put "/reset-password", params: invalid_params
        user.reload
        expect(user.encrypted_password).to eq(original_encrypted_password)
      end

      it "renders errors via Inertia" do
        put "/reset-password", params: invalid_params

        json = JSON.parse(response.body)
        expect(json['component']).to eq('Auth/ResetPassword')
        expect(json['props']['errors']['password_confirmation']).to include("doesn't match")
      end
    end

    context "with weak password" do
      let(:invalid_params) do
        {
          user: {
            reset_password_token: raw_token,
            password: 'weak',
            password_confirmation: 'weak'
          }
        }
      end

      it "does not update the password" do
        original_encrypted_password = user.encrypted_password
        put "/reset-password", params: invalid_params
        user.reload
        expect(user.encrypted_password).to eq(original_encrypted_password)
      end

      it "renders password length error" do
        put "/reset-password", params: invalid_params

        json = JSON.parse(response.body)
        expect(json['props']['errors']['password']).to include("is too short")
      end
    end

    context "with invalid token" do
      let(:invalid_params) do
        {
          user: {
            reset_password_token: 'invalid_token',
            password: 'NewP@ss123',
            password_confirmation: 'NewP@ss123'
          }
        }
      end

      it "does not update the password" do
        original_encrypted_password = user.encrypted_password
        put "/reset-password", params: invalid_params
        user.reload
        expect(user.encrypted_password).to eq(original_encrypted_password)
      end

      it "renders token error" do
        put "/reset-password", params: invalid_params

        json = JSON.parse(response.body)
        expect(json['props']['errors']['reset_password_token']).to be_present
      end
    end

    context "with expired token" do
      let(:expired_token) do
        user.send_reset_password_instructions
        # Simulate token expiration
        user.update_column(:reset_password_sent_at, 7.hours.ago)
        user.reset_password_token
      end

      it "does not update the password" do
        params = {
          user: {
            reset_password_token: expired_token,
            password: 'NewP@ss123',
            password_confirmation: 'NewP@ss123'
          }
        }

        original_encrypted_password = user.encrypted_password
        put "/reset-password", params: params
        user.reload
        expect(user.encrypted_password).to eq(original_encrypted_password)
      end
    end
  end
end
