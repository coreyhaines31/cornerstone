import { Head } from "@inertiajs/react"
import {
  Alert,
  AlertDescription,
  AlertTitle,
} from "@/components/ui/alert"
import { Avatar } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { Breadcrumb } from "@/components/ui/breadcrumb"
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
import { Progress } from "@/components/ui/progress"
import { Radio, RadioGroup } from "@/components/ui/radio-group"
import { Select } from "@/components/ui/select"
import { Separator } from "@/components/ui/separator"
import { Skeleton } from "@/components/ui/skeleton"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Textarea } from "@/components/ui/textarea"
import { cn } from "@/lib/utils"
import { Check, MoreHorizontal } from "lucide-react"

const sections = [
  { id: "buttons", label: "Buttons" },
  { id: "inputs", label: "Inputs" },
  { id: "badges", label: "Badges" },
  { id: "cards", label: "Cards" },
  { id: "alerts", label: "Alerts" },
  { id: "progress", label: "Progress" },
  { id: "tables", label: "Tables" },
  { id: "avatars", label: "Avatars" },
  { id: "breadcrumbs", label: "Breadcrumbs" },
  { id: "sidebar", label: "Sidebar" },
  { id: "layouts", label: "Layouts" },
]

const tasks = [
  {
    id: "TASK-8782",
    area: "Documentation",
    title:
      "You can't compress the program without quantifying the open-source SSD pixel!",
    status: { label: "In Progress", tone: "primary" },
    priority: { label: "Medium", indicator: "→" },
  },
  {
    id: "TASK-7878",
    area: "Documentation",
    title: "Try to calculate the EXE feed, maybe it will index the pixel!",
    status: { label: "Backlog", tone: "muted" },
    priority: { label: "Medium", indicator: "→" },
  },
  {
    id: "TASK-7839",
    area: "Bug",
    title: "We need to bypass the neural TCP card!",
    status: { label: "Todo", tone: "amber" },
    priority: { label: "High", indicator: "↑" },
  },
]

const SidebarLink = ({
  label,
  active = false,
}: {
  label: string
  active?: boolean
}) => (
  <button
    className={cn(
      "flex w-full items-center justify-between rounded-md px-3 py-2 text-sm transition-colors",
      active
        ? "bg-primary/10 text-foreground"
        : "text-muted-foreground hover:bg-accent hover:text-foreground"
    )}
    type="button"
  >
    <span>{label}</span>
    {active && <Check className="h-4 w-4 text-primary" />}
  </button>
)

function SectionHeading({
  id,
  title,
  description,
}: {
  id: string
  title: string
  description: string
}) {
  return (
    <div className="mb-8 space-y-2">
      <h2 id={id} className="text-3xl font-bold tracking-tight text-foreground">
        {title}
      </h2>
      <p className="text-lg text-muted-foreground">{description}</p>
    </div>
  )
}

export default function Styleguide() {
  return (
    <div className="bg-background min-h-screen py-12">
      <Head title="Design System Styleguide" />
      <div className="container mx-auto max-w-7xl px-6 lg:px-8">
        <div className="mx-auto mb-12 max-w-3xl text-center">
          <h1 className="text-4xl font-bold tracking-tight text-foreground sm:text-6xl">
            Cornerstone Design System
          </h1>
          <p className="mt-6 text-lg leading-8 text-muted-foreground">
            Rails + Inertia + React + Tailwind + shadcn/ui starter kit. Explore
            the interactive components now powered by Vite.
          </p>
        </div>

        <div className="mb-12 border-b border-border">
          <nav className="-mb-px flex space-x-6 overflow-x-auto" aria-label="Sections">
            {sections.map((section) => (
              <a
                key={section.id}
                href={`#${section.id}`}
                className="border-transparent pb-4 text-sm font-medium text-muted-foreground transition-colors hover:border-border hover:text-foreground"
              >
                {section.label}
              </a>
            ))}
          </nav>
        </div>

        <section className="mb-20 scroll-mt-20" id="buttons">
          <SectionHeading
            id="buttons-heading"
            title="Buttons"
            description="Display buttons in different variants and sizes."
          />

          <div className="space-y-10">
            <div>
              <h3 className="text-sm font-semibold text-foreground mb-4">Variants</h3>
              <div className="flex flex-wrap items-center gap-4">
                <Button>Default</Button>
                <Button variant="secondary">Secondary</Button>
                <Button variant="destructive">Destructive</Button>
                <Button variant="outline">Outline</Button>
                <Button variant="ghost">Ghost</Button>
                <Button variant="link">Link</Button>
              </div>
            </div>

            <div>
              <h3 className="text-sm font-semibold text-foreground mb-4">Sizes</h3>
              <div className="flex flex-wrap items-center gap-4">
                <Button size="sm">Small</Button>
                <Button size="default">Default</Button>
                <Button size="lg">Large</Button>
                <Button variant="outline" size="icon" aria-label="Heart">
                  ❤
                </Button>
              </div>
            </div>
          </div>
        </section>

        <section className="mb-20 scroll-mt-20" id="inputs">
          <SectionHeading
            id="inputs-heading"
            title="Form Components"
            description="Inputs, labels, and controls for capturing user data."
          />

          <div className="grid gap-10 lg:grid-cols-2">
            <div className="space-y-4">
              <h3 className="text-sm font-semibold text-foreground">Input</h3>
              <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input id="email" type="email" placeholder="email@example.com" />
              </div>
            </div>

            <div className="space-y-4">
              <h3 className="text-sm font-semibold text-foreground">Textarea</h3>
              <div className="space-y-2">
                <Label htmlFor="message">Message</Label>
                <Textarea id="message" placeholder="Type your message here..." />
              </div>
            </div>

            <div className="space-y-4">
              <h3 className="text-sm font-semibold text-foreground">Select</h3>
              <div className="space-y-2">
                <Label htmlFor="select">Select an option</Label>
                <Select id="select" defaultValue="option1">
                  <option value="option1">Option 1</option>
                  <option value="option2">Option 2</option>
                  <option value="option3">Option 3</option>
                </Select>
              </div>
            </div>

            <div className="space-y-4">
              <h3 className="text-sm font-semibold text-foreground">Checkbox</h3>
              <div className="flex items-center space-x-2">
                <Checkbox id="terms" defaultChecked />
                <Label htmlFor="terms">Accept terms and conditions</Label>
              </div>
            </div>

            <div className="space-y-4">
              <h3 className="text-sm font-semibold text-foreground">Radio Group</h3>
              <RadioGroup name="plan">
                <Radio name="plan" value="free" defaultChecked>
                  Free
                </Radio>
                <Radio name="plan" value="pro">
                  Pro
                </Radio>
                <Radio name="plan" value="enterprise">
                  Enterprise
                </Radio>
              </RadioGroup>
            </div>
          </div>
        </section>

        <section className="mb-20 scroll-mt-20" id="badges">
          <SectionHeading
            id="badges-heading"
            title="Badges"
            description="Display status, labels, or categories."
          />
          <div className="flex flex-wrap items-center gap-4">
            <Badge>Default</Badge>
            <Badge variant="secondary">Secondary</Badge>
            <Badge variant="destructive">Destructive</Badge>
            <Badge variant="outline">Outline</Badge>
          </div>
        </section>

        <section className="mb-20 scroll-mt-20" id="cards">
          <SectionHeading
            id="cards-heading"
            title="Cards"
            description="Use card containers for grouping related content."
          />

          <div className="grid auto-rows-min gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <Card>
              <CardHeader>
                <CardTitle>Card Title</CardTitle>
                <CardDescription>Card description goes here.</CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">
                  This is the card content area.
                </p>
              </CardContent>
              <CardFooter>
                <Button variant="outline" size="sm">
                  Action
                </Button>
              </CardFooter>
            </Card>

            <Card>
              <CardContent className="flex items-center gap-4 pt-6">
                <Avatar initials="JD" />
                <div>
                  <p className="text-sm font-medium">John Doe</p>
                  <p className="text-xs text-muted-foreground">john@example.com</p>
                </div>
              </CardContent>
              <Separator className="my-1 h-px w-full" />
              <CardContent>
                <p className="text-sm text-muted-foreground">
                  Card with avatar and separator.
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="space-y-3 pt-6">
                <Skeleton className="h-32 w-full" />
                <Skeleton className="h-4 w-3/4" />
                <Skeleton className="h-4 w-1/2" />
              </CardContent>
            </Card>
          </div>
        </section>

        <section className="mb-20 scroll-mt-20" id="alerts">
          <SectionHeading
            id="alerts-heading"
            title="Alerts"
            description="Display important messages and notifications."
          />

          <div className="max-w-2xl space-y-4">
            <Alert>
              <AlertTitle>Heads up!</AlertTitle>
              <AlertDescription>
                You can add components to your app using the design system.
              </AlertDescription>
            </Alert>

            <Alert variant="destructive">
              <AlertTitle>Error</AlertTitle>
              <AlertDescription>
                Your session has expired. Please log in again.
              </AlertDescription>
            </Alert>
          </div>
        </section>

        <section className="mb-20 scroll-mt-20" id="progress">
          <SectionHeading
            id="progress-heading"
            title="Progress"
            description="Visualize task completion over time."
          />

          <div className="max-w-2xl space-y-4">
            <Progress value={33} />
            <Progress value={66} />
            <Progress value={100} />
          </div>
        </section>

        <section className="mb-20 scroll-mt-20" id="tables">
          <SectionHeading
            id="tables-heading"
            title="Tables"
            description="Tabular data with filters and actions."
          />

          <div className="space-y-4">
            <div className="flex items-center justify-between gap-2">
              <div className="flex flex-1 items-center space-x-2">
                <Input
                  type="text"
                  placeholder="Filter tasks..."
                  className="h-8 w-[150px] lg:w-[250px]"
                />
                <Button variant="outline" size="sm">
                  Status
                </Button>
                <Button variant="outline" size="sm">
                  Priority
                </Button>
              </div>
              <Button size="sm">Add Task</Button>
            </div>

            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-12">
                    <Checkbox aria-label="Select all tasks" />
                  </TableHead>
                  <TableHead className="w-32">Task</TableHead>
                  <TableHead>Title</TableHead>
                  <TableHead className="w-32">Status</TableHead>
                  <TableHead className="w-32">Priority</TableHead>
                  <TableHead className="w-12" />
                </TableRow>
              </TableHeader>
              <TableBody>
                {tasks.map((task) => (
                  <TableRow key={task.id}>
                    <TableCell>
                      <Checkbox aria-label={`Select ${task.id}`} />
                    </TableCell>
                    <TableCell className="font-medium">{task.id}</TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <span className="inline-flex items-center rounded-md border border-input bg-background px-2.5 py-0.5 text-xs font-normal">
                          {task.area}
                        </span>
                        <span className="truncate">{task.title}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2 whitespace-nowrap">
                        <span
                          className={cn(
                            "h-2 w-2 rounded-full flex-shrink-0",
                            task.status.tone === "primary" && "bg-blue-500",
                            task.status.tone === "muted" && "bg-gray-500",
                            task.status.tone === "amber" && "bg-yellow-500"
                          )}
                        />
                        <span>{task.status.label}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-1 whitespace-nowrap">
                        <span>{task.priority.indicator}</span>
                        <span>{task.priority.label}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon" className="h-8 w-8" aria-label="More">
                        <MoreHorizontal className="h-4 w-4" />
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </section>

        <section className="mb-20 scroll-mt-20" id="avatars">
          <SectionHeading
            id="avatars-heading"
            title="Avatars"
            description="Show people with images or fallback initials."
          />
          <div className="flex items-center gap-4">
            <Avatar initials="AB" />
            <Avatar initials="CD" />
            <Avatar initials="EF" />
          </div>
        </section>

        <section className="mb-20 scroll-mt-20" id="breadcrumbs">
          <SectionHeading
            id="breadcrumbs-heading"
            title="Breadcrumbs"
            description="Page location within the app."
          />
          <Breadcrumb
            items={[
              { label: "Home", href: "/" },
              { label: "Products", href: "/products" },
              { label: "Current Page" },
            ]}
          />
        </section>

        <section className="mb-20 scroll-mt-20" id="sidebar">
          <SectionHeading
            id="sidebar-heading"
            title="Sidebar"
            description="Application sidebar with groups and quick actions."
          />

          <Card className="overflow-hidden">
            <CardHeader className="border-b border-border">
              <CardTitle>Acme Inc</CardTitle>
              <CardDescription>Switch teams and manage navigation.</CardDescription>
            </CardHeader>
            <CardContent className="grid gap-6 pt-6 lg:grid-cols-[280px_1fr]">
              <div className="space-y-2">
                <SidebarLink label="Overview" active />
                <SidebarLink label="Analytics" />
                <SidebarLink label="Notifications" />
                <SidebarLink label="Settings" />
                <SidebarLink label="Support" />
              </div>
              <div className="rounded-lg border border-dashed bg-muted/10 p-4 text-sm text-muted-foreground">
                Drop your own navigation here. Use collapsible groups, badges, and icons
                from shadcn/ui to compose richer structures.
              </div>
            </CardContent>
          </Card>
        </section>

        <section className="mb-20 scroll-mt-20" id="layouts">
          <SectionHeading
            id="layouts-heading"
            title="Layouts"
            description="Responsive building blocks for dashboards and marketing."
          />

          <div className="grid gap-6 lg:grid-cols-2">
            <Card>
              <CardHeader>
                <CardTitle>Dashboard</CardTitle>
                <CardDescription>Metrics, charts, and data lists.</CardDescription>
              </CardHeader>
              <CardContent className="grid gap-4 md:grid-cols-2">
                <div className="rounded-lg border border-border bg-background p-4">
                  <p className="text-xs text-muted-foreground">Daily Active Users</p>
                  <p className="text-2xl font-semibold">12,481</p>
                  <p className="text-xs text-emerald-600">Up 12% vs last week</p>
                </div>
                <div className="rounded-lg border border-border bg-background p-4">
                  <p className="text-xs text-muted-foreground">MRR</p>
                  <p className="text-2xl font-semibold">$184,920</p>
                  <p className="text-xs text-emerald-600">Up 4.1% vs last week</p>
                </div>
                <div className="rounded-lg border border-border bg-background p-4 md:col-span-2">
                  <Skeleton className="h-32 w-full" />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Two-Column</CardTitle>
                <CardDescription>Hero + supporting content.</CardDescription>
              </CardHeader>
              <CardContent className="grid gap-4 md:grid-cols-2">
                <div className="space-y-3">
                  <Skeleton className="h-8 w-3/4" />
                  <Skeleton className="h-4 w-5/6" />
                  <Skeleton className="h-4 w-1/2" />
                  <div className="flex gap-2 pt-2">
                    <Button size="sm">Get Started</Button>
                    <Button size="sm" variant="outline">
                      Learn More
                    </Button>
                  </div>
                </div>
                <Skeleton className="h-36 w-full rounded-lg" />
              </CardContent>
            </Card>
          </div>
        </section>
      </div>
    </div>
  )
}
