import type { TerminalTestApplicationContext } from "cypress/support/tui-sandbox"
import type { MyTestDirectoryFile } from "MyTestDirectory"

export const startYaziApplication = ({
  dir,
}: {
  dir?: MyTestDirectoryFile
} = {}): Cypress.Chainable<TerminalTestApplicationContext> => {
  // start yazi in a terminal, optionally in a specific directory and with the
  // easyjump plugin linked
  return cy
    .startTerminalApplication({
      commandToRun: ["bash"],
      configureTerminal: (term) => {
        // yazi needs this to be able to start
        term.recipes.supportDA1()
      },
    })
    .then((term) => {
      // link the source code to be available in the test environment
      term.runBlockingShellCommand({
        command:
          "mkdir plugins && ln -s ../../../../../../../easyjump.yazi/ plugins/easyjump.yazi",
        cwdRelative: ".config/yazi",
      })

      term.runBlockingShellCommand({
        command: "test -f .config/yazi/plugins/easyjump.yazi/main.lua",
      })

      if (dir) {
        term.typeIntoTerminal(`cd ${dir}{enter}`, { delay: 0 })
      }
      term.typeIntoTerminal(
        // "YAZI_LOG=debug /Users/mikavilpas/Downloads/yazi-aarch64-apple-darwin/yazi{enter}",
        "YAZI_LOG=debug yazi{enter}",
        { delay: 0 },
      )

      return cy.wrap(term)
    })
}
