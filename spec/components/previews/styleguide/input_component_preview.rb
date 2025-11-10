# frozen_string_literal: true

module Styleguide
  # @label Input
  class InputComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render(Styleguide::InputComponent.new(placeholder: "Enter text..."))
    end

    # @label Email
    def email
      render(Styleguide::InputComponent.new(type: :email, placeholder: "email@example.com"))
    end

    # @label Password
    def password
      render(Styleguide::InputComponent.new(type: :password, placeholder: "Enter password"))
    end

    # @label Disabled
    def disabled
      render(Styleguide::InputComponent.new(disabled: true, value: "Disabled input"))
    end

    # @label With Label
    def with_label
      render_with_template
    end
  end
end
