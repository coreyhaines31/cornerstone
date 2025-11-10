import { Controller } from "@hotwired/stimulus"

// Accordion controller for collapsible content sections
// Connects to data-controller="accordion"
export default class extends Controller {
  static targets = ["item", "trigger", "content"]
  static values = {
    type: { type: String, default: "single" }, // "single" or "multiple"
    collapsible: { type: Boolean, default: true }
  }

  // Toggle an accordion item
  toggle(event) {
    const trigger = event.currentTarget
    const item = trigger.closest("[data-accordion-item]")
    const content = item.querySelector("[data-tabs-target='content']")
    const isOpen = item.dataset.state === "open"

    if (this.typeValue === "single") {
      // Close all other items in single mode
      this.closeAll(item)
    }

    if (isOpen && this.collapsibleValue) {
      this.close(item, trigger, content)
    } else if (!isOpen) {
      this.open(item, trigger, content)
    }
  }

  open(item, trigger, content) {
    item.dataset.state = "open"
    trigger.setAttribute("aria-expanded", "true")
    content.dataset.state = "open"
    content.classList.remove("hidden")
  }

  close(item, trigger, content) {
    item.dataset.state = "closed"
    trigger.setAttribute("aria-expanded", "false")
    content.dataset.state = "closed"
    content.classList.add("hidden")
  }

  closeAll(exceptItem = null) {
    this.itemTargets.forEach(item => {
      if (item !== exceptItem) {
        const trigger = item.querySelector("[data-action]")
        const content = item.querySelector("[data-tabs-target='content']")
        this.close(item, trigger, content)
      }
    })
  }
}
