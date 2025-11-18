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
    
    // For bottom-aligned dropdowns, ensure menu bottom aligns with button bottom
    const button = this.element.querySelector('button')
    if (button && this.menuTarget.style.bottom === '0px') {
      // Wait for layout to calculate positions
      setTimeout(() => {
        const buttonRect = button.getBoundingClientRect()
        const menuRect = this.menuTarget.getBoundingClientRect()
        const parentRect = this.element.getBoundingClientRect()
        
        // Calculate the offset needed to align menu bottom with button bottom
        const menuBottomRelativeToParent = parentRect.bottom - menuRect.bottom
        const buttonBottomRelativeToParent = parentRect.bottom - buttonRect.bottom
        
        if (menuBottomRelativeToParent !== buttonBottomRelativeToParent) {
          const offset = buttonBottomRelativeToParent - menuBottomRelativeToParent
          this.menuTarget.style.bottom = `${offset}px`
        }
      }, 0)
    }
    
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