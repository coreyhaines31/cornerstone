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
        "flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm",
        "placeholder:text-muted-foreground",
        "focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        "disabled:cursor-not-allowed disabled:opacity-50",
        @html_class
      )
    end
  end
end
