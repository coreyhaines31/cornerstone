# frozen_string_literal: true

module Styleguide
  class AvatarComponent < BaseComponent
    renders_one :image, lambda { |src:, alt:, html_class: nil, **options|
      AvatarImage.new(src: src, alt: alt, html_class: html_class, **options)
    }
    renders_one :fallback, lambda { |html_class: nil, **options|
      AvatarFallback.new(html_class: html_class, **options)
    }

    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(class: avatar_classes, **@options) do
        safe_join([image, fallback].compact)
      end
    end

    private

    def avatar_classes
      merge_classes(
        "relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full",
        @html_class
      )
    end

    class AvatarImage < BaseComponent
      def initialize(src:, alt:, html_class: nil, **options)
        @src = src
        @alt = alt
        @html_class = html_class
        @options = options
      end

      def call
        tag.img(
          src: @src,
          alt: @alt,
          class: image_classes,
          **@options
        )
      end

      private

      def image_classes
        merge_classes("aspect-square h-full w-full", @html_class)
      end
    end

    class AvatarFallback < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(content, class: fallback_classes, **@options)
      end

      private

      def fallback_classes
        merge_classes(
          "flex h-full w-full items-center justify-center rounded-full bg-muted",
          @html_class
        )
      end
    end
  end
end
