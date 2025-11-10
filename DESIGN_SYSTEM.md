# Cornerstone Design System

A production-ready, ShadCN UI-inspired design system built with Rails ViewComponent, Stimulus, and Tailwind CSS.

## 🎯 Design Philosophy

This design system is built to be:
- **Junior-friendly**: Simple APIs, clear documentation, helpful error messages
- **AI-assistant compatible**: Consistent patterns, predictable naming, extensive examples
- **Production-ready**: Fully tested, accessible, with working JavaScript
- **Maintainable**: Clean inheritance, DRY principles, modular architecture

## 🚀 Quick Start

### Basic Usage

```erb
<%# Simple button %>
<%= ui_button "Click me" %>

<%# Button with options %>
<%= ui_button "Delete", variant: :destructive, size: :lg %>

<%# Or use the component directly %>
<%= render Styleguide::ButtonComponent.new(variant: :primary) do %>
  Save Changes
<% end %>
```

### Using Helpers (Recommended for Beginners)

The design system provides simple helper methods for common components:

```erb
<%# Forms %>
<%= ui_label "Email", for_id: "email" %>
<%= ui_input :email, placeholder: "you@example.com" %>

<%# Feedback %>
<%= ui_alert "Success!", title: "Saved", variant: :default %>
<%= ui_badge "New" %>
<%= ui_progress 75 %>

<%# Layout %>
<%= ui_separator %>
<%= ui_skeleton class: "h-12 w-full" %>
```

### Using Components Directly (More Control)

For advanced use cases, render components directly:

```erb
<%= render Styleguide::CardComponent.new do |c| %>
  <% c.with_header do %>
    <% c.with_title { "Card Title" } %>
    <% c.with_description { "Card description" } %>
  <% end %>
  <% c.with_content do %>
    <p>Your content here</p>
  <% end %>
  <% c.with_footer do %>
    <%= ui_button "Action" %>
  <% end %>
<% end %>
```

## 📦 Component Categories

### Core Components
- **Button** - Primary actions with 6 variants
- **Input** - Text input fields
- **Label** - Form field labels
- **Badge** - Status indicators
- **Card** - Content containers

### Form Components
- **Textarea** - Multi-line text input
- **Checkbox** - Boolean selection
- **Radio Group** - Single choice selection
- **Select** - Dropdown selection
- **Switch** - Toggle switches

### Feedback Components
- **Alert** - Important messages with variants
- **Progress** - Progress indicators
- **Dialog** - Modal dialogs (with Stimulus JS)

### Layout Components
- **Separator** - Visual dividers
- **Skeleton** - Loading placeholders
- **Tabs** - Tabbed interfaces (with Stimulus JS)
- **Accordion** - Collapsible sections (with Stimulus JS)

### Data Display
- **Table** - Tabular data display
- **Avatar** - User avatars with fallbacks
- **Breadcrumb** - Navigation trails

## 🎨 Theming & Customization

### Color Tokens

The design system uses semantic color tokens that adapt to light/dark mode:

```css
--background, --foreground
--primary, --primary-foreground
--secondary, --secondary-foreground
--destructive, --destructive-foreground
--muted, --muted-foreground
--accent, --accent-foreground
```

### Customizing Colors

Edit `app/assets/stylesheets/application.tailwind.css`:

```css
:root {
  --primary: 221.2 83.2% 53.3%; /* Your brand color */
  --secondary: 210 40% 96.1%;
  /* ... */
}
```

### Custom Classes

All components accept `html_class` for additional styling:

```erb
<%= ui_button "Full Width", html_class: "w-full" %>
<%= render Styleguide::CardComponent.new(html_class: "max-w-md mx-auto") do %>
  Centered card
<% end %>
```

## 🧪 Testing

### Component Tests

Each component has RSpec tests in `spec/components/styleguide/`:

```bash
bundle exec rspec spec/components/styleguide/
```

### Preview Components

View components in isolation with Lookbook at `/rails/view_components`:

```bash
bin/dev
# Visit http://localhost:3000/rails/view_components
```

## 🎓 For Junior Developers

### Common Patterns

**1. Start with helpers for simple cases:**
```erb
<%# ✅ Good for most cases %>
<%= ui_button "Save" %>
<%= ui_input :email %>
```

**2. Use components when you need more control:**
```erb
<%# ✅ When you need custom options %>
<%= render Styleguide::ButtonComponent.new(
  variant: :destructive,
  size: :lg,
  html_class: "w-full",
  data: { action: "click->modal#open" }
) do %>
  Custom Button
<% end %>
```

**3. Check previews for examples:**
Visit `/rails/view_components` to see live examples of every component.

### Troubleshooting

**Button not showing?**
- Make sure Tailwind classes are being compiled: `bin/dev`
- Check browser console for errors

**Interactive components (tabs, accordion) not working?**
- Ensure Stimulus is loaded: check `app/javascript/application.js`
- Check browser console for "Controller not found" errors

**Styles look wrong?**
- Clear browser cache
- Restart `bin/dev` to recompile Tailwind

## 🤖 For AI Assistants

### Predictable Patterns

All components follow these conventions:

1. **Component Location**: `app/components/styleguide/{name}_component.rb`
2. **Helper Location**: `app/helpers/styleguide_helper.rb`
3. **Test Location**: `spec/components/styleguide/{name}_component_spec.rb`
4. **Preview Location**: `spec/components/previews/styleguide/{name}_component_preview.rb`

### Component Structure

```ruby
module Styleguide
  class ExampleComponent < BaseComponent
    # Constants for variants/sizes
    VARIANTS = { default: "classes", destructive: "classes" }.freeze

    # Initialize with html_class (not class)
    def initialize(variant: :default, html_class: nil, **options)
      @variant = variant
      @html_class = html_class
      @options = options
    end

    # Use merge_classes helper from BaseComponent
    def component_classes
      merge_classes(
        "base classes",
        VARIANTS[@variant],
        @html_class
      )
    end
  end
end
```

### Adding New Components

1. Create component: `app/components/styleguide/new_component.rb`
2. Inherit from `BaseComponent`
3. Use `html_class:` parameter (never `class:`)
4. Add helper method in `styleguide_helper.rb`
5. Create tests in `spec/components/`
6. Create preview in `spec/components/previews/`
7. Update this documentation

## 📚 API Reference

### Button Component

```ruby
Styleguide::ButtonComponent.new(
  variant: :default,        # :default, :destructive, :outline, :secondary, :ghost, :link
  size: :default,           # :default, :sm, :lg, :icon
  type: :button,            # :button, :submit, :reset
  disabled: false,
  href: nil,                # Makes it a link instead of button
  html_class: nil,          # Additional CSS classes
  **options                 # Any other HTML attributes
)
```

### Input Component

```ruby
Styleguide::InputComponent.new(
  type: :text,              # :text, :email, :password, :number, etc.
  placeholder: nil,
  disabled: false,
  html_class: nil,
  **options
)
```

### Tabs Component (Interactive)

```erb
<%= render Styleguide::TabsComponent.new(default_value: "tab1") do |c| %>
  <% c.with_list do %>
    <%= render Styleguide::TabsComponent::TabsTrigger.new(value: "tab1") { "Tab 1" } %>
    <%= render Styleguide::TabsComponent::TabsTrigger.new(value: "tab2") { "Tab 2" } %>
  <% end %>
  <%= render Styleguide::TabsComponent::TabsContent.new(value: "tab1") { "Content 1" } %>
  <%= render Styleguide::TabsComponent::TabsContent.new(value: "tab2") { "Content 2" } %>
<% end %>
```

**Note**: Tabs require the Stimulus controller to work. It's automatically included.

### Alert Component

```ruby
Styleguide::AlertComponent.new(
  variant: :default,        # :default, :destructive
  html_class: nil
) do |c|
  c.with_title { "Alert Title" }
  c.with_description { "Alert message" }
end
```

## 🔧 Architecture

### Component Inheritance

```
ViewComponent::Base
  └── Styleguide::BaseComponent (provides merge_classes helper)
      └── All styleguide components
```

### Stimulus Controllers

Interactive components use Stimulus controllers in `app/javascript/controllers/`:
- `tabs_controller.js` - Tab switching
- `accordion_controller.js` - Collapsible sections
- `dialog_controller.js` - Modal dialogs
- `switch_controller.js` - Toggle switches

### Helper Methods

Defined in `app/helpers/styleguide_helper.rb`:
- Provide simple API for common use cases
- Always delegate to components (no duplicate logic)
- Follow `ui_*` naming convention

## 📖 Further Reading

- [ViewComponent Documentation](https://viewcomponent.org/)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Tailwind CSS](https://tailwindcss.com/)
- [ShadCN UI](https://ui.shadcn.com/) (inspiration)

## 🤝 Contributing

When adding or modifying components:

1. Keep APIs simple and predictable
2. Add inline documentation comments
3. Create comprehensive tests
4. Add Lookbook previews
5. Update this documentation
6. Consider both helper and component APIs

## 📝 License

Part of the Cornerstone Rails SaaS template.
