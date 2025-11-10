# frozen_string_literal: true

module Styleguide
  class TabsComponent < ViewComponent::Base
    renders_one :list, lambda { |class: nil, **options|
      TabsList.new(class: binding.local_variable_get(:class), **options)
    }
    renders_many :triggers, lambda { |value:, class: nil, **options|
      TabsTrigger.new(value: value, class: binding.local_variable_get(:class), **options)
    }
    renders_many :contents, lambda { |value:, class: nil, **options|
      TabsContent.new(value: value, class: binding.local_variable_get(:class), **options)
    }

    def initialize(default_value: nil, class: nil, **options)
      @default_value = default_value
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(class: @class, data: { controller: "tabs", tabs_default_value: @default_value }, **@options) do
        safe_join([list, *triggers, *contents].compact)
      end
    end

    class TabsList < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: list_classes, **@options)
      end

      private

      def list_classes
        [
          "inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground",
          @class
        ].compact.join(" ")
      end
    end

    class TabsTrigger < ViewComponent::Base
      def initialize(value:, class: nil, **options)
        @value = value
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.button(
          content,
          type: :button,
          class: trigger_classes,
          data: { tabs_target: "trigger", value: @value },
          **@options
        )
      end

      private

      def trigger_classes
        [
          "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium",
          "ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2",
          "focus-visible:ring-ring focus-visible:ring-offset-2",
          "disabled:pointer-events-none disabled:opacity-50",
          "data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow",
          @class
        ].compact.join(" ")
      end
    end

    class TabsContent < ViewComponent::Base
      def initialize(value:, class: nil, **options)
        @value = value
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(
          content,
          class: content_classes,
          data: { tabs_target: "content", value: @value },
          **@options
        )
      end

      private

      def content_classes
        [
          "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2",
          "focus-visible:ring-ring focus-visible:ring-offset-2",
          @class
        ].compact.join(" ")
      end
    end
  end
end
