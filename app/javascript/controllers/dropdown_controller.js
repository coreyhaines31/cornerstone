import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    console.log("Dropdown controller connected")
    this.close = this.close.bind(this)
  }

  toggle(event) {
    console.log("Dropdown toggle clicked")
    event.preventDefault()
    event.stopPropagation()

    if (this.menuTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    // Use setTimeout to prevent immediate close from the same click event
    setTimeout(() => {
      document.addEventListener("click", this.close)
    }, 0)
  }

  close(event) {
    // Don't close if clicking inside the dropdown
    if (event && this.element.contains(event.target)) {
      return
    }
    this.menuTarget.classList.add("hidden")
    document.removeEventListener("click", this.close)
  }

  disconnect() {
    document.removeEventListener("click", this.close)
  }
}