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
import { Input } from "@/components/ui/input"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { cn } from "@/lib/utils"
import { Check, CreditCard, Receipt } from "lucide-react"

type Plan = { name: string; price: string; period: string; features: string[]; recommended?: boolean }
type PaymentMethod = { brand: string; last4: string; expiry: string; primary?: boolean }
type Invoice = { id: string; amount: string; period: string; status: string; url?: string }

type BillingProps = {
  account?: { name?: string; plan?: string; subscription_status?: string }
  user?: { name?: string; email?: string; initials?: string }
  plans?: Plan[]
  payment_methods?: PaymentMethod[]
  invoices?: Invoice[]
}

const fallbackPlans: Plan[] = [
  { name: "Starter", price: "$0", period: "mo", features: ["Up to 3 members", "Community support"] },
  {
    name: "Growth",
    price: "$29",
    period: "mo",
    features: ["Up to 25 members", "Usage analytics", "Priority email support"],
    recommended: true,
  },
  { name: "Scale", price: "$99", period: "mo", features: ["Unlimited members", "SSO/SCIM", "Audit logs"] },
]

const fallbackMethods: PaymentMethod[] = [
  { brand: "Visa", last4: "4242", expiry: "12/26", primary: true },
  { brand: "Mastercard", last4: "1881", expiry: "05/27", primary: false },
]

const fallbackInvoices: Invoice[] = [
  { id: "INV-001", amount: "$29.00", period: "Jan 2025", status: "paid" },
  { id: "INV-002", amount: "$29.00", period: "Feb 2025", status: "open" },
]

export default function Billing({
  account,
  user,
  plans = [],
  payment_methods = [],
  invoices = [],
}: BillingProps) {
  const safePlans = plans.length ? plans : fallbackPlans
  const safeMethods = payment_methods.length ? payment_methods : fallbackMethods
  const safeInvoices = invoices.length ? invoices : fallbackInvoices

  return (
    <AppLayout
      title="Billing & invoices"
      description="Manage plan, payment methods, and invoice history."
      account={account}
      user={user}
      actions={<Button size="sm">Update billing</Button>}
      breadcrumbs={[
        { label: "Home", href: "/dashboard" },
        { label: "Billing" },
      ]}
    >
      <section className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <CreditCard className="h-4 w-4 text-primary" />
              Payment methods
            </CardTitle>
            <CardDescription>Keep a primary card on file for renewals.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {safeMethods.map((method) => (
              <div key={`${method.brand}-${method.last4}`} className="flex items-center justify-between rounded-lg border p-3">
                <div className="space-y-1">
                  <p className="text-sm font-semibold">{method.brand}</p>
                  <p className="text-xs text-muted-foreground">•••• {method.last4} · Exp {method.expiry}</p>
                </div>
                <div className="flex items-center gap-2">
                  {method.primary && <Badge variant="secondary">Primary</Badge>}
                  <Button size="sm" variant="outline">Make primary</Button>
                </div>
              </div>
            ))}
            <div className="grid gap-3 md:grid-cols-2">
              <Input placeholder="Card number" />
              <div className="grid grid-cols-2 gap-2">
                <Input placeholder="MM/YY" />
                <Input placeholder="CVC" />
              </div>
              <Input placeholder="Cardholder name" className="md:col-span-2" />
              <Button className="md:col-span-2" size="sm">Add card</Button>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Current plan</CardTitle>
            <CardDescription>{account?.plan || "Select a plan"}</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            {safePlans.map((plan) => (
              <div
                key={plan.name}
                className={cn(
                  "rounded-lg border p-3",
                  plan.recommended ? "border-primary/50 bg-primary/5" : "bg-muted/40"
                )}
              >
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-semibold">{plan.name}</p>
                    <p className="text-xs text-muted-foreground">
                      {plan.price}/{plan.period}
                    </p>
                  </div>
                  {plan.recommended && <Badge variant="secondary">Recommended</Badge>}
                </div>
                <ul className="mt-2 space-y-1 text-xs text-muted-foreground">
                  {plan.features.map((feature) => (
                    <li key={feature} className="flex items-center gap-2">
                      <Check className="h-3 w-3 text-primary" />
                      {feature}
                    </li>
                  ))}
                </ul>
                <Button variant="outline" size="sm" className="mt-3 w-full">
                  Choose {plan.name}
                </Button>
              </div>
            ))}
          </CardContent>
        </Card>
      </section>

      <section>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Receipt className="h-4 w-4 text-primary" />
                Invoice history
              </CardTitle>
              <CardDescription>Your recent billing documents.</CardDescription>
            </div>
            <Button size="sm" variant="outline">
              Download all
            </Button>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow className="hover:bg-transparent">
                  <TableHead>Invoice</TableHead>
                  <TableHead>Period</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="text-right">Amount</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {safeInvoices.map((invoice) => (
                  <TableRow key={invoice.id}>
                    <TableCell className="font-semibold">{invoice.id}</TableCell>
                    <TableCell className="text-sm text-muted-foreground">{invoice.period}</TableCell>
                    <TableCell>
                      <Badge variant={invoice.status === "paid" ? "secondary" : "outline"} className="capitalize">
                        {invoice.status}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right font-semibold">{invoice.amount}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </section>
    </AppLayout>
  )
}
