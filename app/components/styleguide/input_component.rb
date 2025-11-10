# frozen_string_literal: true

module Styleguide
  class InputComponent < ViewComponent::Base
    def initialize(
      type: :text,
      placeholder: nil,
      disabled: false,
      class: nil,
      **options
    )
      @type = type
      @placeholder = placeholder
      @disabled = disabled
      @class = binding.local_variable_get(:class)
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
      [
        "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm",
        "transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium",
        "placeholder:text-muted-foreground",
        "focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        "disabled:cursor-not-allowed disabled:opacity-50",
        @class
      ].compact.join(" ")
    end
  end
end
