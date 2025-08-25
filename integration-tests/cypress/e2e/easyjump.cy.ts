import { flavors } from "@catppuccin/palette"
import { rgbify } from "@tui-sandbox/library/dist/src/client/color-utilities.js"
import { textIsVisibleWithColor } from "@tui-sandbox/library/dist/src/client/cypress-assertions"
import { startYaziApplication } from "./utils/startYaziApplication.js"

const candidateColor = "rgb(253, 161, 161)"

const isFileSelected = (fileName: string) =>
  textIsVisibleWithColor(fileName, rgbify(flavors.macchiato.colors.text.rgb))

describe("easyjump", () => {
  it("can jump to a file", () => {
    cy.visit("/")
    startYaziApplication({ dir: "dir-with-jumpable-files" }).then((term) => {
      // wait for the yazi ui to be visible. It will select the first file
      // automatically
      cy.contains("NOR")
      isFileSelected(
        term.dir.contents["dir-with-jumpable-files"].contents.file1.name,
      )

      // activate the easyjump plugin. yazi will prompt which file to jump to
      cy.typeIntoTerminal("i")

      // the easyjump mode indicator must be visible
      cy.contains("[EJ]")

      textIsVisibleWithColor("b", candidateColor)
      cy.typeIntoTerminal("b")
      isFileSelected(
        term.dir.contents["dir-with-jumpable-files"].contents.file2.name,
      )

      // in normal mode, easyjump mode should be deactivated after a single
      // jump
      cy.contains("[EJ]").should("not.exist")
    })
  })
})
