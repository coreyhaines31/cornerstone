# frozen_string_literal: true

module Styleguide
  class BreadcrumbComponent < ViewComponent::Base
    renders_many :items, lambda { |href: nil, class: nil, **options|
      BreadcrumbItem.new(href: href, class: binding.local_variable_get(:class), **options)
    }

    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.nav(class: @class, "aria-label": "breadcrumb", **@options) do
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

    class BreadcrumbItem < ViewComponent::Base
      def initialize(href: nil, class: nil, **options)
        @href = href
        @class = binding.local_variable_get(:class)
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
        [
          "transition-colors hover:text-foreground",
          @class
        ].compact.join(" ")
      end

      def span_classes
        [
          "font-normal text-foreground",
          @class
        ].compact.join(" ")
      end
    end
  end
end
