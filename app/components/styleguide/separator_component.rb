# frozen_string_literal: true

module Styleguide
  class SeparatorComponent < ViewComponent::Base
    ORIENTATIONS = {
      horizontal: "h-[1px] w-full",
      vertical: "h-full w-[1px]"
    }.freeze

    def initialize(orientation: :horizontal, class: nil, **options)
      @orientation = orientation
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(
        class: separator_classes,
        role: "separator",
        "aria-orientation": @orientation,
        **@options
      )
    end

    private

    def separator_classes
      [
        "shrink-0 bg-border",
        ORIENTATIONS[@orientation],
        @class
      ].compact.join(" ")
    end
  end
end
