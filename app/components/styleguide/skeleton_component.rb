# frozen_string_literal: true

module Styleguide
  class SkeletonComponent < ViewComponent::Base
    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.div(class: skeleton_classes, **@options)
    end

    private

    def skeleton_classes
      [
        "animate-pulse rounded-md bg-primary/10",
        @class
      ].compact.join(" ")
    end
  end
end
