# Design System Styling Audit

**Date**: 2025-11-11
**Comparing**: Current Cornerstone components vs. shadcn/ui reference

## Overview

This document identifies styling differences between the current design system components and shadcn/ui standards. Based on visual comparison of the styleguide page, the components are functional but lack the polished aesthetic of shadcn/ui.

## Key Styling Gaps

### Global Issues (Affecting Multiple Components)

1. **Focus Ring Offset Missing**
   - **Current**: `focus-visible:ring-1 focus-visible:ring-ring`
   - **Should Be**: `focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2`
   - **Impact**: Focus states don't have proper contrast/separation from element
   - **Components Affected**: Button, Input, Textarea, Select, Checkbox, Switch

2. **Transition Duration Not Specified**
   - **Current**: `transition-colors`
   - **Should Be**: `transition-colors duration-200` or `transition-all duration-200`
   - **Impact**: Hover/focus transitions feel instant, not smooth
   - **Components Affected**: Button, Badge, Card, Alert

3. **Text Sizing Inconsistencies**
   - **Issue**: Some components use `text-sm`, some use `text-base`
   - **Should Match**: shadcn/ui's consistent text sizing hierarchy
   - **Impact**: Visual hierarchy feels inconsistent

## Component-Specific Issues

### 1. ButtonComponent ✅ MOSTLY GOOD

**File**: `app/components/styleguide/button_component.rb`

**Issues**:
- Missing `ring-offset-background` on focus state
- Transition duration not specified
- Secondary variant could use better contrast

**Current Base Classes**:
```ruby
"inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium"
"transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
"disabled:pointer-events-none disabled:opacity-50"
```

**Recommended Changes**:
```ruby
"inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium"
"transition-colors duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
"disabled:pointer-events-none disabled:opacity-50"
```

**Variant Issues**:
- `default`: ✅ Good
- `destructive`: ✅ Good
- `outline`: Missing `hover:bg-accent` transition - ✅ Good
- `secondary`: ✅ Good
- `ghost`: ✅ Good
- `link`: ✅ Good

---

### 2. InputComponent ⚠️ NEEDS WORK

**File**: `app/components/styleguide/input_component.rb`

**Issues**:
- Border is too subtle (hard to see in screenshot)
- Focus ring missing offset
- Missing placeholder styling
- File inputs need special handling

**Current**:
```
Unknown - need to check component
```

**Should Be**:
```ruby
"flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base"
"ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground"
"placeholder:text-muted-foreground"
"focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
"disabled:cursor-not-allowed disabled:opacity-50"
"md:text-sm"
```

---

### 3. CardComponent ⚠️ NEEDS WORK

**File**: `app/components/styleguide/card_component.rb`

**Issues**:
- Shadow is too harsh/prominent
- Border could be more subtle
- Padding inconsistencies in sub-components

**Current Root**:
```ruby
"rounded-lg border bg-card text-card-foreground shadow"
```

**Should Be**:
```ruby
"rounded-lg border bg-card text-card-foreground shadow-sm"
```

**Sub-component Issues**:

**CardHeader**:
- Current: `"flex flex-col space-y-1.5 p-6"`
- Should Be: Same but verify spacing feels right

**CardTitle**:
- Current: `"font-semibold leading-none tracking-tight"`
- Should Add: `text-2xl` for proper hierarchy

**CardDescription**:
- Current: `"text-sm text-muted-foreground"`
- ✅ Good

**CardContent** (now CardBody):
- Current: `"p-6 pt-0"`
- ✅ Good

**CardFooter**:
- Current: `"flex items-center p-6 pt-0"`
- ✅ Good

---

### 4. LabelComponent ⚠️ NEEDS VERIFICATION

**File**: `app/components/styleguide/label_component.rb`

**Should Have**:
```ruby
"text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"`
```

---

### 5. BadgeComponent ⚠️ NEEDS WORK

**File**: `app/components/styleguide/badge_component.rb`

**Issues**:
- Missing transition duration
- Border radius might need adjustment

**Should Have** (base):
```ruby
"inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors duration-200"
"focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"
```

---

### 6. AlertComponent ✅ PROBABLY GOOD

**File**: `app/components/styleguide/alert_component.rb`

**Verify**:
- Border styling
- Padding feels right
- Icon alignment if present

---

### 7. TextareaComponent ⚠️ NEEDS WORK

**File**: `app/components/styleguide/textarea_component.rb`

**Should Match Input Styling**:
```ruby
"flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
"ring-offset-background placeholder:text-muted-foreground"
"focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
"disabled:cursor-not-allowed disabled:opacity-50"
```

---

### 8. SelectComponent ⚠️ COMPLEX

**File**: `app/components/styleguide/select_component.rb`

**Issues**:
- Native select styling is limited
- May need custom dropdown for full shadcn/ui experience
- Focus states need work

---

### 9. CheckboxComponent ⚠️ NEEDS WORK

**File**: `app/components/styleguide/checkbox_component.rb`

**Issues**:
- Size might be off (should be h-4 w-4)
- Focus ring needs offset
- Checked state styling

**Should Have**:
```ruby
"peer h-4 w-4 shrink-0 rounded-sm border border-primary ring-offset-background"
"focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
"disabled:cursor-not-allowed disabled:opacity-50"
"data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground"
```

---

### 10. SwitchComponent ⚠️ NEEDS WORK

**File**: `app/components/styleguide/switch_component.rb`

**Issues**:
- Thumb animation/transition
- Focus state styling
- Size proportions

---

### 11. ProgressComponent ⚠️ NEEDS VERIFICATION

**File**: `app/components/styleguide/progress_component.rb`

**Check**:
- Height (should be h-2 or h-4)
- Border radius
- Indicator styling

---

### 12. SeparatorComponent ✅ PROBABLY GOOD

**File**: `app/components/styleguide/separator_component.rb`

**Should Be Simple**:
```ruby
# Horizontal
"shrink-0 bg-border h-[1px] w-full"
# Vertical
"shrink-0 bg-border w-[1px] h-full"
```

---

### 13. SkeletonComponent ✅ PROBABLY GOOD

**File**: `app/components/styleguide/skeleton_component.rb`

**Should Have**:
```ruby
"animate-pulse rounded-md bg-muted"
```

---

### 14. TableComponent ⚠️ NEEDS VERIFICATION

**File**: `app/components/styleguide/table_component.rb`

**Issues**:
- Border styling
- Row hover states
- Header styling
- Text sizing

---

### 15. AvatarComponent ⚠️ NEEDS VERIFICATION

**File**: `app/components/styleguide/avatar_component.rb`

**Check**:
- Fallback background color
- Size variants
- Border radius (should be rounded-full)

---

### 16. BreadcrumbComponent ⚠️ NEEDS VERIFICATION

**File**: `app/components/styleguide/breadcrumb_component.rb`

**Check**:
- Separator styling
- Link hover states
- Current page styling

---

### 17. TabsComponent ⚠️ COMPLEX (Stimulus)

**File**: `app/components/styleguide/tabs_component.rb`

**Issues**:
- Tab indicator/underline animation
- Active tab styling
- Focus states

---

### 18. AccordionComponent ⚠️ COMPLEX (Stimulus)

**File**: `app/components/styleguide/accordion_component.rb`

**Issues**:
- Chevron rotation animation
- Border styling
- Padding/spacing

---

### 19. DialogComponent ⚠️ COMPLEX (Stimulus)

**File**: `app/components/styleguide/dialog_component.rb`

**Issues**:
- Overlay opacity/backdrop
- Animation (slide in/fade)
- Focus trap
- Close button styling

---

### 20. RadioGroupComponent ⚠️ NEEDS WORK

**File**: `app/components/styleguide/radio_group_component.rb`

**Issues**:
- Radio button size (should be h-4 w-4)
- Inner dot size/positioning
- Focus ring offset

---

## Priority Recommendations

### High Priority (Most Visible Impact)

1. **Button** - Add `ring-offset-2` and `duration-200`
2. **Input** - Fix border visibility and focus ring
3. **Card** - Change `shadow` to `shadow-sm`
4. **Textarea** - Match Input styling
5. **Label** - Add proper text sizing

### Medium Priority

6. **Badge** - Add transition duration
7. **Checkbox** - Fix sizing and focus ring
8. **Select** - Improve focus states
9. **Table** - Fix borders and hover states

### Lower Priority (Less Common/Complex)

10. **Tabs** - Animation polish
11. **Accordion** - Animation polish
12. **Dialog** - Animation and overlay
13. **Switch** - Thumb transitions
14. **Radio** - Size and focus ring

## Implementation Strategy

### Phase 1: Quick Wins (30 minutes)
- Add `ring-offset-2` to all focus states
- Add `duration-200` to all transitions
- Change Card shadow from `shadow` to `shadow-sm`

### Phase 2: Form Components (1 hour)
- Fix Input, Textarea, Label
- Fix Checkbox, Radio, Select
- Add proper placeholder styling

### Phase 3: Interactive Components (1-2 hours)
- Polish Button variants
- Fix Badge transitions
- Update Table styling

### Phase 4: Complex Components (2-3 hours)
- Tabs animations
- Accordion animations
- Dialog overlay and animations
- Switch thumb transitions

## Testing Checklist

After each fix:
- [ ] Check in light mode
- [ ] Check in dark mode
- [ ] Test hover states
- [ ] Test focus states (keyboard navigation)
- [ ] Test disabled states
- [ ] Verify on screenshot vs shadcn/ui reference

## Notes

- Some components may need Stimulus controller updates for animations
- Focus on getting the 80% visual match first, then polish edge cases
- Test with actual content, not just the styleguide examples
- Consider responsive breakpoints (md: modifiers)
