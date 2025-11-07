class Forms::InputComponent < ViewComponent::Base
  def initialize(
    form:,
    field:,
    type: :text,
    label: nil,
    hint: nil,
    error: nil,
    required: false,
    placeholder: nil,
    prefix: nil,
    suffix: nil,
    **options
  )
    @form = form
    @field = field
    @type = type
    @label = label || field.to_s.humanize
    @hint = hint
    @error = error || @form.object.errors[@field].first
    @required = required
    @placeholder = placeholder
    @prefix = prefix
    @suffix = suffix
    @options = options
  end

  def call
    tag.div(class: "space-y-1") do
      safe_join([
        label_element,
        input_wrapper,
        hint_element,
        error_element
      ].compact)
    end
  end

  private

  def label_element
    return unless @label

    @form.label @field, class: label_classes do
      safe_join([
        @label,
        required_indicator
      ].compact)
    end
  end

  def required_indicator
    return unless @required

    tag.span("*", class: "text-red-500 ml-1")
  end

  def input_wrapper
    if @prefix || @suffix
      tag.div(class: "flex rounded-md shadow-sm") do
        safe_join([
          prefix_element,
          input_element,
          suffix_element
        ].compact)
      end
    else
      input_element
    end
  end

  def input_element
    case @type
    when :textarea
      @form.text_area @field, {
        class: input_classes,
        placeholder: @placeholder,
        **@options
      }
    when :select
      @form.select @field, @options[:options], {
        include_blank: @options[:include_blank],
        prompt: @options[:prompt]
      }, {
        class: input_classes,
        **@options.except(:options, :include_blank, :prompt)
      }
    when :checkbox
      tag.div(class: "flex items-center") do
        @form.check_box(@field, class: checkbox_classes, **@options) +
        @form.label(@field, @label, class: "ml-2 text-sm text-gray-900 dark:text-white")
      end
    when :radio
      tag.div(class: "space-y-2") do
        safe_join(@options[:options].map do |option|
          tag.div(class: "flex items-center") do
            @form.radio_button(@field, option[:value], class: radio_classes) +
            tag.label(option[:label], for: "#{@form.object_name}_#{@field}_#{option[:value]}",
                     class: "ml-2 text-sm text-gray-900 dark:text-white")
          end
        end)
      end
    else
      input_field_by_type
    end
  end

  def input_field_by_type
    method = case @type
    when :email then :email_field
    when :password then :password_field
    when :number then :number_field
    when :date then :date_field
    when :datetime then :datetime_field
    when :time then :time_field
    when :url then :url_field
    when :tel then :telephone_field
    when :color then :color_field
    when :search then :search_field
    when :file then :file_field
    else :text_field
    end

    @form.send(method, @field, {
      class: input_classes,
      placeholder: @placeholder,
      **@options
    })
  end

  def prefix_element
    return unless @prefix

    tag.span(
      class: "inline-flex items-center px-3 rounded-l-md border border-r-0 border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 text-gray-500 dark:text-gray-400 sm:text-sm"
    ) do
      @prefix
    end
  end

  def suffix_element
    return unless @suffix

    tag.span(
      class: "inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 text-gray-500 dark:text-gray-400 sm:text-sm"
    ) do
      @suffix
    end
  end

  def hint_element
    return unless @hint

    tag.p(@hint, class: "text-sm text-gray-500 dark:text-gray-400")
  end

  def error_element
    return unless @error

    tag.p(@error, class: "text-sm text-red-600 dark:text-red-400")
  end

  def label_classes
    "block text-sm font-medium text-gray-700 dark:text-gray-300"
  end

  def input_classes
    base_classes = [
      "block w-full rounded-md shadow-sm sm:text-sm",
      "bg-white dark:bg-gray-900",
      "placeholder-gray-400 dark:placeholder-gray-500",
      "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500",
      "dark:disabled:bg-gray-800 dark:disabled:text-gray-400"
    ]

    if @error
      base_classes << "border-red-300 text-red-900 focus:border-red-500 focus:ring-red-500"
      base_classes << "dark:border-red-600 dark:text-red-400"
    else
      base_classes << "border-gray-300 dark:border-gray-600"
      base_classes << "text-gray-900 dark:text-white"
      base_classes << "focus:border-indigo-500 focus:ring-indigo-500"
      base_classes << "dark:focus:border-indigo-400 dark:focus:ring-indigo-400"
    end

    base_classes.join(" ")
  end

  def checkbox_classes
    [
      "h-4 w-4 rounded",
      "border-gray-300 dark:border-gray-600",
      "text-indigo-600 dark:text-indigo-400",
      "focus:ring-indigo-500 dark:focus:ring-indigo-400",
      "dark:bg-gray-900"
    ].join(" ")
  end

  def radio_classes
    [
      "h-4 w-4",
      "border-gray-300 dark:border-gray-600",
      "text-indigo-600 dark:text-indigo-400",
      "focus:ring-indigo-500 dark:focus:ring-indigo-400",
      "dark:bg-gray-900"
    ].join(" ")
  end
end