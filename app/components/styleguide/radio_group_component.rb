# frozen_string_literal: true

module Styleguide
  class RadioGroupComponent < BaseComponent
    renders_many :items, lambda { |value:, id:, label:, checked: false, **options|
      RadioItem.new(value: value, id: id, label: label, checked: checked, name: @name, **options)
    }

    def initialize(name:, html_class: nil, **options)
      @name = name
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(class: @html_class, **@options) do
        safe_join(items.map(&:to_s))
      end
    end

    class RadioItem < BaseComponent
      def initialize(value:, id:, label:, name:, checked: false, html_class: nil, **options)
        @value = value
        @id = id
        @label = label
        @name = name
        @checked = checked
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(class: "flex items-center space-x-2") do
          safe_join([
            tag.input(
              type: :radio,
              id: @id,
              name: @name,
              value: @value,
              checked: @checked,
              class: radio_classes,
              **@options
            ),
            tag.label(
              @label,
              for: @id,
              class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
            )
          ])
        end
      end

      private

      def radio_classes
        merge_classes(
          "aspect-square h-4 w-4 rounded-full border border-primary text-primary ring-offset-background",
          "focus:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          "disabled:cursor-not-allowed disabled:opacity-50",
          @html_class
        )
      end
    end
  end
end
