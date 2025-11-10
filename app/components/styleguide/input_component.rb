# frozen_string_literal: true

module Styleguide
  class InputComponent < BaseComponent
    def initialize(
      type: :text,
      placeholder: nil,
      disabled: false,
      html_class: nil,
      **options
    )
      @type = type
      @placeholder = placeholder
      @disabled = disabled
      @html_class = html_class
      @options = options
    end

    def call
      tag.input(
        type: @type,
        placeholder: @placeholder,
        disabled: @disabled,
        class: input_classes,
        **@options
      )
    end

    private

    def input_classes
      merge_classes(
        "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm",
        "transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium",
        "placeholder:text-muted-foreground",
        "focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        "disabled:cursor-not-allowed disabled:opacity-50",
        @html_class
      )
    end
  end
end
