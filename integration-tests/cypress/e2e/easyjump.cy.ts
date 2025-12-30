import { flavors } from "@catppuccin/palette"
import {
  rgbify,
  textIsVisibleWithBackgroundColor,
  textIsVisibleWithColor,
} from "@tui-sandbox/library"
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

  it("ignores keys that don't match the current hints", () => {
    cy.visit("/")
    startYaziApplication({
      dir: "lots-of-files",
    }).then((term) => {
      // if the user types an incorrect first character, they can use
      // backspace to go back and try again without canceling the entire jump
      cy.contains("NOR")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file.name)
      cy.typeIntoTerminal("i")

      // wait until the hints are shown
      textIsVisibleWithColor("ao", candidateColor)

      // input a key that does not match any hints
      cy.typeIntoTerminal("x")

      // the key must have been ignored, so we can input the first valid key
      cy.typeIntoTerminal("a")
      textIsVisibleWithColor("a", firstCharReceivedColor)

      // complete the jump
      cy.typeIntoTerminal("o")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file_1.name)

      // TODO invalid second key should be ignored as well, but this did not
      // work when I tried it out
    })
  })

  it("can use custom hint keys", () => {
    cy.visit("/")
    startYaziApplication({
      dir: "lots-of-files",
      configModifications: ["customize_keys.lua"],
    }).then((term) => {
      // wait for the yazi ui to be visible
      cy.contains("NOR")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file.name)

      // activate the easyjump plugin
      cy.typeIntoTerminal("i")

      // wait for easyjump mode to activate
      cy.contains("[EJ]")

      // the custom keys are: first_keys="qwertasdfgzxcv", second_keys="yuiophjklnm"
      // double labels are generated as first_keys × second_keys
      // so first label is "qy", second is "qu", third is "qi", etc.
      // type "qu" to jump to the second file (file_1)
      cy.typeIntoTerminal("qu")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file_1.name)
    })
  })

  it("shows error notification when first_keys and second_keys overlap", () => {
    cy.visit("/")
    startYaziApplication({
      dir: "lots-of-files",
      configModifications: ["duplicate_keys.lua"],
    }).then((term) => {
      // wait for the yazi ui to be visible
      cy.contains("NOR")

      // the error notification should be displayed because "a" is in both
      // first_keys and second_keys
      cy.contains("appears in both first_keys and second_keys")
      cy.contains("Falling back to defaults")

      // the plugin should still work with default keys
      isFileSelected(term.dir.contents["lots-of-files"].contents.file.name)
      cy.typeIntoTerminal("i")
      cy.contains("[EJ]")

      // default double labels start with "au", "ai", "ao", etc.
      // type "ao" to jump to the third file
      cy.typeIntoTerminal("ao")
      isFileSelected(term.dir.contents["lots-of-files"].contents.file_1.name)
    })
  })
})
