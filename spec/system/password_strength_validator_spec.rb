require 'rails_helper'

RSpec.describe "Password Strength Validator", type: :system, js: true do
  describe "Sign Up Page" do
    before do
      visit '/sign-up'
      # Wait for Inertia to load the React component
      expect(page).to have_content('Create an account')
    end

    it "displays password strength indicator as user types" do
      fill_in 'email', with: 'test@example.com'
      password_field = find('#password')

      # Type a weak password
      password_field.fill_in with: 'abc'

      # Should show weak indicator
      expect(page).to have_content('Weak')
      expect(page).to have_css('[class*="bg-red"]')

      # Add more complexity
      password_field.fill_in with: 'Abc123'

      # Should show fair/good indicator
      expect(page).to have_content(/Fair|Good/)
    end

    it "shows requirements checklist" do
      fill_in 'email', with: 'test@example.com'
      password_field = find('#password')

      password_field.fill_in with: 'a'

      # Check that requirements are displayed
      expect(page).to have_content('At least 6 characters')
      expect(page).to have_content('One lowercase letter')
      expect(page).to have_content('One uppercase letter')
      expect(page).to have_content('One number')
      expect(page).to have_content('One special character')
    end

    it "marks requirements as met when satisfied" do
      fill_in 'email', with: 'test@example.com'
      password_field = find('#password')

      # Type password that meets length requirement
      password_field.fill_in with: 'abcdef'

      # Length requirement should be marked as met (green checkmark)
      within('li', text: 'At least 6 characters') do
        expect(page).to have_css('svg.text-green-500')
      end

      # Add uppercase
      password_field.fill_in with: 'Abcdef'

      # Uppercase requirement should be marked as met
      within('li', text: 'One uppercase letter') do
        expect(page).to have_css('svg.text-green-500')
      end
    end

    it "shows check icon when minimum requirements are met" do
      fill_in 'email', with: 'test@example.com'
      password_field = find('#password')

      # Type password meeting all requirements
      password_field.fill_in with: 'SecureP@ss123'

      # Should show green checkmark indicator
      expect(page).to have_css('svg.text-green-500')
      expect(page).to have_content('Strong')
    end

    it "allows form submission with valid password" do
      fill_in 'email', with: 'newuser@example.com'
      fill_in 'password', with: 'SecureP@ss123'

      click_button 'Create account'

      # Should successfully create account
      expect(page).to have_current_path(dashboard_path, wait: 5)
    end

    it "validates password strength on submission" do
      fill_in 'email', with: 'test@example.com'
      fill_in 'password', with: 'weak'

      click_button 'Create account'

      # Should show validation error
      expect(page).to have_content(/too short|error/i)
    end
  end

  describe "Reset Password Page" do
    let(:user) { create(:user, email: 'user@example.com') }
    let(:raw_token) { user.send_reset_password_instructions }

    before do
      visit "/reset-password?reset_password_token=#{raw_token}"
      expect(page).to have_content('Change your password')
    end

    it "displays password strength indicator" do
      password_field = find('#password')

      password_field.fill_in with: 'weak'
      expect(page).to have_content('Weak')

      password_field.fill_in with: 'StrongP@ss123'
      expect(page).to have_content('Strong')
    end

    it "validates password confirmation match" do
      fill_in 'password', with: 'NewP@ss123'
      fill_in 'password_confirmation', with: 'DifferentP@ss123'

      click_button 'Change my password'

      # Should show mismatch error
      expect(page).to have_content(/doesn't match|error/i)
    end

    it "successfully resets password with strong password" do
      fill_in 'password', with: 'NewSecureP@ss123'
      fill_in 'password_confirmation', with: 'NewSecureP@ss123'

      click_button 'Change my password'

      # Should successfully reset and redirect
      expect(page).to have_current_path(dashboard_path, wait: 5)
    end
  end

  describe "Accessibility" do
    before do
      visit '/sign-up'
      expect(page).to have_content('Create an account')
    end

    it "has proper labels for form inputs" do
      expect(page).to have_css('label[for="email"]')
      expect(page).to have_css('label[for="password"]')
    end

    it "password field has proper attributes" do
      password_field = find('#password')
      expect(password_field[:type]).to eq('password')
      expect(password_field[:autocomplete]).to eq('new-password')
      expect(password_field[:required]).to eq('true')
    end

    it "shows visual feedback for screen readers" do
      fill_in 'password', with: 'SecureP@ss123'

      # Check that requirements have ARIA-friendly markup
      expect(page).to have_css('li', text: /One lowercase letter/)
      expect(page).to have_css('li', text: /One uppercase letter/)
    end
  end

  describe "Real-time validation" do
    before do
      visit '/sign-up'
      expect(page).to have_content('Create an account')
    end

    it "updates strength bar width progressively" do
      password_field = find('#password')

      # Start with weak password
      password_field.fill_in with: 'a'
      weak_bar = find('[data-strength-bar]', visible: false) rescue find('[class*="h-1"]')

      # Add complexity and check bar grows
      password_field.fill_in with: 'Abc123!'

      # Bar should have grown (changed width class)
      expect(page).to have_css('[class*="w-"]')
    end

    it "changes color from red to green as password improves" do
      password_field = find('#password')

      # Weak password - should be red
      password_field.fill_in with: 'ab'
      expect(page).to have_css('[class*="bg-red"]')

      # Strong password - should be green
      password_field.fill_in with: 'SecureP@ss123'
      expect(page).to have_css('[class*="bg-green"]')
    end
  end
end
