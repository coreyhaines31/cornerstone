# frozen_string_literal: true

module Styleguide
  class AccordionComponent < BaseComponent
    renders_many :items, lambda { |value:, html_class: nil, **options|
      AccordionItem.new(value: value, html_class: html_class, **options)
    }

    def initialize(type: :single, collapsible: true, html_class: nil, **options)
      @type = type
      @collapsible = collapsible
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(class: @html_class, data: { controller: "accordion", accordion_type: @type }, **@options) do
        safe_join(items.map(&:to_s))
      end
    end

    class AccordionItem < BaseComponent
      renders_one :trigger, lambda { |html_class: nil, **options|
        AccordionTrigger.new(html_class: html_class, **options)
      }
      renders_one :content, lambda { |html_class: nil, **options|
        AccordionContent.new(html_class: html_class, **options)
      }

      def initialize(value:, html_class: nil, **options)
        @value = value
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(class: item_classes, data: { value: @value }, **@options) do
          safe_join([trigger, content].compact)
        end
      end

      private

      def item_classes
        merge_classes("border-b", @html_class)
      end
    end

    class AccordionTrigger < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
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
          @html_class
        ].compact.join(" ")
      end
    end

    class AccordionContent < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
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
        merge_classes("pb-4 pt-0", @html_class)
      end
    end
  end
end
