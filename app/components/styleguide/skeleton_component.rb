# frozen_string_literal: true

module Styleguide
  class SkeletonComponent < BaseComponent
    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(class: skeleton_classes, **@options)
    end

    private

    def skeleton_classes
      merge_classes(
        "animate-pulse rounded-md bg-primary/10",
        @html_class
      )
    end
  end
end
