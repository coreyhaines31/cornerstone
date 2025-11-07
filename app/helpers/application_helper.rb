module ApplicationHelper
  # Returns a time-based greeting
  def greeting
    hour = Time.current.hour
    case hour
    when 0..11
      "Good morning"
    when 12..17
      "Good afternoon"
    else
      "Good evening"
    end
  end

  # Flash message styling based on type
  def flash_class(type)
    case type.to_sym
    when :notice, :success
      "bg-green-50 dark:bg-green-900/50 text-green-800 dark:text-green-200"
    when :alert, :error
      "bg-red-50 dark:bg-red-900/50 text-red-800 dark:text-red-200"
    when :warning
      "bg-yellow-50 dark:bg-yellow-900/50 text-yellow-800 dark:text-yellow-200"
    else
      "bg-blue-50 dark:bg-blue-900/50 text-blue-800 dark:text-blue-200"
    end
  end

  # Format currency
  def format_currency(amount_cents, currency = "USD")
    Money.new(amount_cents, currency).format
  end

  # Page title helper
  def page_title(title = nil)
    base_title = "Cornerstone"
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end
