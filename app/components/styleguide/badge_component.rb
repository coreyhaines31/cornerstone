# frozen_string_literal: true

module Styleguide
  class BadgeComponent < BaseComponent
    VARIANTS = {
      default: "border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80",
      secondary: "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
      destructive: "border-transparent bg-destructive text-destructive-foreground shadow hover:bg-destructive/80",
      outline: "text-foreground"
    }.freeze

    def initialize(
      variant: :default,
      html_class: nil,
      **options
    )
      @variant = variant
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(
        content,
        class: badge_classes,
        **@options
      )
    end

    private

    def badge_classes
      merge_classes(
        "inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold",
        "transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
        VARIANTS[@variant],
        @html_class
      )
    end
  end
end
