import * as React from "react"
import { cn } from "@/lib/utils"

export interface AvatarProps extends React.HTMLAttributes<HTMLDivElement> {
  initials: string
}

function Avatar({ initials, className, children, ...props }: AvatarProps) {
  return (
    <div
      className={cn(
        "flex h-10 w-10 items-center justify-center rounded-full bg-muted text-sm font-semibold text-foreground",
        className
      )}
      {...props}
    >
      {children || initials}
    </div>
  )
}

export { Avatar }
