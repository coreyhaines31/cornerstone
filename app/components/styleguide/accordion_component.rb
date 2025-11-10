# frozen_string_literal: true

module Styleguide
  class AccordionComponent < ViewComponent::Base
    renders_many :items, lambda { |value:, class: nil, **options|
      AccordionItem.new(value: value, class: binding.local_variable_get(:class), **options)
    }

    def initialize(type: :single, collapsible: true, class: nil, **options)
      @type = type
      @collapsible = collapsible
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(class: @class, data: { controller: "accordion", accordion_type: @type }, **@options) do
        safe_join(items.map(&:to_s))
      end
    end

    class AccordionItem < ViewComponent::Base
      renders_one :trigger, lambda { |class: nil, **options|
        AccordionTrigger.new(class: binding.local_variable_get(:class), **options)
      }
      renders_one :content, lambda { |class: nil, **options|
        AccordionContent.new(class: binding.local_variable_get(:class), **options)
      }

      def initialize(value:, class: nil, **options)
        @value = value
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(class: item_classes, data: { value: @value }, **@options) do
          safe_join([trigger, content].compact)
        end
      end

      private

      def item_classes
        ["border-b", @class].compact.join(" ")
      end
    end

    class AccordionTrigger < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.button(
          type: :button,
          class: trigger_classes,
          data: { accordion_target: "trigger", action: "click->accordion#toggle" },
          **@options
        ) do
          safe_join([
            tag.span(content, class: "flex-1 text-left"),
            tag.span("▼", class: "transition-transform duration-200 data-[state=open]:rotate-180")
          ])
        end
      end

      private

      def trigger_classes
        [
          "flex flex-1 items-center justify-between py-4 text-sm font-medium transition-all",
          "hover:underline [&[data-state=open]>svg]:rotate-180",
          @class
        ].compact.join(" ")
      end
    end

    class AccordionContent < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(
          class: "overflow-hidden text-sm data-[state=closed]:animate-accordion-up data-[state=open]:animate-accordion-down",
          data: { accordion_target: "content" }
        ) do
          tag.div(content, class: content_classes, **@options)
        end
      end

      private

      def content_classes
        ["pb-4 pt-0", @class].compact.join(" ")
      end
    end
  end
end
