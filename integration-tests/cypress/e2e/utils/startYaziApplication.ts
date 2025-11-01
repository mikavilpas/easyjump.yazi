import type { MyNeovimConfigModification } from "@tui-sandbox/library/src/client/MyNeovimConfigModification"
import path from "path"
import type { MyTestDirectoryFile } from "../../../MyTestDirectory"
import type { TerminalTestApplicationContext } from "../../support/tui-sandbox"

type StartYaziApplicationArgs = {
  dir?: MyTestDirectoryFile
  configModifications?: MyNeovimConfigModification<MyTestDirectoryFile>[]
}

export const startYaziApplication = ({
  dir,
  configModifications = [],
}: StartYaziApplicationArgs = {}): Cypress.Chainable<TerminalTestApplicationContext> => {
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

      // append all the configModifications into the yazi config init.lua file
      for (const modification of configModifications) {
        const file = path.resolve(
          term.dir.rootPathAbsolute,
          "config-modifications",
          modification,
        )
        term.runBlockingShellCommand({
          command: `cat ${file} >> .config/yazi/init.lua`,
        })
      }

      if (dir) {
        term.runBlockingShellCommand({ command: `test -d ${dir}` })
        term.typeIntoTerminal(`cd ${dir}{enter}`, { delay: 0 })
      }

      // https://yazi-rs.github.io/docs/plugins/overview/#logging
      term.typeIntoTerminal("YAZI_LOG=debug yazi{enter}", { delay: 0 })

      return cy.wrap(term)
    })
}
