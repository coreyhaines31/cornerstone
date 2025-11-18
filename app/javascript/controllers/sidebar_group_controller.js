import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]
  static values = { open: Boolean }

  connect() {
    console.log("Sidebar group controller connected")
    this.updateVisibility()
  }

  toggle(event) {
    console.log("Sidebar group toggle clicked")
    event.preventDefault()
    this.openValue = !this.openValue
    this.updateVisibility()
  }

  updateVisibility() {
    console.log("updateVisibility called", { hasContentTarget: this.hasContentTarget, openValue: this.openValue })
    if (this.hasContentTarget) {
      if (this.openValue) {
        this.contentTarget.classList.remove("hidden")
        if (this.hasIconTarget) {
          this.iconTarget.classList.add("rotate-0")
          this.iconTarget.classList.remove("-rotate-90")
        }
      } else {
        this.contentTarget.classList.add("hidden")
        if (this.hasIconTarget) {
          this.iconTarget.classList.add("-rotate-90")
          this.iconTarget.classList.remove("rotate-0")
        }
      }
    } else {
      console.error("Content target not found!")
    }
  }
}
