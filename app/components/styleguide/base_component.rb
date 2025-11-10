# frozen_string_literal: true

module Styleguide
  # Base component class that all Styleguide components inherit from
  # Provides common functionality like class merging
  class BaseComponent < ViewComponent::Base
    private

    # Merge multiple CSS class strings, filtering out nils and empty strings
    # @param classes [Array<String, nil>] CSS classes to merge
    # @return [String] Merged CSS classes
    def merge_classes(*classes)
      classes.compact.reject(&:empty?).join(" ")
    end
  end
end
