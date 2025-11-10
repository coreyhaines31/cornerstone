# frozen_string_literal: true

module Styleguide
  class LabelComponent < ViewComponent::Base
    def initialize(
      for_id: nil,
      class: nil,
      **options
    )
      @for_id = for_id
      @class = binding.local_variable_get(:class)
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
      [
        "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
        @class
      ].compact.join(" ")
    end
  end
end
