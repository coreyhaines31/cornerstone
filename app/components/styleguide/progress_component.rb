# frozen_string_literal: true

module Styleguide
  class ProgressComponent < ViewComponent::Base
    def initialize(value: 0, max: 100, class: nil, **options)
      @value = value
      @max = max
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(class: progress_classes, **@options) do
        tag.div(
          class: "h-full w-full flex-1 bg-primary transition-all",
          style: "transform: translateX(-#{100 - percentage}%)"
        )
      end
    end

    private

    def percentage
      return 0 if @max.zero?
      ((@value.to_f / @max) * 100).clamp(0, 100)
    end

    def progress_classes
      [
        "relative h-2 w-full overflow-hidden rounded-full bg-primary/20",
        @class
      ].compact.join(" ")
    end
  end
end
