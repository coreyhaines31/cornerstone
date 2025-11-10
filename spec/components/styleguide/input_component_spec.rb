# frozen_string_literal: true

require "rails_helper"

RSpec.describe Styleguide::InputComponent, type: :component do
  describe "rendering" do
    it "renders a text input by default" do
      render_inline(described_class.new)

      expect(page).to have_css("input[type='text']")
    end

    it "renders different input types" do
      render_inline(described_class.new(type: :email))

      expect(page).to have_css("input[type='email']")
    end

    it "renders with placeholder" do
      render_inline(described_class.new(placeholder: "Enter text"))

      expect(page).to have_css("input[placeholder='Enter text']")
    end

    it "renders disabled input" do
      render_inline(described_class.new(disabled: true))

      expect(page).to have_css("input[disabled]")
    end

    it "applies custom classes" do
      render_inline(described_class.new(html_class: "custom-input"))

      expect(page).to have_css("input.custom-input")
    end
  end
end
