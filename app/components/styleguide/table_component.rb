# frozen_string_literal: true

module Styleguide
  class TableComponent < BaseComponent
    renders_one :header, lambda { |html_class: nil, **options|
      TableHeader.new(html_class: html_class, **options)
    }
    renders_one :body, lambda { |html_class: nil, **options|
      TableBody.new(html_class: html_class, **options)
    }
    renders_one :footer, lambda { |html_class: nil, **options|
      TableFooter.new(html_class: html_class, **options)
    }

    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.div(class: "relative w-full overflow-auto") do
        tag.table(class: table_classes, **@options) do
          safe_join([header, body, footer].compact)
        end
      end
    end

    private

    def table_classes
      merge_classes(
        "w-full caption-bottom text-sm",
        @html_class
      )
    end

    class TableHeader < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.thead(content, class: header_classes, **@options)
      end

      private

      def header_classes
        ["[&_tr]:border-b", @html_class].compact.join(" ")
      end
    end

    class TableBody < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.tbody(content, class: body_classes, **@options)
      end

      private

      def body_classes
        ["[&_tr:last-child]:border-0", @html_class].compact.join(" ")
      end
    end

    class TableFooter < BaseComponent
      def initialize(html_class: nil, **options)
        @html_class = html_class
        @options = options
      end

      def call
        tag.tfoot(content, class: footer_classes, **@options)
      end

      private

      def footer_classes
        ["border-t bg-muted/50 font-medium [&>tr]:last:border-b-0", @html_class].compact.join(" ")
      end
    end
  end

  class TableRowComponent < BaseComponent
    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.tr(content, class: row_classes, **@options)
    end

    private

    def row_classes
      [
        "border-b transition-colors duration-200 hover:bg-muted/50 data-[state=selected]:bg-muted",
        @html_class
      ].compact.join(" ")
    end
  end

  class TableHeadComponent < BaseComponent
    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.th(content, class: head_classes, **@options)
    end

    private

    def head_classes
      [
        "h-10 px-2 text-left align-middle font-medium text-muted-foreground",
        "[&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @html_class
      ].compact.join(" ")
    end
  end

  class TableCellComponent < BaseComponent
    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.td(content, class: cell_classes, **@options)
    end

    private

    def cell_classes
      [
        "p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @html_class
      ].compact.join(" ")
    end
  end

  class TableCaptionComponent < BaseComponent
    def initialize(html_class: nil, **options)
      @html_class = html_class
      @options = options
    end

    def call
      tag.caption(content, class: caption_classes, **@options)
    end

    private

    def caption_classes
      merge_classes("mt-4 text-sm text-muted-foreground", @html_class)
    end
  end
end
