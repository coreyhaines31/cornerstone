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
        "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base",
        "ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground",
        "placeholder:text-muted-foreground",
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
        "disabled:cursor-not-allowed disabled:opacity-50",
        "md:text-sm",
        @html_class
      )
    end
  end
end
