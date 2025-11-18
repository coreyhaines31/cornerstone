import { Head, Link, usePage } from "@inertiajs/react"
import type { LucideIcon } from "lucide-react"
import {
  ChevronDown,
  CreditCard,
  KeyRound,
  LayoutDashboard,
  LifeBuoy,
  LogOut,
  Settings2,
  UserRound,
  Users,
} from "lucide-react"
import type { ReactNode } from "react"

import { Avatar } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { Breadcrumb } from "@/components/ui/breadcrumb"
import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { cn } from "@/lib/utils"

type BreadcrumbItem = { label: string; href?: string }
type NavItem = { label: string; href: string; icon: LucideIcon }

type UserSummary = { name?: string; email?: string; initials?: string }
type AccountSummary = { name?: string; plan?: string; subscription_status?: string }

type SharedPageProps = {
  current_user?: { first_name?: string; last_name?: string; email?: string }
  current_account?: AccountSummary
}

type AppLayoutProps = {
  title: string
  description?: string
  actions?: ReactNode
  breadcrumbs?: BreadcrumbItem[]
  children: ReactNode
  user?: UserSummary
  account?: AccountSummary
}

const navItems: NavItem[] = [
  { label: "Dashboard", href: "/dashboard", icon: LayoutDashboard },
  { label: "Billing", href: "/billing", icon: CreditCard },
  { label: "Team", href: "/team", icon: Users },
  { label: "API & Webhooks", href: "/api-access", icon: KeyRound },
  { label: "Settings", href: "/settings", icon: Settings2 },
  { label: "Profile", href: "/profile", icon: UserRound },
]

function initialsFromName(name?: string, email?: string) {
  if (name) {
    const initials = name
      .split(" ")
      .filter(Boolean)
      .map((part) => part[0])
      .join("")
      .slice(0, 2)
    if (initials) return initials.toUpperCase()
  }
  if (email) return email.slice(0, 2).toUpperCase()
  return "U"
}

function SidebarNav({ url }: { url: string }) {
  return (
    <nav className="space-y-1">
      {navItems.map((item) => {
        const isActive = url === item.href || url.startsWith(`${item.href}/`)
        const Icon = item.icon
        return (
          <Link
            key={item.href}
            href={item.href}
            className={cn(
              "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
              isActive
                ? "bg-muted text-foreground"
                : "text-muted-foreground hover:bg-muted/60 hover:text-foreground"
            )}
          >
            <Icon className="h-4 w-4" />
            <span>{item.label}</span>
          </Link>
        )
      })}
    </nav>
  )
}

export function AppLayout({
  title,
  description,
  actions,
  breadcrumbs,
  children,
  user,
  account,
}: AppLayoutProps) {
  const { url, props } = usePage<SharedPageProps>()
  const derivedUser =
    user ||
    (props.current_user && {
      name:
        `${props.current_user.first_name || ""} ${props.current_user.last_name || ""}`.trim() ||
        props.current_user.email,
      email: props.current_user.email,
    })

  const derivedAccount = account || props.current_account
  const avatarInitials = user?.initials || initialsFromName(derivedUser?.name, derivedUser?.email)

  return (
    <div className="flex min-h-screen bg-background text-foreground">
      <Head title={title} />

      <aside className="hidden w-72 border-r bg-card/50 md:block">
        <div className="flex h-full flex-col">
          <div className="border-b px-4 py-4">
            <button
              type="button"
              className="flex w-full items-center justify-between rounded-lg border px-3 py-2 text-left text-sm font-semibold transition hover:bg-muted/50"
            >
              <div className="flex flex-col">
                <span className="truncate">{derivedAccount?.name || "Select workspace"}</span>
                <span className="text-xs text-muted-foreground">
                  {derivedAccount?.plan || "Plan pending"}
                </span>
              </div>
              <ChevronDown className="h-4 w-4 text-muted-foreground" />
            </button>
          </div>

          <div className="flex-1 space-y-6 overflow-y-auto px-4 py-6">
            <div>
              <p className="px-3 pb-2 text-xs font-semibold uppercase text-muted-foreground">Main</p>
              <SidebarNav url={url} />
            </div>

            <div className="space-y-1">
              <p className="px-3 pb-2 text-xs font-semibold uppercase text-muted-foreground">Workspace</p>
              <Link
                href="/settings/security"
                className="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition hover:bg-muted/60 hover:text-foreground"
              >
                <Settings2 className="h-4 w-4" />
                Security
              </Link>
              <Link
                href="/contact"
                className="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition hover:bg-muted/60 hover:text-foreground"
              >
                <LifeBuoy className="h-4 w-4" />
                Support
              </Link>
            </div>
          </div>

          <div className="border-t px-4 py-4">
            <button
              type="button"
              className="flex w-full items-center justify-between rounded-lg px-2 py-2 hover:bg-muted/70"
            >
              <div className="flex items-center gap-3">
                <Avatar initials={avatarInitials} className="h-9 w-9" />
                <div className="text-left">
                  <p className="text-sm font-semibold leading-tight">{derivedUser?.name || "Account"}</p>
                  <p className="text-xs text-muted-foreground">{derivedUser?.email}</p>
                </div>
              </div>
              <ChevronDown className="h-4 w-4 text-muted-foreground" />
            </button>
            <div className="mt-2 space-y-1 rounded-lg border p-2 text-sm text-muted-foreground">
              <Link href="/profile" className="flex items-center gap-2 rounded-md px-2 py-1 hover:bg-muted/70">
                <UserRound className="h-4 w-4" /> Profile
              </Link>
              <Link
                href="/users/sign_out"
                method="delete"
                as="button"
                className="flex w-full items-center gap-2 rounded-md px-2 py-1 text-left hover:bg-muted/70"
              >
                <LogOut className="h-4 w-4" /> Logout
              </Link>
            </div>
          </div>
        </div>
      </aside>

      <main className="flex-1">
        <div className="border-b bg-card/50 px-6 py-5">
          <div className="flex items-center justify-between gap-3">
            <div className="space-y-1">
              <h1 className="text-2xl font-semibold leading-tight">{title}</h1>
              {description && <p className="text-sm text-muted-foreground">{description}</p>}
            </div>
            {actions}
          </div>
          {breadcrumbs && breadcrumbs.length > 0 && (
            <div className="pt-3">
              <Breadcrumb items={breadcrumbs} className="text-xs" />
            </div>
          )}
        </div>

        <div className="space-y-6 px-6 py-6">{children}</div>
      </main>
    </div>
  )
}
