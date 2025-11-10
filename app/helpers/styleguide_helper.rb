# frozen_string_literal: true

module StyleguideHelper
  # Button helper for simpler usage
  # @example
  #   <%= ui_button "Click me" %>
  #   <%= ui_button "Delete", variant: :destructive %>
  def ui_button(text = nil, variant: :default, size: :default, **options, &block)
    render Styleguide::ButtonComponent.new(variant: variant, size: size, **options) do
      block ? capture(&block) : text
    end
  end

  # Input helper
  # @example
  #   <%= ui_input :email, placeholder: "Enter email" %>
  def ui_input(type = :text, **options)
    render Styleguide::InputComponent.new(type: type, **options)
  end

  # Label helper
  # @example
  #   <%= ui_label "Email", for_id: "email" %>
  def ui_label(text = nil, for_id: nil, **options, &block)
    render Styleguide::LabelComponent.new(for_id: for_id, **options) do
      block ? capture(&block) : text
    end
  end

  # Badge helper
  # @example
  #   <%= ui_badge "New", variant: :default %>
  def ui_badge(text = nil, variant: :default, **options, &block)
    render Styleguide::BadgeComponent.new(variant: variant, **options) do
      block ? capture(&block) : text
    end
  end

  # Alert helper
  # @example
  #   <%= ui_alert "Warning message", variant: :destructive %>
  def ui_alert(message = nil, title: nil, variant: :default, **options)
    render Styleguide::AlertComponent.new(variant: variant, **options) do |c|
      c.with_title { title } if title
      c.with_description { message } if message
    end
  end

  # Separator helper
  # @example
  #   <%= ui_separator %>
  #   <%= ui_separator :vertical %>
  def ui_separator(orientation = :horizontal, **options)
    render Styleguide::SeparatorComponent.new(orientation: orientation, **options)
  end

  # Skeleton helper
  # @example
  #   <%= ui_skeleton class: "h-12 w-full" %>
  def ui_skeleton(**options)
    render Styleguide::SkeletonComponent.new(**options)
  end

  # Progress helper
  # @example
  #   <%= ui_progress 60 %>
  #   <%= ui_progress 30, max: 100 %>
  def ui_progress(value, max: 100, **options)
    render Styleguide::ProgressComponent.new(value: value, max: max, **options)
  end
end
