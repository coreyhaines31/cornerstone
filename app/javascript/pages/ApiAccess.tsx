import { AppLayout } from "@/components/layouts/AppLayout"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { cn } from "@/lib/utils"
import { Copy, KeyRound, Shield, Webhook } from "lucide-react"

type ApiKey = { name: string; last_used_at?: string; prefix?: string; status?: string }
type WebhookEndpoint = { url: string; status: string; last_event_at?: string }

type ApiAccessProps = {
  account?: { name?: string; plan?: string; subscription_status?: string }
  user?: { name?: string; email?: string; initials?: string }
  api_keys?: ApiKey[]
  webhooks?: WebhookEndpoint[]
}

const fallbackKeys: ApiKey[] = [
  { name: "Production key", last_used_at: new Date().toISOString(), prefix: "pk_live_", status: "active" },
  { name: "Staging key", last_used_at: new Date(Date.now() - 86400000).toISOString(), prefix: "pk_test_", status: "active" },
]

const fallbackWebhooks: WebhookEndpoint[] = [
  { url: "https://example.com/webhooks", status: "healthy", last_event_at: new Date().toISOString() },
  { url: "https://staging.example.com/webhooks", status: "retrying", last_event_at: new Date(Date.now() - 3600000).toISOString() },
]

function formatDate(value?: string) {
  if (!value) return "—"
  return new Intl.DateTimeFormat("en", { month: "short", day: "numeric" }).format(new Date(value))
}

export default function ApiAccess({
  account,
  user,
  api_keys = [],
  webhooks = [],
}: ApiAccessProps) {
  const safeKeys = api_keys.length ? api_keys : fallbackKeys
  const safeWebhooks = webhooks.length ? webhooks : fallbackWebhooks

  return (
    <AppLayout
      title="API keys & webhooks"
      description="Manage keys, rotation, IP allowlists, and webhook delivery."
      account={account}
      user={user}
      actions={<Button size="sm">Create key</Button>}
      breadcrumbs={[
        { label: "Home", href: "/dashboard" },
        { label: "API & Webhooks" },
      ]}
    >
      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <KeyRound className="h-4 w-4 text-primary" />
                API keys
              </CardTitle>
              <CardDescription>Rotate keys regularly and scope by environment.</CardDescription>
            </div>
            <Button variant="outline" size="sm">
              Rotate key
            </Button>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow className="hover:bg-transparent">
                  <TableHead>Name</TableHead>
                  <TableHead>Prefix</TableHead>
                  <TableHead>Last used</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {safeKeys.map((key) => (
                  <TableRow key={key.name}>
                    <TableCell className="font-semibold">{key.name}</TableCell>
                    <TableCell className="text-sm text-muted-foreground">{key.prefix || "—"}</TableCell>
                    <TableCell className="text-sm text-muted-foreground">{formatDate(key.last_used_at)}</TableCell>
                    <TableCell>
                      <Badge variant="secondary" className="capitalize">
                        {key.status || "active"}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right">
                      <div className="flex justify-end gap-2">
                        <Button size="sm" variant="outline">
                          Copy
                        </Button>
                        <Button size="sm" variant="ghost">
                          Disable
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
            <CardTitle>IP allowlist</CardTitle>
            <CardDescription>Restrict API access to trusted IPs.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <Input placeholder="Add IPv4 or CIDR block" />
            <div className="space-y-2 rounded-lg border p-3 text-xs text-muted-foreground">
              <p className="font-semibold text-foreground">Examples</p>
              <p>203.0.113.0</p>
              <p>192.0.2.0/24</p>
            </div>
          </CardContent>
        </Card>
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Webhook className="h-4 w-4 text-primary" />
                Webhook endpoints
              </CardTitle>
              <CardDescription>Monitor delivery health and replay events.</CardDescription>
            </div>
            <Button variant="outline" size="sm">
              Add endpoint
            </Button>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow className="hover:bg-transparent">
                  <TableHead>URL</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Last event</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {safeWebhooks.map((hook) => (
                  <TableRow key={hook.url}>
                    <TableCell className="font-semibold">{hook.url}</TableCell>
                    <TableCell>
                      <Badge
                        variant={hook.status === "healthy" ? "secondary" : "outline"}
                        className={cn("capitalize", hook.status === "retrying" ? "text-amber-600 dark:text-amber-500" : "")}
                      >
                        {hook.status}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-sm text-muted-foreground">{formatDate(hook.last_event_at)}</TableCell>
                    <TableCell className="text-right">
                      <div className="flex justify-end gap-2">
                        <Button size="sm" variant="outline">
                          Replay
                        </Button>
                        <Button size="sm" variant="ghost">
                          Disable
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
              <Shield className="h-4 w-4 text-primary" />
              Signing secret
            </CardTitle>
            <CardDescription>Verify webhook signatures on your server.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <Input readOnly value="whsec_••••••••••••" />
            <Button size="sm" variant="outline" className="w-full">
              Copy secret
            </Button>
            <p className="text-xs text-muted-foreground">
              Rotate secrets if you suspect compromise. Update your server verification logic accordingly.
            </p>
          </CardContent>
        </Card>
      </section>
    </AppLayout>
  )
}
