# frozen_string_literal: true

module Styleguide
  class SidebarComponent < BaseComponent
    renders_one :header
    renders_one :footer
    renders_many :items, ->(label:, href: nil, icon: nil, active: false, **options) {
      SidebarItem.new(label: label, href: href, icon: icon, active: active, **options)
    }
    renders_many :groups, ->(label:, icon: nil, collapsible: true, open: false, **options, &block) {
      SidebarGroup.new(label: label, icon: icon, collapsible: collapsible, open: open, **options, &block)
    }

    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(class: sidebar_classes, **@options) do
        safe_join([
          header,
          tag.nav(class: "flex flex-1 flex-col px-3 py-4") do
            tag.ul(class: "flex flex-1 flex-col gap-y-1") do
              safe_join(all_nav_items)
            end
          end,
          footer
        ].compact)
      end
    end

    private

    def all_nav_items
      (groups + items).compact
    end

    def sidebar_classes
      merge_classes(
        "flex h-full w-64 flex-col border-r bg-background",
        @html_class
      )
    end

    # Sidebar Item Component
    class SidebarItem < BaseComponent
      def initialize(label:, href: nil, icon: nil, active: false, html_class: nil, **options)
        @label = label
        @href = href
        @icon = icon
        @active = active
        @html_class = html_class
        @options = options
      end

      def call
        tag.li do
          if @href
            tag.a(href: @href, class: item_classes, **@options) do
              content
            end
          else
            tag.div(class: item_classes, **@options) do
              content
            end
          end
        end
      end

      private

      def content
        safe_join([
          @icon ? tag.span(class: "mr-2") { @icon } : nil,
          tag.span(@label)
        ].compact)
      end

      def item_classes
        base = "flex items-center gap-2 rounded-md px-3 py-2 text-sm font-medium transition-colors"
        if @active
          merge_classes(base, "bg-accent text-accent-foreground", @html_class)
        else
          merge_classes(base, "text-muted-foreground hover:bg-accent hover:text-accent-foreground", @html_class)
        end
      end
    end

    # Sidebar Group Component (Collapsible)
    class SidebarGroup < BaseComponent
      attr_reader :children_items

      def initialize(label:, icon: nil, collapsible: true, open: false, html_class: nil, **options)
        @label = label
        @icon = icon
        @collapsible = collapsible
        @open = open
        @html_class = html_class
        @options = options
        @children_items = []
      end

      def with_children(label:, href: nil, icon: nil, active: false, **options)
        @children_items << SidebarItem.new(label: label, href: href, icon: icon, active: active, **options)
      end

      def call
        tag.li do
          safe_join([
            render_trigger,
            render_content
          ])
        end
      end

      private

      def render_trigger
        classes = "flex w-full items-center justify-between rounded-md px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-accent-foreground transition-colors"

        if @collapsible
          tag.button(
            class: classes,
            data: {
              controller: "sidebar-group",
              action: "click->sidebar-group#toggle",
              sidebar_group_open_value: @open
            }
          ) do
            safe_join([
              tag.div(class: "flex items-center gap-2") do
                safe_join([
                  @icon ? tag.span(class: "text-base") { @icon } : nil,
                  tag.span(@label)
                ].compact)
              end,
              chevron_icon
            ])
          end
        else
          tag.div(class: classes) do
            safe_join([
              @icon ? tag.span(class: "mr-2") { @icon } : nil,
              tag.span(@label)
            ].compact)
          end
        end
      end

      def render_content
        return nil if children_items.empty?

        tag.ul(
          class: "ml-4 mt-1 space-y-1 border-l pl-3 #{@open ? '' : 'hidden'}",
          data: { sidebar_group_target: "content" }
        ) do
          safe_join(children_items.map { |item| render(item) })
        end
      end

      def chevron_icon
        tag.svg(
          class: "h-4 w-4 transition-transform",
          data: { sidebar_group_target: "icon" },
          fill: "none",
          viewBox: "0 0 24 24",
          stroke_width: "2",
          stroke: "currentColor"
        ) do
          tag.path(
            stroke_linecap: "round",
            stroke_linejoin: "round",
            d: "M19 9l-7 7-7-7"
          )
        end
      end
    end
  end
end
