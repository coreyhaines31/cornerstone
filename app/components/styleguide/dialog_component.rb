# frozen_string_literal: true

module Styleguide
  class DialogComponent < ViewComponent::Base
    renders_one :trigger, lambda { |class: nil, **options|
      DialogTrigger.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :header, lambda { |class: nil, **options|
      DialogHeader.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :title, lambda { |class: nil, **options|
      DialogTitle.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :description, lambda { |class: nil, **options|
      DialogDescription.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :footer, lambda { |class: nil, **options|
      DialogFooter.new(class: binding.local_variable_get(:class), **options)
    }

    def initialize(id: nil, open: false, class: nil, **options)
      @id = id || "dialog-#{SecureRandom.hex(4)}"
      @open = open
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      safe_join([
        trigger,
        dialog_content
      ].compact)
    end

    private

    def dialog_content
      tag.div(class: "fixed inset-0 z-50 #{@open ? 'flex' : 'hidden'} items-center justify-center", id: @id) do
        safe_join([
          # Overlay
          tag.div(class: "fixed inset-0 bg-black/80", data: { action: "click->dialog#close" }),
          # Content
          tag.div(class: content_classes, **@options) do
            safe_join([header, title, description, content, footer].compact)
          end
        ])
      end
    end

    def content_classes
      [
        "relative z-50 grid w-full max-w-lg gap-4 border bg-background p-6 shadow-lg",
        "duration-200 sm:rounded-lg",
        @class
      ].compact.join(" ")
    end

    class DialogTrigger < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: @class, **@options)
      end
    end

    class DialogHeader < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: header_classes, **@options)
      end

      private

      def header_classes
        ["flex flex-col space-y-1.5 text-center sm:text-left", @class].compact.join(" ")
      end
    end

    class DialogTitle < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.h2(content, class: title_classes, **@options)
      end

      private

      def title_classes
        ["text-lg font-semibold leading-none tracking-tight", @class].compact.join(" ")
      end
    end

    class DialogDescription < ViewComponent::Base
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

    class DialogFooter < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: footer_classes, **@options)
      end

      private

      def footer_classes
        ["flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", @class].compact.join(" ")
      end
    end
  end
end
