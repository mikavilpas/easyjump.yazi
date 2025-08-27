import assert from "assert"
import { defineConfig } from "cypress"
import { readdir, readFile } from "fs/promises"
import path from "path"
import { inspect } from "util"

const testDirs = path.resolve(__dirname, "test-environment/testdirs")
export default defineConfig({
  e2e: {
    baseUrl: "http://localhost:3000",
    setupNodeEvents(on, _config) {
      on("task", {
        async showYaziLog(): Promise<null> {
          // find the yazi log file from the last run. There should be only one
          // because as soon as the test environment is exited, tui-sandbox
          // removes it. Typically it is in testdirs/abc/.local/state/yazi/yazi.log
          const files = await readdir(testDirs, {
            recursive: true,
            withFileTypes: true,
          })

          const logFiles = files.filter(
            (f) => f.isFile() && f.name === "yazi.log",
          )

          if (logFiles.length === 0) {
            console.warn("No yazi.log files found")
            return null // something must be returned
          }
          if (logFiles.length > 1) {
            console.error("Multiple yazi.log files found:")
            for (const f of logFiles) {
              console.log(f)
            }
          }

          const file = logFiles[0]
          assert(file)
          const yaziLogFile = path.resolve(file.parentPath, file.name)

          try {
            const log = await readFile(yaziLogFile, "utf-8")
            console.log(
              `${yaziLogFile}`,
              inspect(log.split("\n"), { maxArrayLength: null, colors: true }),
            )
            return null
          } catch (err) {
            console.error(err)
            return null // something must be returned
          }
        },
      })
    },
    experimentalRunAllSpecs: true,
    retries: {
      runMode: 2,
      openMode: 0,
    },
  },
})
