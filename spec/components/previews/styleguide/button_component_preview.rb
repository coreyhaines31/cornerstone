# frozen_string_literal: true

module Styleguide
  # @label Button
  class ButtonComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render(Styleguide::ButtonComponent.new) { "Click me" }
    end

    # @label Variants
    def variants
      render_with_template
    end

    # @label Sizes
    def sizes
      render_with_template
    end

    # @label With Icon
    def with_icon
      render_with_template
    end

    # @label Disabled
    def disabled
      render(Styleguide::ButtonComponent.new(disabled: true)) { "Disabled" }
    end

    # @label As Link
    def as_link
      render(Styleguide::ButtonComponent.new(href: "#")) { "Link Button" }
    end
  end
end
