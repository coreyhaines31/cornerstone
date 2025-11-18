import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Separator } from "@/components/ui/separator"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { AppLayout } from "@/components/layouts/AppLayout"
import { cn } from "@/lib/utils"
import {
  ArrowUpRight,
  Bell,
  CheckCircle,
  Shield,
  Users,
} from "lucide-react"

type Stat = { label: string; value: string | number; change?: string }
type Highlight = { title: string; description: string; badge?: string }
type ActivityItem = {
  id: string | number
  action: string
  actor?: string
  description?: string
  occurred_at?: string
}
type Task = {
  id: string
  title: string
  owner?: string
  status: string
  due_on?: string
}

type DashboardProps = {
  user?: { name?: string; email?: string; initials?: string }
  account?: { name?: string; plan?: string; subscription_status?: string }
  stats?: Stat[]
  highlights?: Highlight[]
  activity?: ActivityItem[]
  tasks?: Task[]
}

const statusTone: Record<string, string> = {
  "In progress": "text-primary",
  "Ready to start": "text-amber-600 dark:text-amber-500",
  Blocked: "text-destructive",
}

const fallbackStats: Stat[] = [
  { label: "Members", value: 8, change: "+3 this week" },
  { label: "Projects", value: 4, change: "Stable" },
  { label: "Storage used", value: "0 B", change: "Optimized" },
  { label: "Plan", value: "Free", change: "Trialing" },
]

const fallbackTasks: Task[] = [
  {
    id: "TASK-2873",
    title: "Kick off Q2 planning",
    owner: "You",
    status: "In progress",
  },
  {
    id: "TASK-1834",
    title: "Invite the leadership team",
    owner: "Account owner",
    status: "Blocked",
  },
  {
    id: "TASK-4421",
    title: "Enable security baseline",
    owner: "Security",
    status: "Ready to start",
  },
]

const fallbackHighlights: Highlight[] = [
  {
    title: "Invite your team",
    description: "Add teammates to collaborate on projects and approvals.",
    badge: "Collaboration",
  },
  {
    title: "Stay on top of billing",
    description: "Review usage, plan, and invoices to avoid surprises.",
    badge: "Billing",
  },
  {
    title: "Secure the workspace",
    description: "Enable 2FA or SSO to protect your account.",
    badge: "Security",
  },
]

function formatDate(value?: string) {
  if (!value) return "—"

  const date = new Date(value)
  return new Intl.DateTimeFormat("en", { month: "short", day: "numeric" }).format(date)
}

export default function Dashboard({
  user,
  account,
  stats = [],
  highlights = [],
  activity = [],
  tasks = [],
}: DashboardProps) {
  const safeStats = stats.length ? stats : fallbackStats
  const safeTasks = tasks.length ? tasks : fallbackTasks
  const safeHighlights = highlights.length ? highlights : fallbackHighlights

  return (
    <AppLayout
      title="Dashboard"
      description="High-level view of your workspace with activity, tasks, and next steps."
      user={user}
      account={account}
      actions={
        <div className="flex items-center gap-2">
          <Button size="sm" variant="outline">
            Invite teammate
          </Button>
          <Button size="sm">New project</Button>
        </div>
      }
    >
      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        {safeStats.map((stat) => (
          <Card key={stat.label}>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                {stat.label}
              </CardTitle>
              <Badge variant="secondary">{stat.change || "Updated"}</Badge>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-semibold leading-tight">{stat.value}</div>
            </CardContent>
          </Card>
        ))}
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-start justify-between space-y-0">
            <div>
              <CardTitle>Workboard</CardTitle>
              <CardDescription>Stay organized with the most important items.</CardDescription>
            </div>
            <Button size="sm" variant="outline">
              View all
            </Button>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow className="hover:bg-transparent">
                  <TableHead className="w-32">ID</TableHead>
                  <TableHead>Title</TableHead>
                  <TableHead className="w-32">Owner</TableHead>
                  <TableHead className="w-32 text-right">Due</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {safeTasks.map((task) => (
                  <TableRow key={task.id}>
                    <TableCell className="font-semibold">{task.id}</TableCell>
                    <TableCell>
                      <div className="flex flex-col gap-1">
                        <span className="text-sm font-medium text-foreground">{task.title}</span>
                        <span
                          className={cn(
                            "text-xs font-medium",
                            statusTone[task.status] || "text-muted-foreground"
                          )}
                        >
                          {task.status}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell className="text-sm text-muted-foreground">{task.owner || "—"}</TableCell>
                    <TableCell className="text-right text-sm text-muted-foreground">
                      {formatDate(task.due_on)}
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
              <Bell className="h-4 w-4 text-primary" />
              Recent activity
            </CardTitle>
            <CardDescription>Latest signals from your team and systems.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {activity.length === 0 ? (
              <p className="text-sm text-muted-foreground">No recent activity yet.</p>
            ) : (
              activity.map((item) => (
                <div key={item.id} className="space-y-1 rounded-md border p-3">
                  <div className="flex items-center justify-between gap-2">
                    <p className="text-sm font-medium">{item.action}</p>
                    <span className="text-xs text-muted-foreground">
                      {item.occurred_at ? formatDate(item.occurred_at) : "Just now"}
                    </span>
                  </div>
                  <p className="text-xs text-muted-foreground">{item.description}</p>
                  <p className="text-xs font-medium text-primary">{item.actor}</p>
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex items-start justify-between gap-2">
            <div>
              <CardTitle>Highlights</CardTitle>
              <CardDescription>Fast wins to finish onboarding and reduce risk.</CardDescription>
            </div>
            <Button variant="outline" size="sm">
              View checklist
            </Button>
          </CardHeader>
          <CardContent className="grid gap-3 md:grid-cols-2">
            {safeHighlights.map((item) => (
              <div key={item.title} className="rounded-lg border bg-muted/30 p-4">
                <div className="mb-2 flex items-center gap-2">
                  <Badge variant="outline" className="text-xs">
                    {item.badge || "Action"}
                  </Badge>
                  <ArrowUpRight className="h-4 w-4 text-muted-foreground" />
                </div>
                <p className="text-sm font-semibold">{item.title}</p>
                <p className="text-xs text-muted-foreground">{item.description}</p>
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Shield className="h-4 w-4 text-primary" />
              Health checklist
            </CardTitle>
            <CardDescription>Security and billing signals at a glance.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="flex items-start gap-2 rounded-md border border-green-500/20 bg-emerald-500/5 p-3">
              <CheckCircle className="h-4 w-4 text-emerald-500" />
              <div className="space-y-1">
                <p className="text-sm font-semibold">Payments up-to-date</p>
                <p className="text-xs text-muted-foreground">
                  No outstanding invoices. Renewal scheduled automatically.
                </p>
              </div>
            </div>
            <Separator />
            <div className="flex items-start gap-2 rounded-md border border-blue-500/20 bg-blue-500/5 p-3">
              <Users className="h-4 w-4 text-blue-500" />
              <div className="space-y-1">
                <p className="text-sm font-semibold">Team adoption</p>
                <p className="text-xs text-muted-foreground">
                  Invite more collaborators to unlock approvals and reviews.
                </p>
              </div>
            </div>
          </CardContent>
        </Card>
      </section>
    </AppLayout>
  )
}
