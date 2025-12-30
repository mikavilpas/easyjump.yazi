ya.dbg("configuring easyjump with duplicate keys (should show error)")

require("easyjump"):setup({
  -- "a" appears in both first_keys and second_keys - this is invalid
  first_keys = "asdf",
  second_keys = "ahjk",
})
