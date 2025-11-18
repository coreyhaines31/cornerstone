# frozen_string_literal: true

require "rails_helper"

RSpec.describe Styleguide::ButtonComponent, type: :component do
  describe "rendering" do
    it "renders a button with default variant" do
      render_inline(described_class.new) { "Click me" }

      expect(page).to have_button("Click me")
      expect(page).to have_css("button.bg-primary")
    end

    it "renders different variants" do
      render_inline(described_class.new(variant: :destructive)) { "Delete" }

      expect(page).to have_button("Delete")
      expect(page).to have_css("button.bg-destructive")
    end

    it "renders different sizes" do
      render_inline(described_class.new(size: :lg)) { "Large" }

      expect(page).to have_button("Large")
      expect(page).to have_css("button.h-11")
    end

    it "renders as a link when href is provided" do
      render_inline(described_class.new(href: "/path")) { "Link" }

      expect(page).to have_link("Link", href: "/path")
    end

    it "applies custom classes" do
      render_inline(described_class.new(html_class: "custom-class")) { "Button" }

      expect(page).to have_css("button.custom-class")
    end

    it "renders disabled button" do
      render_inline(described_class.new(disabled: true)) { "Disabled" }

      expect(page).to have_button("Disabled", disabled: true)
    end
  end
end
