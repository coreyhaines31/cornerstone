# frozen_string_literal: true

module Styleguide
  class SeparatorComponent < BaseComponent
    ORIENTATIONS = {
      horizontal: "h-[1px] w-full",
      vertical: "h-full w-[1px]"
    }.freeze

    def initialize(orientation: :horizontal, html_class: nil, **options)
      @orientation = orientation
      @html_class = html_class
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
      merge_classes(
        "shrink-0 bg-border",
        ORIENTATIONS[@orientation],
        @html_class
      )
    end
  end
end
