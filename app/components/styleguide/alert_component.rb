# frozen_string_literal: true

module Styleguide
  class AlertComponent < ViewComponent::Base
    renders_one :title, lambda { |class: nil, **options|
      AlertTitle.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :description, lambda { |class: nil, **options|
      AlertDescription.new(class: binding.local_variable_get(:class), **options)
    }

    VARIANTS = {
      default: "bg-background text-foreground",
      destructive: "border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive"
    }.freeze

    def initialize(variant: :default, class: nil, **options)
      @variant = variant
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(class: alert_classes, role: "alert", **@options) do
        safe_join([title, description, content].compact)
      end
    end

    private

    def alert_classes
      [
        "relative w-full rounded-lg border px-4 py-3 text-sm",
        "[&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground",
        "[&>svg~*]:pl-7",
        VARIANTS[@variant],
        @class
      ].compact.join(" ")
    end

    class AlertTitle < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.h5(content, class: title_classes, **@options)
      end

      private

      def title_classes
        ["mb-1 font-medium leading-none tracking-tight", @class].compact.join(" ")
      end
    end

    class AlertDescription < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.div(content, class: description_classes, **@options)
      end

      private

      def description_classes
        ["text-sm [&_p]:leading-relaxed", @class].compact.join(" ")
      end
    end
  end
end
