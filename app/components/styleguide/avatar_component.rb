# frozen_string_literal: true

module Styleguide
  class AvatarComponent < ViewComponent::Base
    renders_one :image, lambda { |src:, alt:, class: nil, **options|
      AvatarImage.new(src: src, alt: alt, class: binding.local_variable_get(:class), **options)
    }
    renders_one :fallback, lambda { |class: nil, **options|
      AvatarFallback.new(class: binding.local_variable_get(:class), **options)
    }

    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(class: avatar_classes, **@options) do
        safe_join([image, fallback].compact)
      end
    end

    private

    def avatar_classes
      [
        "relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full",
        @class
      ].compact.join(" ")
    end

    class AvatarImage < ViewComponent::Base
      def initialize(src:, alt:, class: nil, **options)
        @src = src
        @alt = alt
        @class = binding.local_variable_get(:class)
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
        ["aspect-square h-full w-full", @class].compact.join(" ")
      end
    end

    class AvatarFallback < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: fallback_classes, **@options)
      end

      private

      def fallback_classes
        [
          "flex h-full w-full items-center justify-center rounded-full bg-muted",
          @class
        ].compact.join(" ")
      end
    end
  end
end
