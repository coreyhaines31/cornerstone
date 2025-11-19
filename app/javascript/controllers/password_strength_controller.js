import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-strength"
export default class extends Controller {
  static targets = ["input", "bar", "label", "requirements"]
  static values = { minLength: { type: Number, default: 6 } }

  connect() {
    this.checkStrength()
  }

  checkStrength() {
    const password = this.inputTarget.value
    const checks = {
      length: password.length >= this.minLengthValue,
      lowercase: /[a-z]/.test(password),
      uppercase: /[A-Z]/.test(password),
      number: /[0-9]/.test(password),
      special: /[^A-Za-z0-9]/.test(password)
    }

    const score = Object.values(checks).filter(Boolean).length
    this.updateStrengthIndicator(score, password.length)
    this.updateRequirements(checks)
  }

  updateStrengthIndicator(score, length) {
    if (!this.hasBarTarget || !this.hasLabelTarget) return

    let strength, color, width, label

    if (length === 0) {
      strength = "empty"
      color = "bg-gray-200"
      width = "w-0"
      label = ""
    } else if (score <= 2) {
      strength = "weak"
      color = "bg-red-500"
      width = "w-1/4"
      label = "Weak"
    } else if (score === 3) {
      strength = "fair"
      color = "bg-yellow-500"
      width = "w-1/2"
      label = "Fair"
    } else if (score === 4) {
      strength = "good"
      color = "bg-blue-500"
      width = "w-3/4"
      label = "Good"
    } else {
      strength = "strong"
      color = "bg-green-500"
      width = "w-full"
      label = "Strong"
    }

    // Update bar
    this.barTarget.className = `h-2 rounded-full transition-all duration-300 ${color} ${width}`

    // Update label
    this.labelTarget.textContent = label
    if (label) {
      const labelColors = {
        weak: "text-red-600",
        fair: "text-yellow-600",
        good: "text-blue-600",
        strong: "text-green-600"
      }
      this.labelTarget.className = `text-sm font-medium ${labelColors[strength]}`
    }
  }

  updateRequirements(checks) {
    if (!this.hasRequirementsTarget) return

    const requirements = this.requirementsTarget.querySelectorAll('[data-requirement]')
    requirements.forEach(req => {
      const type = req.dataset.requirement
      const icon = req.querySelector('svg')

      if (checks[type]) {
        req.classList.remove('text-gray-500')
        req.classList.add('text-green-600')
        if (icon) {
          icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" />'
        }
      } else {
        req.classList.remove('text-green-600')
        req.classList.add('text-gray-500')
        if (icon) {
          icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />'
        }
      }
    })
  }
}
