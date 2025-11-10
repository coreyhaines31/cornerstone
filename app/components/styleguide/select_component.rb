# frozen_string_literal: true

module Styleguide
  class SelectComponent < BaseComponent
    def initialize(
      name: nil,
      id: nil,
      disabled: false,
      html_class: nil,
      **options
    )
      @name = name
      @id = id
      @disabled = disabled
      @html_class = html_class
      @options = options
    end

    def call
      tag.select(
        content,
        name: @name,
        id: @id,
        disabled: @disabled,
        class: select_classes,
        **@options
      )
    end

    private

    def select_classes
      merge_classes(
        "flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input",
        "bg-transparent px-3 py-2 text-sm shadow-sm",
        "focus:outline-none focus:ring-1 focus:ring-ring",
        "disabled:cursor-not-allowed disabled:opacity-50",
        "[&>span]:line-clamp-1",
        @html_class
      )
    end
  end
end
