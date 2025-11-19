import React from 'react'
import { useForm } from '@inertiajs/react'
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { PasswordInput } from '@/components/ui/password-input'
import { Alert, AlertTitle, AlertDescription } from '@/components/ui/alert'

interface SignUpProps {
  errors?: Record<string, string[]>
  minPasswordLength?: number
}

export default function SignUp({ errors = {}, minPasswordLength = 6 }: SignUpProps) {
  const { data, setData, post, processing } = useForm({
    email: '',
    password: '',
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    post('/sign-up')
  }

  const hasErrors = Object.keys(errors).length > 0
  const errorCount = Object.values(errors).flat().length

  return (
    <div className="min-h-screen flex items-center justify-center bg-background px-4 py-12 sm:px-6 lg:px-8">
      <div className="w-full max-w-sm">
        <Card>
          <CardHeader className="text-center space-y-2">
            <CardTitle className="text-2xl font-semibold tracking-tight">
              Create an account
            </CardTitle>
            <CardDescription>
              Enter your details below to get started
            </CardDescription>
          </CardHeader>

          <CardContent>
            <form onSubmit={handleSubmit} className="grid gap-4">
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

              {/* Email field */}
              <div className="grid gap-2">
                <Label htmlFor="email">Email</Label>
                <Input
                  type="email"
                  id="email"
                  name="email"
                  value={data.email}
                  onChange={(e) => setData('email', e.target.value)}
                  placeholder="name@example.com"
                  autoComplete="email"
                  required
                />
              </div>

              {/* Password field with strength indicator */}
              <PasswordInput
                id="password"
                name="password"
                value={data.password}
                onChange={(e) => setData('password', e.target.value)}
                placeholder="Create a password"
                autoComplete="new-password"
                required
                showStrengthIndicator
                minLength={minPasswordLength}
                label="Password"
                hint={`(${minPasswordLength} characters minimum)`}
              />

              {/* Submit button */}
              <Button type="submit" className="w-full" disabled={processing}>
                {processing ? 'Creating account...' : 'Create account'}
              </Button>

              {/* Terms and privacy text */}
              <p className="px-8 text-center text-xs text-muted-foreground">
                By creating an account, you agree to our{' '}
                <a href="/terms" className="underline underline-offset-4 hover:text-primary" target="_blank" rel="noopener noreferrer">
                  Terms of Service
                </a>
                {' '}and{' '}
                <a href="/privacy" className="underline underline-offset-4 hover:text-primary" target="_blank" rel="noopener noreferrer">
                  Privacy Policy
                </a>
              </p>
            </form>
          </CardContent>

          <CardFooter>
            <div className="text-center text-sm text-muted-foreground w-full">
              Already have an account?{' '}
              <a href="/sign-in" className="font-semibold text-primary hover:underline">
                Sign in
              </a>
            </div>
          </CardFooter>
        </Card>
      </div>
    </div>
  )
}
