import { createDefaultConfig } from "@tui-sandbox/library/dist/src/server/config.js"
import type { TestServerConfig } from "@tui-sandbox/library/dist/src/server/index.js"

export const config: TestServerConfig = createDefaultConfig(process.cwd(), process.env)
config.formatter = { use: "oxfmt" }
