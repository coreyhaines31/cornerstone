# frozen_string_literal: true

module Styleguide
  # Dialog (modal) component
  #
  # @example Basic usage
  #   <%= render Styleguide::DialogComponent.new do |c| %>
  #     <% c.with_trigger do %>
  #       <%= ui_button "Open Dialog" %>
  #     <% end %>
  #     <% c.with_header do %>
  #       <% c.with_title { "Dialog Title" } %>
  #       <% c.with_description { "Dialog description" } %>
  #     <% end %>
  #     Content goes here
  #   <% end %>
  class DialogComponent < BaseComponent
    renders_one :trigger, lambda { |html_class: nil, **options|
      DialogTrigger.new(html_class: html_class, **options)
    }
    renders_one :header, lambda { |html_class: nil, **options|
      DialogHeader.new(html_class: html_class, **options)
    }
    renders_one :title, lambda { |html_class: nil, **options|
      DialogTitle.new(html_class: html_class, **options)
    }
    renders_one :description, lambda { |html_class: nil, **options|
      DialogDescription.new(html_class: html_class, **options)
    }
    renders_one :footer, lambda { |html_class: nil, **options|
      DialogFooter.new(html_class: html_class, **options)
    }

    def initialize(id: nil, open: false, html_class: nil, **options)
      @id = id || "dialog-#{SecureRandom.hex(4)}"
      @open = open
      @html_class = html_class
      @options = options
    end

    def call
      safe_join([
        trigger,
        dialog_content
      ].compact)
    end

    private

    def dialog_content
      tag.div(
        class: "fixed inset-0 z-50 #{@open ? 'flex' : 'hidden'} items-center justify-center",
        id: @id,
        data: {
          controller: "dialog",
          dialog_open_value: @open
        }
      ) do
        safe_join([
          # Overlay
          tag.div(
            class: "fixed inset-0 bg-black/80",
            data: {
              dialog_target: "overlay",
              action: "click->dialog#closeOnOverlay"
            }
          ),
          # Content
          tag.div(class: content_classes, data: { dialog_target: "content" }, **@options) do
            safe_join([header, title, description, content, footer].compact)
          end
        ])
      end
    end

    def content_classes
      merge_classes(
        "relative z-50 grid w-full max-w-lg gap-4 border bg-background p-6 shadow-lg",
        "duration-200 sm:rounded-lg",
        @html_class
      )
    end

    class DialogTrigger < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(content, class: @html_class, data: { action: "click->dialog#open" }, **@options)
      end
    end

    class DialogHeader < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(content, class: merge_classes("flex flex-col space-y-1.5 text-center sm:text-left", @html_class), **@options)
      end
    end

    class DialogTitle < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.h2(content, class: merge_classes("text-lg font-semibold leading-none tracking-tight", @html_class), **@options)
      end
    end

    class DialogDescription < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.p(content, class: merge_classes("text-sm text-muted-foreground", @html_class), **@options)
      end
    end

    class DialogFooter < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.div(content, class: merge_classes("flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", @html_class), **@options)
      end
    end
  end
end
