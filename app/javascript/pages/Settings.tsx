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
import { Select } from "@/components/ui/select"
import { Separator } from "@/components/ui/separator"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Bell, CreditCard, Shield, Users } from "lucide-react"

type Preference = { key: string; label: string; description: string; enabled?: boolean }
type TeamMember = { name?: string; email?: string; role?: string; initials?: string }
type Billing = {
  plan?: string
  status?: string
  renewal_date?: string
  usage?: { members?: number; projects?: number; storage_gb?: number }
}

type SettingsProps = {
  user?: { name?: string; email?: string; initials?: string }
  account?: { name?: string; slug?: string; plan?: string; subscription_status?: string }
  billing?: Billing
  preferences?: Preference[]
  team?: TeamMember[]
  section?: string
}

const fallbackPreferences: Preference[] = [
  {
    key: "product",
    label: "Product updates",
    description: "New features, betas, and release notes.",
    enabled: true,
  },
  {
    key: "security",
    label: "Security alerts",
    description: "Login alerts and critical advisories.",
    enabled: true,
  },
  {
    key: "billing",
    label: "Billing updates",
    description: "Invoices, receipts, and renewal reminders.",
    enabled: true,
  },
]

const fallbackTeam: TeamMember[] = [
  { name: "Alex Harper", email: "alex@example.com", role: "owner", initials: "AH" },
  { name: "Sam Lee", email: "sam@example.com", role: "admin", initials: "SL" },
  { name: "Taylor Brooks", email: "taylor@example.com", role: "member", initials: "TB" },
]

const fallbackBilling: Billing = {
  plan: "Free",
  status: "trialing",
  renewal_date: undefined,
  usage: { members: 3, projects: 2, storage_gb: 0 },
}

export default function Settings({
  user,
  account,
  billing,
  preferences = [],
  team = [],
  section,
}: SettingsProps) {
  const safePreferences = preferences.length ? preferences : fallbackPreferences
  const safeTeam = team.length ? team : fallbackTeam
  const safeBilling = billing || fallbackBilling

  return (
    <AppLayout
      title="Settings"
      description="Workspace controls for billing, notifications, and team management."
      user={user}
      account={account}
      actions={<Button size="sm">Save changes</Button>}
      breadcrumbs={[
        { label: "Home", href: "/dashboard" },
        { label: "Settings" },
        { label: section ? section.toString() : "General" },
      ]}
    >
      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle>Workspace basics</CardTitle>
            <CardDescription>Set the core details for your workspace.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid gap-4 md:grid-cols-2">
              <div className="space-y-2">
                <Label htmlFor="workspace-name">Workspace name</Label>
                <Input id="workspace-name" placeholder="Acme Inc" defaultValue={account?.name} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="workspace-slug">Workspace URL</Label>
                <Input
                  id="workspace-slug"
                  placeholder="acme"
                  defaultValue={account?.slug}
                />
                <p className="text-xs text-muted-foreground">Used in your workspace URL.</p>
              </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2">
              <div className="space-y-2">
                <Label htmlFor="timezone">Timezone</Label>
                <Select id="timezone" defaultValue="utc">
                  <option value="utc">UTC</option>
                  <option value="ct">Central (CT)</option>
                  <option value="pt">Pacific (PT)</option>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="support-email">Support email</Label>
                <Input id="support-email" type="email" placeholder="support@example.com" />
              </div>
            </div>
          </CardContent>
          <CardFooter className="justify-end">
            <div className="flex items-center gap-2">
              <Button variant="outline" size="sm">
                Cancel
              </Button>
              <Button size="sm">Update workspace</Button>
            </div>
          </CardFooter>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Shield className="h-4 w-4 text-primary" />
              Security
            </CardTitle>
            <CardDescription>Baseline controls for your team.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="flex items-start gap-3 rounded-md border p-3">
              <Checkbox id="two-factor" defaultChecked />
              <div className="space-y-1">
                <Label htmlFor="two-factor" className="text-sm">
                  Enforce 2FA
                </Label>
                <p className="text-xs text-muted-foreground">
                  Require two-factor authentication for members to sign in.
                </p>
              </div>
            </div>
            <div className="flex items-start gap-3 rounded-md border p-3">
              <Checkbox id="session-timeout" />
              <div className="space-y-1">
                <Label htmlFor="session-timeout" className="text-sm">
                  Short session timeout
                </Label>
                <p className="text-xs text-muted-foreground">
                  Log users out after 30 minutes of inactivity.
                </p>
              </div>
            </div>
          </CardContent>
          <CardFooter className="justify-end">
            <Button size="sm" variant="outline">
              Manage security
            </Button>
          </CardFooter>
        </Card>
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <CreditCard className="h-4 w-4 text-primary" />
              Billing & usage
            </CardTitle>
            <CardDescription>Your current plan and consumption.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium">Plan</span>
              <Badge variant="outline">{safeBilling.plan}</Badge>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium">Status</span>
              <Badge variant="secondary" className="capitalize">
                {safeBilling.status}
              </Badge>
            </div>
            <Separator />
            <div className="space-y-2 text-sm">
              <div className="flex items-center justify-between">
                <span className="text-muted-foreground">Members</span>
                <span className="font-semibold">{safeBilling.usage?.members ?? 0}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-muted-foreground">Projects</span>
                <span className="font-semibold">{safeBilling.usage?.projects ?? 0}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-muted-foreground">Storage (GB)</span>
                <span className="font-semibold">{safeBilling.usage?.storage_gb ?? 0}</span>
              </div>
            </div>
          </CardContent>
          <CardFooter className="justify-end">
            <Button variant="outline" size="sm">
              Manage billing
            </Button>
          </CardFooter>
        </Card>

        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-start justify-between space-y-0">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Bell className="h-4 w-4 text-primary" />
                Notifications
              </CardTitle>
              <CardDescription>Decide what gets delivered to your inbox.</CardDescription>
            </div>
            <Button variant="outline" size="sm">
              Save preferences
            </Button>
          </CardHeader>
          <CardContent className="space-y-4">
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
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Users className="h-4 w-4 text-primary" />
                Team
              </CardTitle>
              <CardDescription>Manage access and roles.</CardDescription>
            </div>
            <Button size="sm">Invite member</Button>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow className="hover:bg-transparent">
                  <TableHead>Name</TableHead>
                  <TableHead>Email</TableHead>
                  <TableHead>Role</TableHead>
                  <TableHead className="text-right">Status</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {safeTeam.map((member) => (
                  <TableRow key={`${member.email}-${member.role}`}>
                    <TableCell className="font-semibold">
                      <div className="flex items-center gap-3">
                        <div className="flex h-8 w-8 items-center justify-center rounded-full bg-muted text-xs font-semibold">
                          {member.initials || "NA"}
                        </div>
                        <span>{member.name}</span>
                      </div>
                    </TableCell>
                    <TableCell className="text-sm text-muted-foreground">{member.email}</TableCell>
                    <TableCell className="capitalize">{member.role}</TableCell>
                    <TableCell className="text-right">
                      <Badge variant="outline">Active</Badge>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Need a hand?</CardTitle>
            <CardDescription>Support resources to help you finish setup.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <Alert>
              <AlertTitle>Try our checklist</AlertTitle>
              <AlertDescription>
                Finish onboarding and unlock best practices in under 5 minutes.
              </AlertDescription>
            </Alert>
            <div className="rounded-lg border p-3">
              <p className="text-sm font-semibold">Export data</p>
              <p className="text-xs text-muted-foreground">
                Schedule backups or request a full export of your workspace.
              </p>
              <Button variant="link" className="px-0 text-sm">
                Request export
              </Button>
            </div>
          </CardContent>
        </Card>
      </section>
    </AppLayout>
  )
}
