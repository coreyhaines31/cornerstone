# frozen_string_literal: true

module Styleguide
  class TextareaComponent < BaseComponent
    def initialize(
      placeholder: nil,
      disabled: false,
      rows: 3,
      html_class: nil,
      **options
    )
      @placeholder = placeholder
      @disabled = disabled
      @rows = rows
      @html_class = html_class
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
      merge_classes(
        "flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm",
        "ring-offset-background placeholder:text-muted-foreground",
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
        "disabled:cursor-not-allowed disabled:opacity-50",
        @html_class
      )
    end
  end
end
