import React from 'react'
import { useForm } from '@inertiajs/react'
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { PasswordInput } from '@/components/ui/password-input'
import { Alert, AlertTitle, AlertDescription } from '@/components/ui/alert'

interface ResetPasswordProps {
  resetPasswordToken: string
  errors?: Record<string, string[]>
  minPasswordLength?: number
}

export default function ResetPassword({
  resetPasswordToken,
  errors = {},
  minPasswordLength = 6
}: ResetPasswordProps) {
  const { data, setData, put, processing } = useForm({
    reset_password_token: resetPasswordToken,
    password: '',
    password_confirmation: '',
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    put('/reset-password')
  }

  const hasErrors = Object.keys(errors).length > 0
  const errorCount = Object.values(errors).flat().length

  return (
    <div className="min-h-screen flex items-center justify-center bg-background px-4 py-12 sm:px-6 lg:px-8">
      <div className="w-full max-w-sm">
        <Card>
          <CardHeader className="text-center space-y-2">
            <CardTitle className="text-2xl font-semibold tracking-tight">
              Change your password
            </CardTitle>
            <CardDescription>
              Enter a new password for your account
            </CardDescription>
          </CardHeader>

          <CardContent>
            <form onSubmit={handleSubmit} className="grid gap-4">
              {/* Hidden token field */}
              <Input
                type="hidden"
                name="reset_password_token"
                value={data.reset_password_token}
              />

              {/* Display error messages if any */}
              {hasErrors && (
                <Alert variant="destructive">
                  <AlertTitle>
                    There {errorCount === 1 ? 'was' : 'were'} {errorCount} error{errorCount !== 1 ? 's' : ''} with your submission:
                  </AlertTitle>
                  <AlertDescription>
                    <ul className="list-disc list-inside text-sm mt-2">
                      {Object.entries(errors).map(([field, messages]) =>
                        messages.map((message, idx) => (
                          <li key={`${field}-${idx}`}>{message}</li>
                        ))
                      )}
                    </ul>
                  </AlertDescription>
                </Alert>
              )}

              {/* New password field with strength indicator */}
              <PasswordInput
                id="password"
                name="password"
                value={data.password}
                onChange={(e) => setData('password', e.target.value)}
                placeholder="Enter new password"
                autoComplete="new-password"
                required
                showStrengthIndicator
                minLength={minPasswordLength}
                label="New password"
                hint={`(${minPasswordLength} characters minimum)`}
              />

              {/* Password confirmation field */}
              <div className="grid gap-2">
                <PasswordInput
                  id="password_confirmation"
                  name="password_confirmation"
                  value={data.password_confirmation}
                  onChange={(e) => setData('password_confirmation', e.target.value)}
                  placeholder="Confirm new password"
                  autoComplete="new-password"
                  required
                  label="Confirm new password"
                />
              </div>

              {/* Submit button */}
              <Button type="submit" className="w-full" disabled={processing}>
                {processing ? 'Changing password...' : 'Change my password'}
              </Button>
            </form>
          </CardContent>

          <CardFooter>
            <div className="text-center text-sm text-muted-foreground w-full">
              <a href="/sign-in" className="font-semibold text-primary hover:underline">
                Back to sign in
              </a>
            </div>
          </CardFooter>
        </Card>
      </div>
    </div>
  )
}
