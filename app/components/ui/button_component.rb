class Ui::ButtonComponent < ViewComponent::Base
  VARIANTS = {
    primary: "bg-indigo-600 text-white hover:bg-indigo-500 focus-visible:outline-indigo-600 dark:bg-indigo-500 dark:hover:bg-indigo-400",
    secondary: "bg-white text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 dark:bg-gray-800 dark:text-white dark:ring-gray-700 dark:hover:bg-gray-700",
    danger: "bg-red-600 text-white hover:bg-red-500 focus-visible:outline-red-600 dark:bg-red-500 dark:hover:bg-red-400",
    ghost: "text-gray-900 hover:bg-gray-50 dark:text-white dark:hover:bg-gray-800",
    link: "text-indigo-600 hover:text-indigo-500 dark:text-indigo-400 dark:hover:text-indigo-300"
  }.freeze

  SIZES = {
    xs: "px-2 py-1 text-xs",
    sm: "px-2.5 py-1.5 text-sm",
    md: "px-3 py-2 text-sm",
    lg: "px-3.5 py-2.5 text-sm",
    xl: "px-4 py-3 text-base"
  }.freeze

  def initialize(
    variant: :primary,
    size: :md,
    type: :button,
    disabled: false,
    loading: false,
    full_width: false,
    icon: nil,
    icon_position: :left,
    href: nil,
    method: nil,
    data: {},
    **options
  )
    @variant = variant
    @size = size
    @type = type
    @disabled = disabled || loading
    @loading = loading
    @full_width = full_width
    @icon = icon
    @icon_position = icon_position
    @href = href
    @method = method
    @data = data
    @options = options
  end

  def call
    if @href
      link_to @href, method: @method, data: @data, class: button_classes, **@options do
        button_content
      end
    else
      button_tag type: @type, disabled: @disabled, data: @data, class: button_classes, **@options do
        button_content
      end
    end
  end

  private

  def button_content
    safe_join([
      loading_spinner,
      icon_content(:left),
      content_span,
      icon_content(:right)
    ].compact)
  end

  def content_span
    tag.span(content, class: content_classes)
  end

  def loading_spinner
    return unless @loading

    tag.svg(
      class: "animate-spin -ml-1 mr-2 h-4 w-4",
      xmlns: "http://www.w3.org/2000/svg",
      fill: "none",
      viewBox: "0 0 24 24"
    ) do
      tag.circle(
        class: "opacity-25",
        cx: "12",
        cy: "12",
        r: "10",
        stroke: "currentColor",
        "stroke-width": "4"
      ) +
      tag.path(
        class: "opacity-75",
        fill: "currentColor",
        d: "M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
      )
    end
  end

  def icon_content(position)
    return unless @icon && @icon_position == position

    icon_class = position == :left ? "mr-2" : "ml-2"

    if @icon.start_with?("<svg")
      raw(@icon)
    else
      tag.span(@icon, class: icon_class)
    end
  end

  def button_classes
    classes = [
      "inline-flex items-center justify-center rounded-md font-semibold shadow-sm",
      "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2",
      "disabled:opacity-50 disabled:cursor-not-allowed",
      "transition-colors duration-200",
      VARIANTS[@variant],
      SIZES[@size]
    ]

    classes << "w-full" if @full_width
    classes << "cursor-wait" if @loading

    classes.compact.join(" ")
  end

  def content_classes
    classes = []
    classes << "ml-2" if @loading
    classes.join(" ")
  end
end