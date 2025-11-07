class Ui::ModalComponent < ViewComponent::Base
  renders_one :header
  renders_one :footer

  SIZES = {
    sm: "sm:max-w-md",
    md: "sm:max-w-lg",
    lg: "sm:max-w-2xl",
    xl: "sm:max-w-4xl",
    full: "sm:max-w-7xl"
  }.freeze

  def initialize(
    id:,
    size: :md,
    closeable: true,
    backdrop: true,
    **options
  )
    @id = id
    @size = size
    @closeable = closeable
    @backdrop = backdrop
    @options = options
  end

  def call
    tag.div(
      id: @id,
      class: "hidden",
      data: {
        controller: "modal",
        modal_backdrop_value: @backdrop,
        modal_closeable_value: @closeable
      },
      **@options
    ) do
      backdrop + modal_container
    end
  end

  private

  def backdrop
    return "".html_safe unless @backdrop

    tag.div(
      class: "fixed inset-0 bg-gray-500 dark:bg-gray-900 bg-opacity-75 dark:bg-opacity-75 transition-opacity",
      data: { modal_target: "backdrop" }
    )
  end

  def modal_container
    tag.div(
      class: "fixed inset-0 z-10 overflow-y-auto",
      data: { modal_target: "container" }
    ) do
      tag.div(
        class: "flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
      ) do
        modal_panel
      end
    end
  end

  def modal_panel
    tag.div(
      class: modal_panel_classes,
      data: { modal_target: "panel" }
    ) do
      safe_join([
        close_button,
        modal_header,
        modal_body,
        modal_footer
      ].compact)
    end
  end

  def close_button
    return unless @closeable

    tag.div(class: "absolute right-0 top-0 pr-4 pt-4 sm:block") do
      button_tag(
        type: "button",
        class: "rounded-md bg-white dark:bg-gray-800 text-gray-400 hover:text-gray-500 dark:hover:text-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2",
        data: { action: "click->modal#close" }
      ) do
        tag.span("Close", class: "sr-only") +
        close_icon
      end
    end
  end

  def close_icon
    tag.svg(
      class: "h-6 w-6",
      fill: "none",
      viewBox: "0 0 24 24",
      stroke: "currentColor"
    ) do
      tag.path(
        d: "M6 18L18 6M6 6l12 12",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        "stroke-width": "2"
      )
    end
  end

  def modal_header
    return unless header?

    tag.div(class: "border-b border-gray-200 dark:border-gray-700 px-6 py-4") do
      tag.h3(
        class: "text-lg font-semibold leading-6 text-gray-900 dark:text-white"
      ) do
        header
      end
    end
  end

  def modal_body
    tag.div(class: "px-6 py-4") do
      content
    end
  end

  def modal_footer
    return unless footer?

    tag.div(
      class: "border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900/50 px-6 py-3 sm:flex sm:flex-row-reverse rounded-b-lg"
    ) do
      footer
    end
  end

  def modal_panel_classes
    [
      "relative transform overflow-hidden rounded-lg",
      "bg-white dark:bg-gray-800",
      "text-left shadow-xl transition-all",
      "sm:my-8 sm:w-full",
      SIZES[@size]
    ].join(" ")
  end
end