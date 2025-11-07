require_relative '../base_generator'

module Cornerstone
  module Generators
    class SeoGenerator < BaseGenerator
      source_root File.expand_path('templates', __dir__)

      def create_models
        generate "model", "SeoPage",
                 "path:string:uniq",
                 "title:string",
                 "meta_description:text",
                 "canonical_url:string",
                 "og_title:string",
                 "og_description:text",
                 "og_image:string",
                 "twitter_card:string",
                 "structured_data:jsonb",
                 "noindex:boolean",
                 "nofollow:boolean"

        generate "model", "SeoTemplate",
                 "name:string:uniq",
                 "pattern:string",
                 "title_template:string",
                 "meta_template:text",
                 "dataset:jsonb"

        generate "model", "Redirect",
                 "from_path:string:uniq",
                 "to_path:string",
                 "status:integer"
      end

      def create_services
        template "seo_service.rb", "app/services/seo_service.rb"
        template "sitemap_generator.rb", "app/services/sitemap_generator.rb"
      end

      def create_middleware
        template "redirect_middleware.rb", "app/middleware/redirect_middleware.rb"
      end

      def add_routes
        route "get '/sitemap.xml', to: 'sitemaps#show'"
        route "get '/robots.txt', to: 'robots#show'"
      end

      def update_configuration
        gsub_file "config/cornerstone.yml",
                  "seo: false",
                  "seo: true"
      end
    end
  end
end