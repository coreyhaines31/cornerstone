# frozen_string_literal: true

module Styleguide
  class ButtonComponent < BaseComponent
    VARIANTS = {
      default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
      destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
      outline: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
      secondary: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
      ghost: "hover:bg-accent hover:text-accent-foreground",
      link: "text-primary underline-offset-4 hover:underline"
    }.freeze

    SIZES = {
      default: "h-9 px-4 py-2",
      sm: "h-8 rounded-md px-3 text-xs",
      lg: "h-10 rounded-md px-8",
      icon: "h-9 w-9"
    }.freeze

    def initialize(
      variant: :default,
      size: :default,
      type: :button,
      disabled: false,
      href: nil,
      html_class: nil,
      **options
    )
      @variant = variant
      @size = size
      @type = type
      @disabled = disabled
      @href = href
      @html_class = html_class
      @options = options
    end

    def call
      if @href
        link_to @href, class: button_classes, **@options do
          content
        end
      else
        button_tag type: @type, disabled: @disabled, class: button_classes, **@options do
          content
        end
      end
    end

    private

    def button_classes
      merge_classes(
        "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium",
        "transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        "disabled:pointer-events-none disabled:opacity-50",
        VARIANTS[@variant],
        SIZES[@size],
        @html_class
      )
    end
  end
end
