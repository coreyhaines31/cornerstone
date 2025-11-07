module IconHelper
  # Render a Heroicon
  # Usage: <%= icon "home", class: "w-5 h-5" %>
  # Usage: <%= icon "user-circle", variant: :solid, class: "w-6 h-6" %>
  def icon(name, variant: :outline, **options)
    icon_class = case variant
    when :solid
      "Phlex::Icons::Hero::#{name.to_s.camelize}Solid"
    when :mini
      "Phlex::Icons::Hero::#{name.to_s.camelize}Mini"
    else
      "Phlex::Icons::Hero::#{name.to_s.camelize}"
    end

    begin
      icon_component = icon_class.constantize.new(**options)
      render icon_component
    rescue NameError
      # Fallback to a default icon if not found
      content_tag(:span, "Icon not found: #{name}", class: "text-red-500 text-xs")
    end
  end

  # Common icons used throughout the app
  def dashboard_icon(**options)
    icon("chart-bar", **options)
  end

  def settings_icon(**options)
    icon("cog-6-tooth", **options)
  end

  def users_icon(**options)
    icon("users", **options)
  end

  def user_icon(**options)
    icon("user", **options)
  end

  def activity_icon(**options)
    icon("clock", **options)
  end

  def logout_icon(**options)
    icon("arrow-right-on-rectangle", **options)
  end

  def plus_icon(**options)
    icon("plus", **options)
  end

  def edit_icon(**options)
    icon("pencil", **options)
  end

  def trash_icon(**options)
    icon("trash", **options)
  end

  def check_icon(**options)
    icon("check", **options)
  end

  def x_icon(**options)
    icon("x-mark", **options)
  end

  def chevron_down_icon(**options)
    icon("chevron-down", **options)
  end

  def chevron_up_icon(**options)
    icon("chevron-up", **options)
  end

  def chevron_left_icon(**options)
    icon("chevron-left", **options)
  end

  def chevron_right_icon(**options)
    icon("chevron-right", **options)
  end

  def search_icon(**options)
    icon("magnifying-glass", **options)
  end

  def bell_icon(**options)
    icon("bell", **options)
  end

  def envelope_icon(**options)
    icon("envelope", **options)
  end

  def lock_icon(**options)
    icon("lock-closed", **options)
  end

  def unlock_icon(**options)
    icon("lock-open", **options)
  end

  def credit_card_icon(**options)
    icon("credit-card", **options)
  end

  def home_icon(**options)
    icon("home", **options)
  end

  def document_icon(**options)
    icon("document-text", **options)
  end

  def folder_icon(**options)
    icon("folder", **options)
  end

  def calendar_icon(**options)
    icon("calendar", **options)
  end

  def globe_icon(**options)
    icon("globe-alt", **options)
  end
end