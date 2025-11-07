#!/usr/bin/env ruby

# Cornerstone Upgrade Script
# Usage: ruby upgrade.rb [version]
# This script helps upgrade existing Cornerstone applications to newer versions

require 'fileutils'
require 'yaml'
require 'net/http'
require 'json'

class CornerstoneUpgrader
  REPO_URL = "https://api.github.com/repos/coreyhaines31/cornerstone"
  RAW_URL = "https://raw.githubusercontent.com/coreyhaines31/cornerstone"

  attr_reader :current_version, :target_version, :dry_run

  def initialize(target_version = nil, dry_run: false)
    @current_version = detect_current_version
    @target_version = target_version || fetch_latest_version
    @dry_run = dry_run
  end

  def upgrade!
    puts "🧱 Cornerstone Upgrade Tool"
    puts "Current version: #{current_version}"
    puts "Target version: #{target_version}"
    puts "Dry run: #{dry_run ? 'Yes' : 'No'}"
    puts

    if current_version == target_version
      puts "✅ Already at version #{target_version}"
      return
    end

    if !version_valid?(target_version)
      puts "❌ Invalid target version: #{target_version}"
      return
    end

    puts "📦 Fetching upgrade manifest..."
    manifest = fetch_upgrade_manifest(target_version)

    if manifest.nil?
      puts "❌ No upgrade manifest found for version #{target_version}"
      return
    end

    apply_upgrades(manifest)

    unless dry_run
      update_version_file(target_version)
      run_post_upgrade_tasks(manifest)
    end

    puts
    puts "✅ Upgrade complete!"
    puts "Please review the CHANGELOG.md for breaking changes and migration notes."
  end

  private

  def detect_current_version
    version_file = '.cornerstone-version'
    if File.exist?(version_file)
      File.read(version_file).strip
    else
      # Check lib/cornerstone/version.rb as fallback
      version_rb = 'lib/cornerstone/version.rb'
      if File.exist?(version_rb)
        content = File.read(version_rb)
        if match = content.match(/VERSION\s*=\s*["'](.+)["']/)
          match[1]
        else
          '0.0.0'
        end
      else
        '0.0.0'
      end
    end
  end

  def fetch_latest_version
    uri = URI("#{REPO_URL}/releases/latest")
    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      data = JSON.parse(response.body)
      data['tag_name'].gsub(/^v/, '')
    else
      puts "⚠️  Could not fetch latest version, defaulting to 1.0.0"
      '1.0.0'
    end
  rescue => e
    puts "⚠️  Error fetching latest version: #{e.message}"
    '1.0.0'
  end

  def version_valid?(version)
    version.match?(/^\d+\.\d+\.\d+/)
  end

  def fetch_upgrade_manifest(version)
    uri = URI("#{RAW_URL}/v#{version}/upgrades/#{version}.yml")
    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      YAML.safe_load(response.body)
    else
      # Try to build a generic manifest
      {
        'version' => version,
        'files' => {
          'update' => [
            'template.rb',
            'lib/cornerstone/version.rb',
            'CHANGELOG.md'
          ]
        },
        'commands' => [
          'bundle update',
          'rails db:migrate'
        ]
      }
    end
  rescue => e
    puts "⚠️  Error fetching upgrade manifest: #{e.message}"
    nil
  end

  def apply_upgrades(manifest)
    # Update files
    if manifest['files']
      if manifest['files']['update']
        puts "\n📝 Updating files..."
        manifest['files']['update'].each do |file|
          update_file(file, manifest['version'])
        end
      end

      if manifest['files']['create']
        puts "\n✨ Creating new files..."
        manifest['files']['create'].each do |file|
          create_file(file, manifest['version'])
        end
      end

      if manifest['files']['delete']
        puts "\n🗑️  Removing deprecated files..."
        manifest['files']['delete'].each do |file|
          delete_file(file)
        end
      end
    end

    # Update gems
    if manifest['gems']
      puts "\n💎 Updating gems..."
      update_gemfile(manifest['gems'])
    end

    # Run migrations
    if manifest['migrations']
      puts "\n🔄 Creating migrations..."
      manifest['migrations'].each do |migration|
        create_migration(migration)
      end
    end
  end

  def update_file(file_path, version)
    remote_url = "#{RAW_URL}/v#{version}/#{file_path}"

    if dry_run
      puts "  Would update: #{file_path}"
      return
    end

    puts "  Updating: #{file_path}"

    # Backup existing file
    if File.exist?(file_path)
      backup_path = "#{file_path}.backup-#{Time.now.strftime('%Y%m%d%H%M%S')}"
      FileUtils.cp(file_path, backup_path)
    end

    # Download new version
    uri = URI(remote_url)
    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      FileUtils.mkdir_p(File.dirname(file_path))
      File.write(file_path, response.body)
      puts "    ✓ Updated"
    else
      puts "    ✗ Could not fetch file"
    end
  rescue => e
    puts "    ✗ Error: #{e.message}"
  end

  def create_file(file_path, version)
    remote_url = "#{RAW_URL}/v#{version}/#{file_path}"

    if dry_run
      puts "  Would create: #{file_path}"
      return
    end

    if File.exist?(file_path)
      puts "  Skipping (exists): #{file_path}"
      return
    end

    puts "  Creating: #{file_path}"

    uri = URI(remote_url)
    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      FileUtils.mkdir_p(File.dirname(file_path))
      File.write(file_path, response.body)
      puts "    ✓ Created"
    else
      puts "    ✗ Could not fetch file"
    end
  rescue => e
    puts "    ✗ Error: #{e.message}"
  end

  def delete_file(file_path)
    if dry_run
      puts "  Would delete: #{file_path}"
      return
    end

    if File.exist?(file_path)
      puts "  Deleting: #{file_path}"
      FileUtils.rm_f(file_path)
      puts "    ✓ Deleted"
    else
      puts "  Skipping (not found): #{file_path}"
    end
  end

  def update_gemfile(gems)
    return if dry_run

    gemfile_content = File.read('Gemfile')

    gems.each do |gem_spec|
      name = gem_spec['name']
      version = gem_spec['version']

      if gemfile_content.match?(/gem\s+['"]#{name}['"]/)
        # Update existing gem
        gemfile_content.gsub!(/gem\s+['"]#{name}['"][^\\n]*/, "gem '#{name}', '#{version}'")
        puts "  Updated gem: #{name} to #{version}"
      else
        # Add new gem
        gemfile_content << "\ngem '#{name}', '#{version}'"
        puts "  Added gem: #{name} #{version}"
      end
    end

    File.write('Gemfile', gemfile_content)
  end

  def create_migration(migration_spec)
    return if dry_run

    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    filename = "db/migrate/#{timestamp}_#{migration_spec['name']}.rb"

    puts "  Creating migration: #{migration_spec['name']}"

    File.write(filename, migration_spec['content'])
  end

  def update_version_file(version)
    File.write('.cornerstone-version', version)

    # Also update lib/cornerstone/version.rb if it exists
    version_rb = 'lib/cornerstone/version.rb'
    if File.exist?(version_rb)
      content = File.read(version_rb)
      content.gsub!(/VERSION\s*=\s*["'][^"']+["']/, "VERSION = \\"#{version}\\"")
      File.write(version_rb, content)
    end
  end

  def run_post_upgrade_tasks(manifest)
    if manifest['commands']
      puts "\n🚀 Running post-upgrade commands..."
      manifest['commands'].each do |command|
        puts "  Running: #{command}"
        system(command)
      end
    end
  end
end

# CLI Interface
if __FILE__ == $0
  require 'optparse'

  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: ruby upgrade.rb [options] [version]"

    opts.on("-d", "--dry-run", "Run in dry-run mode (no changes)") do
      options[:dry_run] = true
    end

    opts.on("-h", "--help", "Show this help message") do
      puts opts
      exit
    end
  end.parse!

  target_version = ARGV[0]
  upgrader = CornerstoneUpgrader.new(target_version, dry_run: options[:dry_run])
  upgrader.upgrade!
end