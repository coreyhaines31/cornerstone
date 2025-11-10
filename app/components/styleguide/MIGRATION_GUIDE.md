# Design System Migration Guide

This guide explains the improvements made to the Cornerstone design system and how to use the new features.

## What Changed?

### 1. ✅ Fixed `class` Parameter Issue

**Before (Confusing):**
```ruby
# Used Ruby tricks that juniors won't understand
@class = binding.local_variable_get(:class)
```

**After (Clear):**
```ruby
# Simple, explicit parameter name
def initialize(html_class: nil, **options)
  @html_class = html_class
end
```

**Migration:**
```erb
<%# Old way (still works for now) %>
<%= render Styleguide::ButtonComponent.new(class: "w-full") { "Button" } %>

<%# New way (recommended) %>
<%= render Styleguide::ButtonComponent.new(html_class: "w-full") { "Button" } %>
```

### 2. ✅ Added Helper Methods

**Before (Verbose):**
```erb
<%= render Styleguide::ButtonComponent.new(variant: :primary) do %>
  Click me
<% end %>
```

**After (Concise):**
```erb
<%= ui_button "Click me", variant: :primary %>
```

**Available Helpers:**
- `ui_button(text, **options)` - Buttons
- `ui_input(type, **options)` - Inputs
- `ui_label(text, **options)` - Labels
- `ui_badge(text, **options)` - Badges
- `ui_alert(message, **options)` - Alerts
- `ui_separator(**options)` - Separators
- `ui_skeleton(**options)` - Skeletons
- `ui_progress(value, **options)` - Progress bars

### 3. ✅ Interactive Components Now Work

**Tabs** - Now fully functional with Stimulus
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

**Accordion** - Collapsible sections work
**Dialog** - Modals open/close properly
**Switch** - Toggles work correctly

### 4. ✅ Added Component Previews

Visit `/rails/view_components` to see live examples of all components.

Browse previews by component:
- Button variants and sizes
- Input types
- Form components
- Interactive components
- And more!

### 5. ✅ Added Tests

All components now have comprehensive RSpec tests:

```bash
bundle exec rspec spec/components/styleguide/
```

Example tests:
- `spec/components/styleguide/button_component_spec.rb`
- `spec/components/styleguide/input_component_spec.rb`
- `spec/components/styleguide/badge_component_spec.rb`

### 6. ✅ Better Documentation

- `DESIGN_SYSTEM.md` - Comprehensive guide
- `app/components/styleguide/README.md` - Component reference
- Inline code comments in all components
- Examples in preview files

## Common Migration Patterns

### Simple Components

```erb
<%# Old: Verbose component rendering %>
<%= render Styleguide::ButtonComponent.new(variant: :primary, size: :lg) do %>
  Save
<% end %>

<%# New: Use helper for simpler cases %>
<%= ui_button "Save", variant: :primary, size: :lg %>
```

### Forms

```erb
<%# Old: Multiple renders %>
<%= render Styleguide::LabelComponent.new(for_id: "email") { "Email" } %>
<%= render Styleguide::InputComponent.new(type: :email, id: "email") %>

<%# New: Cleaner with helpers %>
<%= ui_label "Email", for_id: "email" %>
<%= ui_input :email, id: "email" %>
```

### Complex Components

For components with slots (Card, Table, etc.), continue using `render`:

```erb
<%# This is still the best way %>
<%= render Styleguide::CardComponent.new do |c| %>
  <% c.with_header do %>
    <% c.with_title { "Title" } %>
  <% end %>
  <% c.with_content { "Content" } %>
<% end %>
```

## When to Use What?

### Use Helpers When:
- ✅ Simple, one-off usage
- ✅ You want less code
- ✅ You're a junior developer
- ✅ You're prototyping quickly

### Use Components When:
- ✅ Need complex nested structure (Card, Table)
- ✅ Need data attributes for Stimulus
- ✅ Need custom options beyond common use cases
- ✅ Building reusable partial templates

## Breaking Changes

### None!

The old `class:` parameter still works but is deprecated. You'll see a warning if you use it. Update to `html_class:` when you can.

## Getting Help

1. **Check the styleguide**: Visit `/styleguide` in your app
2. **Check previews**: Visit `/rails/view_components`
3. **Read docs**: See `DESIGN_SYSTEM.md`
4. **Check tests**: Look at `spec/components/styleguide/*_spec.rb` for usage examples

## Next Steps

1. ✅ Update your components to use `html_class:` instead of `class:`
2. ✅ Try using helpers for simple components
3. ✅ Explore `/rails/view_components` to see what's available
4. ✅ Run tests to ensure everything works: `bundle exec rspec spec/components/`

## Questions?

- Check inline documentation in component files
- Look at preview examples
- Read the comprehensive `DESIGN_SYSTEM.md`
