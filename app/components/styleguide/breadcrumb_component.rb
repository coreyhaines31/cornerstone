# frozen_string_literal: true

module Styleguide
  class BreadcrumbComponent < BaseComponent
    renders_many :items, lambda { |href: nil, html_class: nil, **options|
      BreadcrumbItem.new(href: href, html_class: html_class, **options)
    }

    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.nav(class: @html_class, "aria-label": "breadcrumb", **@options) do
        tag.ol(class: "flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5") do
          safe_join(
            items.map.with_index do |item, index|
              safe_join([
                item,
                (index < items.size - 1 ? separator : nil)
              ].compact)
            end
          )
        end
      end
    end

    private

    def separator
      tag.li(
        "/",
        role: "presentation",
        "aria-hidden": "true",
        class: "text-muted-foreground"
      )
    end

    class BreadcrumbItem < BaseComponent
      def initialize(href: nil, html_class: nil, **options)
        @href = href
        @html_class = html_class
        @options = options
      end

      def call
        tag.li(class: "inline-flex items-center gap-1.5") do
          if @href
            link_to @href, class: link_classes, **@options do
              content
            end
          else
            tag.span(content, class: span_classes, **@options)
          end
        end
      end

      private

      def link_classes
        merge_classes(
          "transition-colors hover:text-foreground",
          @html_class
        )
      end

      def span_classes
        merge_classes(
          "font-normal text-foreground",
          @html_class
        )
      end
    end
  end
end
