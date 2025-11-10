# frozen_string_literal: true

module Styleguide
  class CheckboxComponent < ViewComponent::Base
    def initialize(
      id: nil,
      name: nil,
      checked: false,
      disabled: false,
      class: nil,
      **options
    )
      @id = id
      @name = name
      @checked = checked
      @disabled = disabled
      @class = binding.local_variable_get(:class)
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
      [
        "peer h-4 w-4 shrink-0 rounded-sm border border-primary shadow",
        "focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        "disabled:cursor-not-allowed disabled:opacity-50",
        "data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground",
        @class
      ].compact.join(" ")
    end
  end
end
