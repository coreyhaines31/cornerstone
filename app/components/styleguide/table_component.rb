# frozen_string_literal: true

module Styleguide
  class TableComponent < ViewComponent::Base
    renders_one :header, lambda { |class: nil, **options|
      TableHeader.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :body, lambda { |class: nil, **options|
      TableBody.new(class: binding.local_variable_get(:class), **options)
    }
    renders_one :footer, lambda { |class: nil, **options|
      TableFooter.new(class: binding.local_variable_get(:class), **options)
    }

    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
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
      [
        "w-full caption-bottom text-sm",
        @class
      ].compact.join(" ")
    end

    class TableHeader < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.thead(content, class: header_classes, **@options)
      end

      private

      def header_classes
        ["[&_tr]:border-b", @class].compact.join(" ")
      end
    end

    class TableBody < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.tbody(content, class: body_classes, **@options)
      end

      private

      def body_classes
        ["[&_tr:last-child]:border-0", @class].compact.join(" ")
      end
    end

    class TableFooter < ViewComponent::Base
      def initialize(class: nil, **options)
        @class = binding.local_variable_get(:class)
        @options = options
      end

      def call
        tag.tfoot(content, class: footer_classes, **@options)
      end

      private

      def footer_classes
        ["border-t bg-muted/50 font-medium [&>tr]:last:border-b-0", @class].compact.join(" ")
      end
    end
  end

  class TableRowComponent < ViewComponent::Base
    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.tr(content, class: row_classes, **@options)
    end

    private

    def row_classes
      [
        "border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted",
        @class
      ].compact.join(" ")
    end
  end

  class TableHeadComponent < ViewComponent::Base
    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
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
        @class
      ].compact.join(" ")
    end
  end

  class TableCellComponent < ViewComponent::Base
    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.td(content, class: cell_classes, **@options)
    end

    private

    def cell_classes
      [
        "p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @class
      ].compact.join(" ")
    end
  end

  class TableCaptionComponent < ViewComponent::Base
    def initialize(class: nil, **options)
      @class = binding.local_variable_get(:class)
      @options = options
    end

    def call
      tag.caption(content, class: caption_classes, **@options)
    end

    private

    def caption_classes
      ["mt-4 text-sm text-muted-foreground", @class].compact.join(" ")
    end
  end
end
