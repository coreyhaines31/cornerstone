# frozen_string_literal: true

module Styleguide
  class CardComponent < BaseComponent
    renders_one :header, lambda { |html_class: nil, **options|
      CardHeader.new(html_class: html_class, **options)
    }
    renders_one :title, lambda { |html_class: nil, **options|
      CardTitle.new(html_class: html_class, **options)
    }
    renders_one :description, lambda { |html_class: nil, **options|
      CardDescription.new(html_class: html_class, **options)
    }
    renders_one :body, lambda { |html_class: nil, **options|
      CardContent.new(html_class: html_class, **options)
    }
    renders_one :footer, lambda { |html_class: nil, **options|
      CardFooter.new(html_class: html_class, **options)
    }

    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(class: card_classes, **@options) do
        safe_join([header, title, description, body, footer].compact)
      end
    end

    private

    def card_classes
      merge_classes(
        "flex flex-col justify-center rounded-lg border bg-card text-card-foreground shadow-sm",
        @html_class
      )
    end

    class CardHeader < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(content, class: header_classes, **@options)
      end

      private

      def header_classes
        merge_classes("flex flex-col space-y-1.5 p-6", @html_class)
      end
    end

    class CardTitle < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.h3(content, class: title_classes, **@options)
      end

      private

      def title_classes
        merge_classes("font-semibold leading-none tracking-tight", @html_class)
      end
    end

    class CardDescription < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.p(content, class: description_classes, **@options)
      end

      private

      def description_classes
        merge_classes("text-sm text-muted-foreground", @html_class)
      end
    end

    class CardContent < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(content, class: content_classes, **@options)
      end

      private

      def content_classes
        merge_classes("p-6 pt-0", @html_class)
      end
    end

    class CardFooter < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(content, class: footer_classes, **@options)
      end

      private

      def footer_classes
        merge_classes("flex items-center p-6 pt-0", @html_class)
      end
    end
  end
end
