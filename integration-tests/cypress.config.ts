import { defineConfig } from "cypress"
import fs from "fs"

export default defineConfig({
  e2e: {
    baseUrl: "http://localhost:3000",
    video: true,
    setupNodeEvents(on, _config) {
      on("after:spec", (_spec, results): void => {
        // https://docs.cypress.io/app/guides/screenshots-and-videos#Delete-videos-for-specs-without-failing-or-retried-tests
        if (results && results.video) {
          // Do we have failures for any retry attempts?
          const failures = results.tests.some((test) => {
            return test.attempts.some((attempt) => attempt.state === "failed")
          })
          if (!failures && fs.existsSync(results.video)) {
            // delete the video if the spec passed and no tests retried
            return fs.unlinkSync(results.video)
          }
        }
      })
    },
    experimentalRunAllSpecs: true,
    retries: {
      runMode: 2,
      openMode: 0,
    },
  },
})
