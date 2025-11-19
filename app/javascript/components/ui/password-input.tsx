import * as React from "react"
import { Input } from "./input"
import { Label } from "./label"
import { cn } from "@/lib/utils"

interface PasswordStrength {
  score: number
  level: 'empty' | 'weak' | 'fair' | 'good' | 'strong'
  label: string
  color: string
  width: string
}

interface PasswordChecks {
  length: boolean
  hasLowercase: boolean
  hasUppercase: boolean
  hasNumber: boolean
  hasSpecial: boolean
}

interface PasswordInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  showStrengthIndicator?: boolean
  minLength?: number
  label?: string
  hint?: string
}

const PasswordInput = React.forwardRef<HTMLInputElement, PasswordInputProps>(
  ({ className, showStrengthIndicator = false, minLength = 6, label, hint, ...props }, ref) => {
    const [password, setPassword] = React.useState("")
    const [checks, setChecks] = React.useState<PasswordChecks>({
      length: false,
      hasLowercase: false,
      hasUppercase: false,
      hasNumber: false,
      hasSpecial: false
    })
    const [strength, setStrength] = React.useState<PasswordStrength>({
      score: 0,
      level: 'empty',
      label: '',
      color: 'bg-gray-200',
      width: 'w-0'
    })

    const calculatePasswordChecks = (pwd: string): PasswordChecks => {
      return {
        length: pwd.length >= minLength,
        hasLowercase: /[a-z]/.test(pwd),
        hasUppercase: /[A-Z]/.test(pwd),
        hasNumber: /[0-9]/.test(pwd),
        hasSpecial: /[^A-Za-z0-9]/.test(pwd)
      }
    }

    const calculatePasswordStrength = (checks: PasswordChecks): PasswordStrength => {
      const score = Object.values(checks).filter(Boolean).length

      if (score === 0) {
        return { score, level: 'empty', label: '', color: 'bg-gray-200', width: 'w-0' }
      }
      if (score <= 2) {
        return { score, level: 'weak', label: 'Weak', color: 'bg-red-500', width: 'w-1/4' }
      }
      if (score === 3) {
        return { score, level: 'fair', label: 'Fair', color: 'bg-yellow-500', width: 'w-1/2' }
      }
      if (score === 4) {
        return { score, level: 'good', label: 'Good', color: 'bg-blue-500', width: 'w-3/4' }
      }
      return { score, level: 'strong', label: 'Strong', color: 'bg-green-500', width: 'w-full' }
    }

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
      const value = e.target.value
      setPassword(value)

      const newChecks = calculatePasswordChecks(value)
      setChecks(newChecks)
      setStrength(calculatePasswordStrength(newChecks))

      // Call parent onChange if provided
      props.onChange?.(e)
    }

    const meetsMinimum = checks.length

    return (
      <div className="space-y-2">
        {label && (
          <Label htmlFor={props.id}>
            {label}
            {hint && (
              <span className="text-xs text-muted-foreground font-normal ml-1">
                {hint}
              </span>
            )}
          </Label>
        )}

        <Input
          {...props}
          ref={ref}
          type="password"
          className={className}
          onChange={handleChange}
        />

        {showStrengthIndicator && password.length > 0 && (
          <div className="space-y-3">
            {/* Strength bar */}
            <div className="space-y-1">
              <div className="h-1 bg-gray-200 rounded-full overflow-hidden">
                <div
                  className={cn(
                    "h-full rounded-full transition-all duration-300",
                    strength.color,
                    strength.width
                  )}
                />
              </div>
              <div className="flex items-center justify-between">
                <span
                  className={cn(
                    "text-xs font-medium transition-colors",
                    strength.level === 'empty' ? 'text-transparent' : 'text-muted-foreground'
                  )}
                >
                  {strength.label}
                </span>
                {meetsMinimum && (
                  <svg className="w-4 h-4 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                  </svg>
                )}
              </div>
            </div>

            {/* Requirements list */}
            <ul className="space-y-2">
              <RequirementItem met={checks.length} text={`At least ${minLength} characters`} />
              <RequirementItem met={checks.hasLowercase} text="One lowercase letter" />
              <RequirementItem met={checks.hasUppercase} text="One uppercase letter" />
              <RequirementItem met={checks.hasNumber} text="One number" />
              <RequirementItem met={checks.hasSpecial} text="One special character" />
            </ul>
          </div>
        )}
      </div>
    )
  }
)

PasswordInput.displayName = "PasswordInput"

interface RequirementItemProps {
  met: boolean
  text: string
}

const RequirementItem: React.FC<RequirementItemProps> = ({ met, text }) => {
  return (
    <li className={cn(
      "flex items-center gap-2 text-xs transition-colors",
      met ? "text-green-600" : "text-muted-foreground"
    )}>
      <svg
        className={cn(
          "w-4 h-4 transition-colors",
          met ? "text-green-500" : "text-gray-300"
        )}
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
      </svg>
      <span>{text}</span>
    </li>
  )
}

export { PasswordInput }
