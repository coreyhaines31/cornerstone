import { AppLayout } from "@/components/layouts/AppLayout"
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Separator } from "@/components/ui/separator"
import { cn } from "@/lib/utils"
import { Lock, Mail, User, Wifi } from "lucide-react"

type Preference = { key: string; label: string; description: string; enabled?: boolean }
type Session = { location?: string; device?: string; last_active_at?: string; current?: boolean }
type Highlight = { title: string; description: string }

type ProfileProps = {
  user?: {
    name?: string
    first_name?: string
    last_name?: string
    email?: string
    initials?: string
    role?: string
  }
  account?: { name?: string; plan?: string; subscription_status?: string }
  preferences?: Preference[]
  sessions?: Session[]
  highlights?: Highlight[]
  mode?: string
}

const fallbackPreferences: Preference[] = [
  {
    key: "weekly_summary",
    label: "Weekly summary",
    description: "Digest of activity, alerts, and suggestions.",
    enabled: true,
  },
  {
    key: "security",
    label: "Security alerts",
    description: "Unusual sign-ins, device approvals, and 2FA changes.",
    enabled: true,
  },
]

const fallbackSessions: Session[] = [
  { location: "Chicago, IL", device: "MacBook Pro · Safari", last_active_at: new Date().toISOString(), current: true },
  { location: "Austin, TX", device: "iPhone · Mobile Safari", last_active_at: new Date(Date.now() - 86400 * 1000 * 2).toISOString(), current: false },
]

const fallbackHighlights: Highlight[] = [
  { title: "Complete your profile", description: "Add a job title and photo so teammates recognize you." },
  { title: "Set up account recovery", description: "Store a backup email and enable 2FA to prevent lockouts." },
]

function formatDate(value?: string) {
  if (!value) return "—"
  const date = new Date(value)
  return new Intl.DateTimeFormat("en", { month: "short", day: "numeric" }).format(date)
}

export default function Profile({
  user,
  account,
  preferences = [],
  sessions = [],
  highlights = [],
  mode,
}: ProfileProps) {
  const safePreferences = preferences.length ? preferences : fallbackPreferences
  const safeSessions = sessions.length ? sessions : fallbackSessions
  const safeHighlights = highlights.length ? highlights : fallbackHighlights

  return (
    <AppLayout
      title="Profile"
      description="Your personal details, contact preferences, and devices."
      user={user}
      account={account}
      actions={
        <div className="flex items-center gap-2">
          <Button variant="outline" size="sm">
            Upload avatar
          </Button>
          <Button size="sm">Save profile</Button>
        </div>
      }
      breadcrumbs={[
        { label: "Home", href: "/dashboard" },
        { label: "Profile" },
        { label: mode ? mode.toString() : "Overview" },
      ]}
    >
      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <User className="h-4 w-4 text-primary" />
              Personal details
            </CardTitle>
            <CardDescription>Keep your information up to date.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid gap-4 md:grid-cols-2">
              <div className="space-y-2">
                <Label htmlFor="first-name">First name</Label>
                <Input id="first-name" defaultValue={user?.first_name} placeholder="First name" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="last-name">Last name</Label>
                <Input id="last-name" defaultValue={user?.last_name} placeholder="Last name" />
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" defaultValue={user?.email} placeholder="you@example.com" />
            </div>
          </CardContent>
          <CardFooter className="justify-end">
            <Button size="sm">Update profile</Button>
          </CardFooter>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Mail className="h-4 w-4 text-primary" />
              Contact
            </CardTitle>
            <CardDescription>Where we send updates and alerts.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="rounded-lg border p-3">
              <p className="text-sm font-semibold">Primary email</p>
              <p className="text-xs text-muted-foreground">{user?.email || "you@example.com"}</p>
              <Badge variant="secondary" className="mt-2">
                Verified
              </Badge>
            </div>
            <Alert>
              <AlertTitle>Tip</AlertTitle>
              <AlertDescription>
                Add a backup email to recover your account and receive critical security alerts.
              </AlertDescription>
            </Alert>
          </CardContent>
        </Card>
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-start justify-between">
            <div>
              <CardTitle>Notifications</CardTitle>
              <CardDescription>Choose what reaches your inbox.</CardDescription>
            </div>
            <Button size="sm" variant="outline">
              Save preferences
            </Button>
          </CardHeader>
          <CardContent className="space-y-3">
            {safePreferences.map((pref) => (
              <div
                key={pref.key}
                className="flex items-start justify-between gap-3 rounded-md border p-4"
              >
                <div className="space-y-1">
                  <p className="text-sm font-semibold">{pref.label}</p>
                  <p className="text-xs text-muted-foreground">{pref.description}</p>
                </div>
                <Checkbox defaultChecked={pref.enabled} aria-label={pref.label} />
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Lock className="h-4 w-4 text-primary" />
              Security
            </CardTitle>
            <CardDescription>Keep your account protected.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="flex items-start gap-3 rounded-md border p-3">
              <Checkbox id="two-factor-profile" defaultChecked />
              <div className="space-y-1">
                <Label htmlFor="two-factor-profile" className="text-sm">
                  Two-factor authentication
                </Label>
                <p className="text-xs text-muted-foreground">Protect sign-ins with an extra code.</p>
              </div>
            </div>
            <div className="flex items-start gap-3 rounded-md border p-3">
              <Checkbox id="recovery-codes" />
              <div className="space-y-1">
                <Label htmlFor="recovery-codes" className="text-sm">
                  Recovery codes
                </Label>
                <p className="text-xs text-muted-foreground">Generate backup codes in case you lose access.</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Wifi className="h-4 w-4 text-primary" />
                Active sessions
              </CardTitle>
              <CardDescription>Devices currently signed in.</CardDescription>
            </div>
            <Button variant="outline" size="sm">
              Sign out others
            </Button>
          </CardHeader>
          <CardContent className="space-y-3">
            {safeSessions.map((session, index) => (
              <div
                key={`${session.device || "device"}-${index}`}
                className={cn(
                  "flex items-center justify-between rounded-md border p-4",
                  session.current ? "border-primary/30 bg-primary/5" : "bg-muted/30"
                )}
              >
                <div>
                  <p className="text-sm font-semibold">{session.device}</p>
                  <p className="text-xs text-muted-foreground">{session.location}</p>
                </div>
                <div className="text-right">
                  <p className="text-xs text-muted-foreground">Last active</p>
                  <p className="text-sm font-medium">{formatDate(session.last_active_at)}</p>
                  {session.current && (
                    <Badge variant="secondary" className="mt-2">
                      Current session
                    </Badge>
                  )}
                </div>
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Highlights</CardTitle>
            <CardDescription>Quick wins to finish setup.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            {safeHighlights.map((highlight) => (
              <div key={highlight.title} className="rounded-lg border p-3">
                <p className="text-sm font-semibold">{highlight.title}</p>
                <p className="text-xs text-muted-foreground">{highlight.description}</p>
                <Button variant="link" className="px-0 text-sm">
                  View details
                </Button>
              </div>
            ))}
          </CardContent>
        </Card>
      </section>
    </AppLayout>
  )
}
