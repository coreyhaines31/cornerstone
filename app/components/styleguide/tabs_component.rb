# frozen_string_literal: true

module Styleguide
  # Tabs component for tabbed interfaces
  #
  # @example Basic usage
  #   <%= render Styleguide::TabsComponent.new(default_value: "tab1") do |c| %>
  #     <% c.with_list do %>
  #       <% c.with_trigger(value: "tab1") { "Tab 1" } %>
  #       <% c.with_trigger(value: "tab2") { "Tab 2" } %>
  #     <% end %>
  #     <% c.with_content(value: "tab1") { "Content 1" } %>
  #     <% c.with_content(value: "tab2") { "Content 2" } %>
  #   <% end %>
  class TabsComponent < BaseComponent
    renders_one :list, lambda { |html_class: nil, **options|
      TabsList.new(html_class: html_class, **options)
    }
    renders_many :triggers, lambda { |value:, html_class: nil, **options|
      TabsTrigger.new(value: value, html_class: html_class, **options)
    }
    renders_many :contents, lambda { |value:, html_class: nil, **options|
      TabsContent.new(value: value, html_class: html_class, **options)
    }

    def initialize(default_value: nil, html_class: nil, **options)
      @default_value = default_value
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(
        class: @html_class,
        data: {
          controller: "tabs",
          tabs_default_value: @default_value
        },
        **@options
      ) do
        safe_join([list, *triggers, *contents].compact)
      end
    end

    class TabsList < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(content, class: list_classes, **@options)
      end

      private

      def list_classes
        merge_classes(
          "inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground",
          @html_class
        )
      end
    end

    class TabsTrigger < BaseComponent
      def initialize(value:, html_class: nil, **options)
        @value = value
        @html_class = html_class
        @options = options
      end

      def call
        tag.button(
          content,
          type: :button,
          class: trigger_classes,
          data: {
            tabs_target: "trigger",
            value: @value,
            action: "click->tabs#switch"
          },
          **@options
        )
      end

      private

      def trigger_classes
        merge_classes(
          "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium",
          "ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2",
          "focus-visible:ring-ring focus-visible:ring-offset-2",
          "disabled:pointer-events-none disabled:opacity-50",
          "data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow",
          @html_class
        )
      end
    end

    class TabsContent < BaseComponent
      def initialize(value:, html_class: nil, **options)
        @value = value
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(
          content,
          class: merge_classes(
            "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2",
            "focus-visible:ring-ring focus-visible:ring-offset-2",
            "hidden",
            @html_class
          ),
          data: {
            tabs_target: "content",
            value: @value
          },
          **@options
        )
      end
    end
  end
end
