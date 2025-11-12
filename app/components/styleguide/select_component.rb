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
        "flex h-10 w-full items-center justify-between whitespace-nowrap rounded-md border border-input",
        "bg-background px-3 py-2 text-sm ring-offset-background",
        "focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
        "disabled:cursor-not-allowed disabled:opacity-50",
        "[&>span]:line-clamp-1",
        @html_class
      )
    end
  end
end
