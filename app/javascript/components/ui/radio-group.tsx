import * as React from "react"

import { cn } from "@/lib/utils"

export interface RadioGroupProps extends React.HTMLAttributes<HTMLDivElement> {
  name: string
}

export interface RadioProps
  extends Omit<React.InputHTMLAttributes<HTMLInputElement>, "type"> {}

const RadioGroup = ({ className, ...props }: RadioGroupProps) => {
  return <div className={cn("space-y-3", className)} {...props} />
}

const Radio = React.forwardRef<HTMLInputElement, RadioProps>(
  ({ className, children, ...props }, ref) => (
    <label className="flex items-center space-x-2">
      <input
        type="radio"
        ref={ref}
        className={cn(
          "h-4 w-4 border-input text-primary focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          className
        )}
        {...props}
      />
      {children && <span className="text-sm text-foreground">{children}</span>}
    </label>
  )
)
Radio.displayName = "Radio"

export { Radio, RadioGroup }
