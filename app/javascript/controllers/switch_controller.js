import { Controller } from "@hotwired/stimulus"

// Switch (toggle) controller
// Connects to data-controller="switch"
export default class extends Controller {
  static targets = ["input", "thumb"]
  static values = {
    checked: { type: Boolean, default: false }
  }

  connect() {
    this.updateState()
  }

  // Toggle the switch
  toggle() {
    if (!this.inputTarget.disabled) {
      this.checkedValue = !this.checkedValue
      this.inputTarget.checked = this.checkedValue
      this.updateState()

      // Dispatch change event
      this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }

  // Update visual state
  updateState() {
    const state = this.checkedValue ? "checked" : "unchecked"
    this.element.dataset.state = state

    if (this.hasThumbTarget) {
      this.thumbTarget.dataset.state = state
    }
  }

  checkedValueChanged() {
    this.updateState()
  }
}
