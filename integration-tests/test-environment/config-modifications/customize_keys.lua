ya.dbg("customizing easyjump keys")

require("easyjump"):setup({
  -- Use custom keys with same count as defaults but different characters
  -- first_keys: 14 keys (same as default)
  -- second_keys: 11 keys (same as default)
  -- This gives 25 single labels (first + second) and 154 double labels (first * second)
  first_keys = "qwertasdfgzxcv",
  second_keys = "yuiophjklnm",
})
