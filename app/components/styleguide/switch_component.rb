# frozen_string_literal: true

module Styleguide
  # Switch (toggle) component
  #
  # @example Basic usage
  #   <%= render Styleguide::SwitchComponent.new(id: "notifications") %>
  #
  # @example With checked state
  #   <%= render Styleguide::SwitchComponent.new(id: "notifications", checked: true) %>
  class SwitchComponent < BaseComponent
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
      # Using a hidden checkbox + styled label pattern for the switch
      tag.label(
        class: switch_classes,
        data: {
          controller: "switch",
          switch_checked_value: @checked,
          action: "click->switch#toggle"
        },
        **@options
      ) do
        safe_join([
          tag.input(
            type: :checkbox,
            id: @id,
            name: @name,
            checked: @checked,
            disabled: @disabled,
            class: "sr-only peer",
            data: { switch_target: "input" }
          ),
          tag.span(
            class: "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-5 data-[state=unchecked]:translate-x-0",
            data: { switch_target: "thumb" }
          )
        ])
      end
    end

    private

    def switch_classes
      merge_classes(
        "peer inline-flex h-5 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent",
        "shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background",
        "disabled:cursor-not-allowed disabled:opacity-50",
        "data-[state=checked]:bg-primary data-[state=unchecked]:bg-input",
        @html_class
      )
    end
  end
end
