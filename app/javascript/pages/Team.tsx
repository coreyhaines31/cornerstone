import { AppLayout } from "@/components/layouts/AppLayout"
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
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { cn } from "@/lib/utils"
import { Mail, Send, Users } from "lucide-react"

type Member = { name?: string; email?: string; role?: string; status?: string; initials?: string }
type Invitation = { email: string; role: string; sent_at: string }

type TeamProps = {
  account?: { name?: string; plan?: string; subscription_status?: string }
  user?: { name?: string; email?: string; initials?: string }
  members?: Member[]
  invitations?: Invitation[]
}

const fallbackMembers: Member[] = [
  { name: "Alex Harper", email: "alex@example.com", role: "owner", status: "active", initials: "AH" },
  { name: "Sam Lee", email: "sam@example.com", role: "admin", status: "active", initials: "SL" },
  { name: "Taylor Brooks", email: "taylor@example.com", role: "member", status: "active", initials: "TB" },
]

const fallbackInvites: Invitation[] = [
  { email: "new-member@example.com", role: "member", sent_at: new Date().toISOString() },
  { email: "pending@example.com", role: "admin", sent_at: new Date(Date.now() - 86400000).toISOString() },
]

function formatDate(value: string) {
  return new Intl.DateTimeFormat("en", { month: "short", day: "numeric" }).format(new Date(value))
}

export default function Team({
  account,
  user,
  members = [],
  invitations = [],
}: TeamProps) {
  const safeMembers = members.length ? members : fallbackMembers
  const safeInvites = invitations.length ? invitations : fallbackInvites

  return (
    <AppLayout
      title="Team & invitations"
      description="Manage roles, seats, and pending invites."
      account={account}
      user={user}
      actions={<Button size="sm">Invite member</Button>}
      breadcrumbs={[
        { label: "Home", href: "/dashboard" },
        { label: "Team" },
      ]}
    >
      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Users className="h-4 w-4 text-primary" />
                Members
              </CardTitle>
              <CardDescription>Seat usage and role assignments.</CardDescription>
            </div>
            <Badge variant="secondary">Seats {safeMembers.length}/Unlimited</Badge>
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
                {safeMembers.map((member) => (
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
                    <TableCell className="capitalize">
                      <Badge variant="outline">{member.role}</Badge>
                    </TableCell>
                    <TableCell className="text-right">
                      <Badge variant="secondary" className="capitalize">
                        {member.status || "active"}
                      </Badge>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Invite member</CardTitle>
            <CardDescription>Send an invitation with the right role.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="space-y-2">
              <Label htmlFor="invite-email">Work email</Label>
              <Input id="invite-email" type="email" placeholder="person@example.com" />
            </div>
            <div className="space-y-2">
              <Label htmlFor="invite-role">Role</Label>
              <Select id="invite-role" defaultValue="member">
                <option value="owner">Owner</option>
                <option value="admin">Admin</option>
                <option value="member">Member</option>
              </Select>
            </div>
            <Button size="sm" className="w-full">
              Send invite
            </Button>
          </CardContent>
          <CardFooter className="flex-col items-start space-y-2 text-xs text-muted-foreground">
            <p>Owners and admins can manage billing and security.</p>
          </CardFooter>
        </Card>
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Send className="h-4 w-4 text-primary" />
                Pending invitations
              </CardTitle>
              <CardDescription>Resend or revoke outstanding invites.</CardDescription>
            </div>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow className="hover:bg-transparent">
                  <TableHead>Email</TableHead>
                  <TableHead>Role</TableHead>
                  <TableHead>Sent</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {safeInvites.map((invite) => (
                  <TableRow key={`${invite.email}-${invite.role}`}>
                    <TableCell className="font-semibold">{invite.email}</TableCell>
                    <TableCell className="capitalize">{invite.role}</TableCell>
                    <TableCell className="text-sm text-muted-foreground">{formatDate(invite.sent_at)}</TableCell>
                    <TableCell className="text-right">
                      <div className="flex justify-end gap-2">
                        <Button size="sm" variant="outline">
                          Resend
                        </Button>
                        <Button size="sm" variant="ghost">
                          Revoke
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Mail className="h-4 w-4 text-primary" />
              Alerts
            </CardTitle>
            <CardDescription>Control invites and join notifications.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="flex items-start gap-2 rounded-lg border p-3">
              <Checkbox id="alert-invites" defaultChecked />
              <div className="space-y-1">
                <Label htmlFor="alert-invites" className="text-sm font-semibold">
                  Email me when invites are accepted
                </Label>
                <p className="text-xs text-muted-foreground">Send a daily summary of new team members.</p>
              </div>
            </div>
            <div className="flex items-start gap-2 rounded-lg border p-3">
              <Checkbox id="alert-roles" />
              <div className="space-y-1">
                <Label htmlFor="alert-roles" className="text-sm font-semibold">
                  Role changes
                </Label>
                <p className="text-xs text-muted-foreground">Notify owners when roles are elevated.</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </section>
    </AppLayout>
  )
}
