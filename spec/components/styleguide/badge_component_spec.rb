# frozen_string_literal: true

require "rails_helper"

RSpec.describe Styleguide::BadgeComponent, type: :component do
  describe "rendering" do
    it "renders a badge with default variant" do
      render_inline(described_class.new) { "New" }

      expect(page).to have_text("New")
      expect(page).to have_css("div.bg-primary")
    end

    it "renders different variants" do
      render_inline(described_class.new(variant: :destructive)) { "Error" }

      expect(page).to have_text("Error")
      expect(page).to have_css("div.bg-destructive")
    end

    it "applies custom classes" do
      render_inline(described_class.new(html_class: "my-badge")) { "Badge" }

      expect(page).to have_css("div.my-badge")
    end
  end
end
