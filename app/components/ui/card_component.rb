class Ui::CardComponent < ViewComponent::Base
  renders_one :header
  renders_one :footer

  def initialize(
    padding: true,
    shadow: true,
    rounded: true,
    border: true,
    hover: false,
    **options
  )
    @padding = padding
    @shadow = shadow
    @rounded = rounded
    @border = border
    @hover = hover
    @options = options
  end

  def call
    tag.div(class: card_classes, **@options) do
      safe_join([
        header_content,
        body_content,
        footer_content
      ].compact)
    end
  end

  private

  def card_classes
    classes = ["bg-white dark:bg-gray-800"]

    classes << "p-6" if @padding
    classes << "shadow-sm" if @shadow
    classes << "rounded-lg" if @rounded
    classes << "ring-1 ring-gray-200 dark:ring-gray-700" if @border
    classes << "transition-shadow hover:shadow-md" if @hover

    classes.join(" ")
  end

  def header_content
    return unless header?

    tag.div(class: header_classes) do
      header
    end
  end

  def body_content
    tag.div(class: body_classes) do
      content
    end
  end

  def footer_content
    return unless footer?

    tag.div(class: footer_classes) do
      footer
    end
  end

  def header_classes
    classes = []
    classes << "-m-6 mb-6 px-6 py-4" if @padding
    classes << "border-b border-gray-200 dark:border-gray-700"
    classes.join(" ")
  end

  def body_classes
    ""
  end

  def footer_classes
    classes = []
    classes << "-m-6 mt-6 px-6 py-4" if @padding
    classes << "border-t border-gray-200 dark:border-gray-700"
    classes << "bg-gray-50 dark:bg-gray-900/50"
    classes << "rounded-b-lg" if @rounded
    classes.join(" ")
  end
end