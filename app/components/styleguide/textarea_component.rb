# frozen_string_literal: true

module Styleguide
  class TextareaComponent < ViewComponent::Base
    def initialize(
      placeholder: nil,
      disabled: false,
      rows: 3,
      class: nil,
      **options
    )
      @placeholder = placeholder
      @disabled = disabled
      @rows = rows
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.textarea(
        content,
        placeholder: @placeholder,
        disabled: @disabled,
        rows: @rows,
        class: textarea_classes,
        **@options
      )
    end

    private

    def textarea_classes
      [
        "flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm",
        "placeholder:text-muted-foreground",
        "focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        "disabled:cursor-not-allowed disabled:opacity-50",
        @class
      ].compact.join(" ")
    end
  end
end
