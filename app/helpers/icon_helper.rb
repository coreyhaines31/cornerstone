module IconHelper
  # Render a Heroicon using rails_icons
  # Usage: <%= icon_svg "home", class: "w-5 h-5" %>
  # Usage: <%= icon_svg "user-circle", set: :solid, class: "w-6 h-6" %>
  def icon_svg(name, set: :outline, **options)
    css_class = options.delete(:class) || "w-5 h-5"
    icon(name, set: set.to_s, class: css_class, **options)
  end

  # Common icons used throughout the app
  def dashboard_icon(**options)
    icon_svg("chart-bar", **options)
  end

  def settings_icon(**options)
    icon_svg("cog-6-tooth", **options)
  end

  def users_icon(**options)
    icon_svg("users", **options)
  end

  def user_icon(**options)
    icon_svg("user", **options)
  end

  def activity_icon(**options)
    icon_svg("clock", **options)
  end

  def logout_icon(**options)
    icon_svg("arrow-right-on-rectangle", **options)
  end

  def plus_icon(**options)
    icon_svg("plus", **options)
  end

  def edit_icon(**options)
    icon_svg("pencil", **options)
  end

  def trash_icon(**options)
    icon_svg("trash", **options)
  end

  def check_icon(**options)
    icon_svg("check", **options)
  end

  def x_icon(**options)
    icon_svg("x-mark", **options)
  end

  def chevron_down_icon(**options)
    icon_svg("chevron-down", **options)
  end

  def chevron_up_icon(**options)
    icon_svg("chevron-up", **options)
  end

  def chevron_left_icon(**options)
    icon_svg("chevron-left", **options)
  end

  def chevron_right_icon(**options)
    icon_svg("chevron-right", **options)
  end

  def search_icon(**options)
    icon_svg("magnifying-glass", **options)
  end

  def bell_icon(**options)
    icon_svg("bell", **options)
  end

  def envelope_icon(**options)
    icon_svg("envelope", **options)
  end

  def lock_icon(**options)
    icon_svg("lock-closed", **options)
  end

  def unlock_icon(**options)
    icon_svg("lock-open", **options)
  end

  def credit_card_icon(**options)
    icon_svg("credit-card", **options)
  end

  def home_icon(**options)
    icon_svg("home", **options)
  end

  def document_icon(**options)
    icon_svg("document-text", **options)
  end

  def folder_icon(**options)
    icon_svg("folder", **options)
  end

  def calendar_icon(**options)
    icon_svg("calendar", **options)
  end

  def globe_icon(**options)
    icon_svg("globe-alt", **options)
  end

  def menu_icon(**options)
    icon_svg("bars-3", **options)
  end

  def dots_icon(**options)
    icon_svg("ellipsis-horizontal", **options)
  end
end