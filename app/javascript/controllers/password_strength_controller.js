import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "indicator", "requirements"]
  static values = {
    minLength: { type: Number, default: 6 }
  }

  connect() {
    this.updateStrength()
  }

  updateStrength() {
    const password = this.inputTarget.value
    const checks = this.getPasswordChecks(password)
    const strength = this.calculateStrength(checks)

    this.updateIndicator(strength, checks)
    this.updateRequirements(checks)
  }

  getPasswordChecks(password) {
    return {
      length: password.length >= this.minLengthValue,
      hasLowercase: /[a-z]/.test(password),
      hasUppercase: /[A-Z]/.test(password),
      hasNumber: /[0-9]/.test(password),
      hasSpecial: /[^A-Za-z0-9]/.test(password)
    }
  }

  calculateStrength(checks) {
    const score = Object.values(checks).filter(Boolean).length

    if (score === 0) return { level: 'empty', label: '', color: 'bg-gray-200' }
    if (score <= 2) return { level: 'weak', label: 'Weak', color: 'bg-red-500' }
    if (score === 3) return { level: 'fair', label: 'Fair', color: 'bg-yellow-500' }
    if (score === 4) return { level: 'good', label: 'Good', color: 'bg-blue-500' }
    return { level: 'strong', label: 'Strong', color: 'bg-green-500' }
  }

  updateIndicator(strength, checks) {
    if (!this.hasIndicatorTarget) return

    const meetsMinimum = checks.length
    const strengthBar = this.indicatorTarget.querySelector('[data-strength-bar]')
    const strengthLabel = this.indicatorTarget.querySelector('[data-strength-label]')
    const checkIcon = this.indicatorTarget.querySelector('[data-check-icon]')

    // Update strength bar
    if (strengthBar) {
      strengthBar.className = `h-1 rounded-full transition-all duration-300 ${strength.color}`
      const widths = { empty: 'w-0', weak: 'w-1/4', fair: 'w-1/2', good: 'w-3/4', strong: 'w-full' }
      Object.keys(widths).forEach(level => strengthBar.classList.remove(widths[level]))
      strengthBar.classList.add(widths[strength.level])
    }

    // Update strength label
    if (strengthLabel) {
      strengthLabel.textContent = strength.label
      strengthLabel.className = `text-xs font-medium ${strength.level === 'empty' ? 'text-transparent' : 'text-muted-foreground'}`
    }

    // Update check icon
    if (checkIcon) {
      if (meetsMinimum) {
        checkIcon.classList.remove('hidden')
        checkIcon.classList.add('text-green-500')
      } else {
        checkIcon.classList.add('hidden')
      }
    }
  }

  updateRequirements(checks) {
    if (!this.hasRequirementsTarget) return

    const requirements = [
      { key: 'length', label: `At least ${this.minLengthValue} characters` },
      { key: 'hasLowercase', label: 'One lowercase letter' },
      { key: 'hasUppercase', label: 'One uppercase letter' },
      { key: 'hasNumber', label: 'One number' },
      { key: 'hasSpecial', label: 'One special character' }
    ]

    const requirementsList = requirements.map(req => {
      const met = checks[req.key]
      return `
        <li class="flex items-center gap-2 text-xs ${met ? 'text-green-600' : 'text-muted-foreground'}">
          <svg class="w-4 h-4 ${met ? 'text-green-500' : 'text-gray-300'}" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          <span>${req.label}</span>
        </li>
      `
    }).join('')

    this.requirementsTarget.innerHTML = `<ul class="space-y-2">${requirementsList}</ul>`
  }
}
