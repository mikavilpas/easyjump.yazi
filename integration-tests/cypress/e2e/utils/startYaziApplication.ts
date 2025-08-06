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

      // debugging
      // term.typeIntoTerminal("ls -al .config/yazi/plugins/easyjump.yazi/{enter}")
      term.runBlockingShellCommand({
        command: "test -f .config/yazi/plugins/easyjump.yazi/main.lua",
      })

      if (dir) {
        term.typeIntoTerminal(`cd ${dir}{enter}`)
      }
      term.typeIntoTerminal("yazi{enter}")

      return cy.wrap(term)
    })
}
