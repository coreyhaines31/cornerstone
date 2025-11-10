# frozen_string_literal: true

module Styleguide
  class SwitchComponent < ViewComponent::Base
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
      # Using a hidden checkbox + styled label pattern for the switch
      tag.label(class: switch_classes, **@options) do
        safe_join([
          tag.input(
            type: :checkbox,
            id: @id,
            name: @name,
            checked: @checked,
            disabled: @disabled,
            class: "sr-only peer"
          ),
          tag.span(
            class: "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-5 data-[state=unchecked]:translate-x-0"
          )
        ])
      end
    end

    private

    def switch_classes
      [
        "peer inline-flex h-5 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent",
        "shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background",
        "disabled:cursor-not-allowed disabled:opacity-50",
        "data-[state=checked]:bg-primary data-[state=unchecked]:bg-input",
        @class
      ].compact.join(" ")
    end
  end
end
