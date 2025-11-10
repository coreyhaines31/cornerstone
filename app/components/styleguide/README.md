# Cornerstone Design System

A comprehensive design system for Cornerstone, inspired by [ShadCN UI](https://ui.shadcn.com/), built with Tailwind CSS and ViewComponent.

## Overview

This design system provides a complete set of reusable UI components that follow modern design principles with built-in dark mode support. All components are built using Rails ViewComponents for maximum reusability and maintainability.

## Design Tokens

The design system uses CSS custom properties for theming, making it easy to customize colors and maintain consistency across light and dark modes.

### Color Palette

```css
/* Light Mode */
--background: 0 0% 100%
--foreground: 222.2 84% 4.9%
--primary: 221.2 83.2% 53.3%
--secondary: 210 40% 96.1%
--destructive: 0 84.2% 60.2%
--muted: 210 40% 96.1%
--accent: 210 40% 96.1%

/* Dark Mode */
--background: 222.2 84% 4.9%
--foreground: 210 40% 98%
--primary: 217.2 91.2% 59.8%
--secondary: 217.2 32.6% 17.5%
--destructive: 0 62.8% 30.6%
--muted: 217.2 32.6% 17.5%
--accent: 217.2 32.6% 17.5%
```

## Components

### Core Components

#### Button

Display buttons in different variants and sizes.

```erb
<%= render Styleguide::ButtonComponent.new(variant: :default, size: :default) do %>
  Click me
<% end %>
```

**Variants:** `default`, `secondary`, `destructive`, `outline`, `ghost`, `link`

**Sizes:** `default`, `sm`, `lg`, `icon`

#### Input

Form input field with consistent styling.

```erb
<%= render Styleguide::InputComponent.new(
  type: :email,
  placeholder: "email@example.com"
) %>
```

#### Label

Form label component with proper accessibility.

```erb
<%= render Styleguide::LabelComponent.new(for_id: "email") do %>
  Email Address
<% end %>
```

#### Badge

Display status indicators and labels.

```erb
<%= render Styleguide::BadgeComponent.new(variant: :default) do %>
  New
<% end %>
```

**Variants:** `default`, `secondary`, `destructive`, `outline`

#### Card

Container component for grouping related content.

```erb
<%= render Styleguide::CardComponent.new do |c| %>
  <% c.with_header do %>
    <% c.with_title { "Card Title" } %>
    <% c.with_description { "Card description" } %>
  <% end %>
  <% c.with_content do %>
    <p>Card content goes here</p>
  <% end %>
  <% c.with_footer do %>
    <%= render Styleguide::ButtonComponent.new do %>Action<% end %>
  <% end %>
<% end %>
```

### Form Components

#### Textarea

Multi-line text input.

```erb
<%= render Styleguide::TextareaComponent.new(
  placeholder: "Enter your message..."
) %>
```

#### Checkbox

Checkbox input with custom styling.

```erb
<%= render Styleguide::CheckboxComponent.new(id: "terms") %>
```

#### Radio Group

Radio button group component.

```erb
<%= render Styleguide::RadioGroupComponent.new(name: "plan") do |c| %>
  <% c.with_item(value: "free", id: "free", label: "Free", checked: true) %>
  <% c.with_item(value: "pro", id: "pro", label: "Pro") %>
<% end %>
```

#### Select

Select dropdown component.

```erb
<%= render Styleguide::SelectComponent.new(id: "country") do %>
  <option>United States</option>
  <option>Canada</option>
<% end %>
```

#### Switch

Toggle switch component.

```erb
<%= render Styleguide::SwitchComponent.new(id: "notifications") %>
```

### Feedback Components

#### Alert

Display important messages and notifications.

```erb
<%= render Styleguide::AlertComponent.new(variant: :default) do |c| %>
  <% c.with_title { "Heads up!" } %>
  <% c.with_description { "Important information here." } %>
<% end %>
```

**Variants:** `default`, `destructive`

#### Progress

Progress indicator bar.

```erb
<%= render Styleguide::ProgressComponent.new(value: 60, max: 100) %>
```

#### Dialog

Modal dialog component.

```erb
<%= render Styleguide::DialogComponent.new do |c| %>
  <% c.with_trigger do %>
    <%= render Styleguide::ButtonComponent.new { "Open Dialog" } %>
  <% end %>
  <% c.with_header do %>
    <% c.with_title { "Dialog Title" } %>
    <% c.with_description { "Dialog description" } %>
  <% end %>
  <% c.with_footer do %>
    <%= render Styleguide::ButtonComponent.new { "Confirm" } %>
  <% end %>
<% end %>
```

### Layout Components

#### Separator

Visual divider between sections.

```erb
<%= render Styleguide::SeparatorComponent.new(orientation: :horizontal) %>
```

**Orientations:** `horizontal`, `vertical`

#### Skeleton

Loading placeholder component.

```erb
<%= render Styleguide::SkeletonComponent.new(class: "h-12 w-full") %>
```

#### Tabs

Tabbed interface component.

```erb
<%= render Styleguide::TabsComponent.new(default_value: "tab1") do |c| %>
  <% c.with_list do %>
    <% c.with_trigger(value: "tab1") { "Tab 1" } %>
    <% c.with_trigger(value: "tab2") { "Tab 2" } %>
  <% end %>
  <% c.with_content(value: "tab1") { "Content 1" } %>
  <% c.with_content(value: "tab2") { "Content 2" } %>
<% end %>
```

#### Accordion

Collapsible content sections.

```erb
<%= render Styleguide::AccordionComponent.new do |c| %>
  <% c.with_item(value: "item1") do |item| %>
    <% item.with_trigger { "Question 1" } %>
    <% item.with_content { "Answer 1" } %>
  <% end %>
<% end %>
```

### Data Display Components

#### Table

Display data in tabular format.

```erb
<%= render Styleguide::TableComponent.new do |c| %>
  <% c.with_header do %>
    <%= render Styleguide::TableRowComponent.new do %>
      <%= render Styleguide::TableHeadComponent.new { "Name" } %>
      <%= render Styleguide::TableHeadComponent.new { "Email" } %>
    <% end %>
  <% end %>
  <% c.with_body do %>
    <%= render Styleguide::TableRowComponent.new do %>
      <%= render Styleguide::TableCellComponent.new { "John Doe" } %>
      <%= render Styleguide::TableCellComponent.new { "john@example.com" } %>
    <% end %>
  <% end %>
<% end %>
```

#### Avatar

User avatar with fallback support.

```erb
<%= render Styleguide::AvatarComponent.new do |c| %>
  <% c.with_image(src: "/path/to/image.jpg", alt: "User") %>
  <% c.with_fallback { "JD" } %>
<% end %>
```

#### Breadcrumb

Navigation breadcrumbs.

```erb
<%= render Styleguide::BreadcrumbComponent.new do |c| %>
  <% c.with_item(href: "/") { "Home" } %>
  <% c.with_item(href: "/products") { "Products" } %>
  <% c.with_item { "Current Page" } %>
<% end %>
```

## Customization

### Adding Custom Classes

All components accept a `class` parameter for additional styling:

```erb
<%= render Styleguide::ButtonComponent.new(class: "w-full") do %>
  Full Width Button
<% end %>
```

### Theming

To customize the color scheme, update the CSS variables in `app/assets/stylesheets/application.tailwind.css`:

```css
:root {
  --primary: YOUR_COLOR_HSL_VALUES;
  --secondary: YOUR_COLOR_HSL_VALUES;
  /* ... other variables */
}
```

### Dark Mode

Dark mode is automatically supported. Toggle dark mode by adding/removing the `dark` class on the root element:

```javascript
document.documentElement.classList.toggle('dark')
```

## Viewing the Styleguide

Visit `/styleguide` in your application to see all components in action with live examples.

## Architecture

- **Framework**: Rails 8 with ViewComponent
- **Styling**: Tailwind CSS v3
- **Icons**: Heroicons via rails_icons gem
- **Inspired by**: ShadCN UI

## Contributing

When adding new components:

1. Create component in `app/components/styleguide/`
2. Follow the naming convention: `ComponentNameComponent`
3. Use design tokens (CSS variables) for colors
4. Add example to `/styleguide` page
5. Document usage in this README

## Resources

- [ShadCN UI Documentation](https://ui.shadcn.com/)
- [Tailwind CSS Documentation](https://tailwindcss.com/)
- [ViewComponent Documentation](https://viewcomponent.org/)
