# frozen_string_literal: true

module Styleguide
  class CheckboxComponent < BaseComponent
    def initialize(
      id: nil,
      name: nil,
      checked: false,
      disabled: false,
      html_class: nil,
      **options
    )
      @id = id
      @name = name
      @checked = checked
      @disabled = disabled
      @html_class = html_class
      @options = options
    end

    def call
      tag.input(
        type: :checkbox,
        id: @id,
        name: @name,
        checked: @checked,
        disabled: @disabled,
        class: checkbox_classes,
        **@options
      )
    end

    private

    def checkbox_classes
      merge_classes(
        "peer h-4 w-4 shrink-0 rounded-sm border border-primary ring-offset-background",
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
        "disabled:cursor-not-allowed disabled:opacity-50",
        "data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground",
        @html_class
      )
    end
  end
end
