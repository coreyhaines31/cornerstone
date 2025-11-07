import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "container", "panel"]
  static values = {
    backdrop: { type: Boolean, default: true },
    closeable: { type: Boolean, default: true }
  }

  open() {
    this.element.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")

    // Animate in
    requestAnimationFrame(() => {
      if (this.hasBackdropTarget) {
        this.backdropTarget.classList.add("opacity-100")
      }
      if (this.hasPanelTarget) {
        this.panelTarget.classList.add("opacity-100", "translate-y-0", "sm:scale-100")
      }
    })
  }

  close() {
    if (!this.closeableValue) return

    // Animate out
    if (this.hasBackdropTarget) {
      this.backdropTarget.classList.remove("opacity-100")
    }
    if (this.hasPanelTarget) {
      this.panelTarget.classList.remove("opacity-100", "translate-y-0", "sm:scale-100")
    }

    // Hide after animation
    setTimeout(() => {
      this.element.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }, 200)
  }

  closeWithBackdrop(event) {
    if (!this.closeableValue || !this.backdropValue) return
    if (event.target === this.backdropTarget || event.target === this.containerTarget) {
      this.close()
    }
  }

  closeWithKeyboard(event) {
    if (event.key === "Escape" && this.closeableValue) {
      this.close()
    }
  }

  disconnect() {
    document.body.classList.remove("overflow-hidden")
  }
}