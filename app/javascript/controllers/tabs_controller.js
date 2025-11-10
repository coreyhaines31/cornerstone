import { Controller } from "@hotwired/stimulus"

// Tabs controller for switching between tab content
// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = {
    default: String
  }

  connect() {
    // Activate default tab on load
    if (this.defaultValue) {
      this.activate(this.defaultValue)
    } else if (this.triggerTargets.length > 0) {
      // Activate first tab if no default specified
      const firstValue = this.triggerTargets[0].dataset.value
      this.activate(firstValue)
    }
  }

  // Switch to clicked tab
  switch(event) {
    const value = event.currentTarget.dataset.value
    this.activate(value)
  }

  // Activate a specific tab by value
  activate(value) {
    // Update triggers
    this.triggerTargets.forEach(trigger => {
      if (trigger.dataset.value === value) {
        trigger.dataset.state = "active"
        trigger.setAttribute("aria-selected", "true")
      } else {
        trigger.dataset.state = "inactive"
        trigger.setAttribute("aria-selected", "false")
      }
    })

    // Update content panels
    this.contentTargets.forEach(content => {
      if (content.dataset.value === value) {
        content.classList.remove("hidden")
        content.dataset.state = "active"
      } else {
        content.classList.add("hidden")
        content.dataset.state = "inactive"
      }
    })
  }
}
