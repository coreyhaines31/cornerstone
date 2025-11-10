# frozen_string_literal: true

module Styleguide
  class RadioGroupComponent < ViewComponent::Base
    renders_many :items, lambda { |value:, id:, label:, checked: false, **options|
      RadioItem.new(value: value, id: id, label: label, checked: checked, name: @name, **options)
    }

    def initialize(name:, class: nil, **options)
      @name = name
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(class: @class, **@options) do
        safe_join(items.map(&:to_s))
      end
    end

    class RadioItem < ViewComponent::Base
      def initialize(value:, id:, label:, name:, checked: false, class: nil, **options)
        @value = value
        @id = id
        @label = label
        @name = name
        @checked = checked
        @class = binding.local_variable_get(:class)
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
        [
          "aspect-square h-4 w-4 rounded-full border border-primary text-primary shadow",
          "focus:outline-none focus-visible:ring-1 focus-visible:ring-ring",
          "disabled:cursor-not-allowed disabled:opacity-50",
          @class
        ].compact.join(" ")
      end
    end
  end
end
