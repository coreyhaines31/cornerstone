# frozen_string_literal: true

module Styleguide
  class CardComponent < ViewComponent::Base
    renders_one :header, lambda { |class: nil, **options|
      CardHeader.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :title, lambda { |class: nil, **options|
      CardTitle.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :description, lambda { |class: nil, **options|
      CardDescription.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :content, lambda { |class: nil, **options|
      CardContent.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :footer, lambda { |class: nil, **options|
      CardFooter.new(class: binding.local_variable_get(:class), **options)
    }

    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(class: card_classes, **@options) do
        safe_join([header, title, description, content, footer].compact)
      end
    end

    private

    def card_classes
      [
        "rounded-lg border bg-card text-card-foreground shadow",
        @class
      ].compact.join(" ")
    end

    class CardHeader < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: header_classes, **@options)
      end

      private

      def header_classes
        ["flex flex-col space-y-1.5 p-6", @class].compact.join(" ")
      end
    end

    class CardTitle < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.h3(content, class: title_classes, **@options)
      end

      private

      def title_classes
        ["font-semibold leading-none tracking-tight", @class].compact.join(" ")
      end
    end

    class CardDescription < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.p(content, class: description_classes, **@options)
      end

      private

      def description_classes
        ["text-sm text-muted-foreground", @class].compact.join(" ")
      end
    end

    class CardContent < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: content_classes, **@options)
      end

      private

      def content_classes
        ["p-6 pt-0", @class].compact.join(" ")
      end
    end

    class CardFooter < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: footer_classes, **@options)
      end

      private

      def footer_classes
        ["flex items-center p-6 pt-0", @class].compact.join(" ")
      end
    end
  end
end
