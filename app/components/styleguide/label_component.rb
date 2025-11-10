# frozen_string_literal: true

module Styleguide
  class LabelComponent < BaseComponent
    def initialize(
      for_id: nil,
      html_class: nil,
      **options
    )
      @for_id = for_id
      @html_class = html_class
      @options = options
    end

    def call
      tag.label(
        content,
        for: @for_id,
        class: label_classes,
        **@options
      )
    end

    private

    def label_classes
      merge_classes(
        "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
        @html_class
      )
    end
  end
end
