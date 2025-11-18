import * as React from "react"
import { cn } from "@/lib/utils"

interface BreadcrumbProps {
  items: Array<{ label: string; href?: string }>
  className?: string
}

function Breadcrumb({ items, className }: BreadcrumbProps) {
  return (
    <nav className={cn("flex items-center space-x-1 text-sm text-muted-foreground", className)}>
      {items.map((item, index) => {
        const isLast = index === items.length - 1
        return (
          <React.Fragment key={`${item.label}-${index}`}>
            {item.href && !isLast ? (
              <a href={item.href} className="hover:text-foreground">
                {item.label}
              </a>
            ) : (
              <span className={cn(isLast ? "text-foreground font-medium" : undefined)}>{item.label}</span>
            )}
            {!isLast && <span className="opacity-50">/</span>}
          </React.Fragment>
        )
      })}
    </nav>
  )
}

export { Breadcrumb }
