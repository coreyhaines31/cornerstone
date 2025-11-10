# frozen_string_literal: true

# This rake task is a one-time fix to update all components
# Run with: rails fix_components:all

namespace :fix_components do
  desc "Update all styleguide components to use BaseComponent and html_class"
  task all: :environment do
    puts "Fixing all styleguide components..."

    Dir.glob("app/components/styleguide/*_component.rb").each do |file|
      next if file.include?("base_component.rb")

      content = File.read(file)
      original = content.dup

      # Fix inheritance
      content.gsub!(/< ViewComponent::Base/, "< BaseComponent")

      # Fix class parameter
      content.gsub!(/class: nil/, "html_class: nil")
      content.gsub!(/@class = binding\.local_variable_get\(:class\)/, "@html_class = html_class")
      content.gsub!(/@class(?!_)/, "@html_class")

      # Fix merge_classes if joining manually
      content.gsub!(/\[([^\]]+)\]\.compact\.join\(" "\)/, 'merge_classes(\1)')

      if content != original
        File.write(file, content)
        puts "✓ Fixed: #{File.basename(file)}"
      else
        puts "○ Skipped: #{File.basename(file)} (no changes needed)"
      end
    end

    puts "\nAll components updated!"
  end
end
