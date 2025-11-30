import { flavors } from "@catppuccin/palette"
import { rgbify } from "@tui-sandbox/library/dist/src/client/color-utilities.js"
import {
  textIsVisibleWithBackgroundColor,
  textIsVisibleWithColor,
} from "@tui-sandbox/library/dist/src/client/cypress-assertions"
import { startYaziApplication } from "./utils/startYaziApplication.js"

const candidateColor = "rgb(253, 161, 161)"
const firstCharReceivedColor = "rgb(223, 98, 73)"

const isFileSelected = (fileName: string) =>
  textIsVisibleWithColor(
    fileName,
    rgbify(flavors.macchiato.colors.text.rgb),
  ).then(() => {
    textIsVisibleWithBackgroundColor(
      fileName,
      rgbify(flavors.macchiato.colors.text.rgb),
    )
  })

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

  it("can customize the colors", () => {
    cy.visit("/")
    startYaziApplication({
      dir: "dir-with-jumpable-files",
      configModifications: ["customize_colors.lua"],
    }).then((term) => {
      // wait for the yazi ui to be visible. It will select the first file
      // automatically
      cy.contains("NOR")
      isFileSelected(
        term.dir.contents["dir-with-jumpable-files"].contents.file1.name,
      )

      // activate the easyjump plugin. yazi will prompt which file to jump to
      cy.typeIntoTerminal("i")

      // verify that the color has been customized
      const customizedColors = {
        fg: "rgb(148, 226, 213)",
      }
      textIsVisibleWithColor("b", customizedColors.fg)
    })
  })

  it("can jump to a file with two characters", () => {
    cy.visit("/")
    startYaziApplication({
      dir: "lots-of-files",
    }).then((term) => {
      cy.contains("NOR")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file.name)
      cy.typeIntoTerminal("i")

      textIsVisibleWithColor("ao", candidateColor)
      cy.typeIntoTerminal("a")

      // the first character is highlighted to mark that it has been received
      textIsVisibleWithColor("a", firstCharReceivedColor)
      cy.typeIntoTerminal("o")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file_1.name)
    })
  })

  it("can cancel the jump", () => {
    cy.visit("/")
    startYaziApplication({
      dir: "lots-of-files",
    }).then((term) => {
      cy.contains("NOR")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file.name)
      cy.typeIntoTerminal("i")

      textIsVisibleWithColor("ao", candidateColor)
      cy.typeIntoTerminal("a")

      // the first character is highlighted to mark that it has been received
      textIsVisibleWithColor("a", firstCharReceivedColor)

      // cancel the jump and verify the label disappears
      cy.typeIntoTerminal("{esc}")
      cy.contains("ao").should("not.exist")

      // the cursor should still be on the original file
      isFileSelected(term.dir.contents["lots-of-files"].contents.file.name)
    })
  })

  it("can use backspace to undo the first of two keys", () => {
    cy.visit("/")
    startYaziApplication({
      dir: "lots-of-files",
    }).then((term) => {
      // if the user types an incorrect first character, they can use
      // backspace to go back and try again without canceling the entire jump
      cy.contains("NOR")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file.name)
      cy.typeIntoTerminal("i")

      textIsVisibleWithColor("ao", candidateColor)
      cy.typeIntoTerminal("a")

      // the first character is highlighted to mark that it has been received
      textIsVisibleWithColor("a", firstCharReceivedColor)

      // press backspace to undo the first character
      cy.typeIntoTerminal("{backspace}")
      textIsVisibleWithColor("ao", candidateColor)
    })
  })
})
