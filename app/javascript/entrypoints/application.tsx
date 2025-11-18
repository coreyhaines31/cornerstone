import "../styles/tailwind.css"
import "nprogress/nprogress.css"

import { createInertiaApp, router } from "@inertiajs/react"
import { createRoot } from "react-dom/client"
import NProgress from "nprogress"

type PageResolver = Record<string, () => Promise<unknown>>

const pages: PageResolver = import.meta.glob("../pages/**/*.tsx")

NProgress.configure({ showSpinner: false })

createInertiaApp({
  title: (title) => (title ? `${title} | Cornerstone` : "Cornerstone"),
  resolve: (name) => {
    const page = pages[`../pages/${name}.tsx`]

    if (!page) {
      throw new Error(`Page not found: ${name}`)
    }

    return page().then((module: any) => module.default)
  },
  setup({ el, App, props }) {
    const root = createRoot(el)
    root.render(<App {...props} />)
  },
  progress: false,
})

router.on("start", () => NProgress.start())
router.on("finish", () => {
  NProgress.done()
  window.scrollTo({ top: 0, behavior: "smooth" })
})
