import { Controller } from "@hotwired/stimulus"

// Dialog (modal) controller
// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ["overlay", "content"]
  static values = {
    open: { type: Boolean, default: false }
  }

  connect() {
    // Set initial state
    if (this.openValue) {
      this.show()
    } else {
      this.hide()
    }

    // Close on escape key
    this.boundHandleEscape = this.handleEscape.bind(this)
    document.addEventListener("keydown", this.boundHandleEscape)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundHandleEscape)
  }

  // Show the dialog
  open(event) {
    event?.preventDefault()
    this.show()
  }

  // Hide the dialog
  close(event) {
    event?.preventDefault()
    this.hide()
  }

  // Close on overlay click
  closeOnOverlay(event) {
    if (event.target === this.overlayTarget) {
      this.hide()
    }
  }

  // Close on escape key
  handleEscape(event) {
    if (event.key === "Escape" && this.openValue) {
      this.hide()
    }
  }

  show() {
    this.openValue = true
    this.element.classList.remove("hidden")
    this.element.classList.add("flex")
    document.body.style.overflow = "hidden"
  }

  hide() {
    this.openValue = false
    this.element.classList.add("hidden")
    this.element.classList.remove("flex")
    document.body.style.overflow = ""
  }
}
