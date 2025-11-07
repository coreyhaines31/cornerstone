import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 5000 } }

  connect() {
    this.show()
    this.timeoutId = setTimeout(() => {
      this.close()
    }, this.delayValue)
  }

  disconnect() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  show() {
    this.element.classList.remove("hidden")
    this.element.classList.add("animate-fade-in")
  }

  close() {
    this.element.classList.add("animate-fade-out")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}