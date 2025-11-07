class Accounts::SwitcherComponent < ViewComponent::Base
  def initialize(user:, current_account:)
    @user = user
    @current_account = current_account
    @accounts = user.accounts.order(:name)
  end

  def call
    return unless @accounts.count > 1

    tag.div(
      class: "relative",
      data: { controller: "dropdown" }
    ) do
      safe_join([
        dropdown_button,
        dropdown_menu
      ])
    end
  end

  private

  def dropdown_button
    button_tag(
      type: "button",
      class: button_classes,
      data: {
        action: "click->dropdown#toggle",
        dropdown_target: "button"
      }
    ) do
      safe_join([
        account_info,
        chevron_icon
      ])
    end
  end

  def account_info
    tag.div(class: "flex items-center") do
      safe_join([
        account_avatar,
        account_details
      ])
    end
  end

  def account_avatar
    tag.div(
      class: "h-8 w-8 rounded-full bg-indigo-500 flex items-center justify-center text-white font-semibold text-sm"
    ) do
      @current_account.name.first.upcase
    end
  end

  def account_details
    tag.div(class: "ml-3 text-left") do
      tag.p(@current_account.name, class: "text-sm font-semibold text-gray-900 dark:text-white") +
      tag.p(@user.membership_for(@current_account)&.role || "member", class: "text-xs text-gray-500 dark:text-gray-400")
    end
  end

  def chevron_icon
    tag.svg(
      class: "ml-2 h-5 w-5 text-gray-400",
      viewBox: "0 0 20 20",
      fill: "currentColor"
    ) do
      tag.path(
        "fill-rule": "evenodd",
        d: "M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z",
        "clip-rule": "evenodd"
      )
    end
  end

  def dropdown_menu
    tag.div(
      class: dropdown_menu_classes,
      data: { dropdown_target: "menu" }
    ) do
      safe_join([
        accounts_list,
        menu_footer
      ])
    end
  end

  def accounts_list
    tag.div(class: "py-1") do
      safe_join(@accounts.map { |account| account_menu_item(account) })
    end
  end

  def account_menu_item(account)
    is_current = account == @current_account

    link_to(
      switch_account_path(account),
      method: :post,
      class: menu_item_classes(is_current),
      data: { turbo_method: :post }
    ) do
      safe_join([
        account_menu_avatar(account),
        account_menu_info(account),
        current_indicator(is_current)
      ])
    end
  end

  def account_menu_avatar(account)
    tag.div(
      class: "h-8 w-8 rounded-full bg-gray-300 dark:bg-gray-600 flex items-center justify-center text-gray-700 dark:text-gray-300 font-semibold text-sm"
    ) do
      account.name.first.upcase
    end
  end

  def account_menu_info(account)
    membership = @user.membership_for(account)

    tag.div(class: "ml-3 flex-1") do
      tag.p(account.name, class: "text-sm font-medium text-gray-900 dark:text-white") +
      tag.p(membership&.role || "member", class: "text-xs text-gray-500 dark:text-gray-400")
    end
  end

  def current_indicator(is_current)
    return unless is_current

    tag.svg(
      class: "h-5 w-5 text-green-500",
      viewBox: "0 0 20 20",
      fill: "currentColor"
    ) do
      tag.path(
        "fill-rule": "evenodd",
        d: "M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z",
        "clip-rule": "evenodd"
      )
    end
  end

  def menu_footer
    tag.div(class: "border-t border-gray-200 dark:border-gray-700 py-1") do
      link_to(
        "Create New Account",
        new_account_path,
        class: "block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
      ) +
      link_to(
        "Account Settings",
        account_settings_path(@current_account),
        class: "block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
      )
    end
  end

  def button_classes
    [
      "flex items-center justify-between w-full px-4 py-2",
      "bg-white dark:bg-gray-800",
      "border border-gray-300 dark:border-gray-600",
      "rounded-lg shadow-sm",
      "hover:bg-gray-50 dark:hover:bg-gray-700",
      "focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
    ].join(" ")
  end

  def dropdown_menu_classes
    [
      "hidden absolute right-0 z-10 mt-2 w-64",
      "origin-top-right rounded-lg",
      "bg-white dark:bg-gray-800",
      "shadow-lg ring-1 ring-black ring-opacity-5",
      "focus:outline-none"
    ].join(" ")
  end

  def menu_item_classes(is_current)
    base = "flex items-center px-4 py-2 text-sm"

    if is_current
      "#{base} bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-white"
    else
      "#{base} text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
    end
  end
end