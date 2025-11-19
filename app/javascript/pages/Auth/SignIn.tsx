import React from 'react'
import { useForm } from '@inertiajs/react'
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { Mail } from 'lucide-react'

interface SignInProps {
  errors?: Record<string, string[]>
}

export default function SignIn({ errors = {} }: SignInProps) {
  const { data, setData, post, processing } = useForm({
    email: '',
    password: '',
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    post('/sign-in')
  }

  const hasErrors = Object.keys(errors).length > 0
  const errorCount = Object.values(errors).flat().length

  return (
    <div className="min-h-screen flex items-center justify-center bg-background px-4 py-12 sm:px-6 lg:px-8">
      <div className="w-full max-w-sm">
        <Card>
          <CardHeader className="text-center space-y-2">
            <CardTitle className="text-2xl font-semibold tracking-tight">
              Welcome back
            </CardTitle>
            <CardDescription>
              Sign in to your account to continue
            </CardDescription>
          </CardHeader>

          <CardContent>
            <form onSubmit={handleSubmit} className="grid gap-4">
              {/* Display error messages if any */}
              {hasErrors && (
                <div className="p-3 rounded-lg bg-destructive/10 border border-destructive/20">
                  <p className="text-sm text-destructive font-medium">
                    {errorCount === 1 ? 'There was an error' : `There were ${errorCount} errors`} with your submission
                  </p>
                </div>
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

              {/* Password field */}
              <div className="grid gap-2">
                <div className="flex items-center justify-between">
                  <Label htmlFor="password">Password</Label>
                  <a
                    href="/forgot-password"
                    className="text-sm font-medium text-primary hover:underline"
                  >
                    Forgot password?
                  </a>
                </div>
                <Input
                  type="password"
                  id="password"
                  name="password"
                  value={data.password}
                  onChange={(e) => setData('password', e.target.value)}
                  placeholder="Enter your password"
                  autoComplete="current-password"
                  required
                />
              </div>

              {/* Submit button */}
              <Button type="submit" className="w-full" disabled={processing}>
                {processing ? 'Signing in...' : 'Sign in'}
              </Button>

              {/* Divider */}
              <div className="relative">
                <div className="absolute inset-0 flex items-center">
                  <Separator />
                </div>
                <div className="relative flex justify-center text-xs uppercase">
                  <span className="bg-card px-2 text-muted-foreground">Or continue with</span>
                </div>
              </div>

              {/* Magic link button */}
              <a href="/magic-link" className="block">
                <Button type="button" variant="outline" className="w-full">
                  <Mail className="h-4 w-4 mr-2" />
                  Sign in with magic link
                </Button>
              </a>
            </form>
          </CardContent>

          <CardFooter>
            <div className="text-center text-sm text-muted-foreground w-full">
              Don't have an account?{' '}
              <a href="/sign-up" className="font-semibold text-primary hover:underline">
                Sign up
              </a>
            </div>
          </CardFooter>
        </Card>
      </div>
    </div>
  )
}
