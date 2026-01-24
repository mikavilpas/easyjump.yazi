# easyjump.yazi

A yazi plugin for quickly jumping to the visible files.

A bit like [hop.nvim](https://github.com/smoka7/hop.nvim) in Neovim but for
yazi.

Tested on yazi nightly, stable, up to 25.5.31. The exact versions are visible in
[test.yml](.github/workflows/test.yml). Also see the
[yazi releases page](https://github.com/sxyazi/yazi/releases).

## Usage

Install the plugin. Choose your installation method:

<details>
<summary>Install with `ya pkg`</summary>

The documentation for `ya pkg` is at <https://yazi-rs.github.io/docs/cli/#pm>

```sh
ya pkg add mikavilpas/easyjump.yazi:easyjump
```

---

</details>

<details>
<summary>Install with yazi.nvim</summary>

These instructions assume you are using
<https://github.com/mikavilpas/yazi.nvim/blob/main/documentation/plugin-management.md>.

It's recommended to set `version = "*"` to avoid lots of testing related package
updates that are done automatically.

```lua
return {
  name = "easyjump.yazi",
  url = "https://github.com/mikavilpas/easyjump.yazi",
  version = "*", -- use latest release
  lazy = true,
  build = function(plugin)
    require("yazi.plugin").build_plugin(plugin, { sub_dir = "easyjump.yazi" })
  end,
}
```

---

</details>

## Configuration

Initialize the plugin

```lua
-- ~/.config/yazi/init.lua

-- use the default settings
require("easyjump"):setup()

-- or customize the settings
require("easyjump"):setup({
  icon_fg = "#94e2d5",      -- color for hint labels
  first_key_fg = "#45475a", -- color for first char of double-key hints
})
```

### Custom hint keys

You can customize which keys are used for the jump hints:

```lua
-- ~/.config/yazi/init.lua

require("easyjump"):setup({
  -- example customization - you can choose your own keys
  first_keys = "asdfgercwtvxbq", -- 14 keys
  second_keys = "yuiophjklnm", -- 11 keys
})
```

**How it works:**

- **Single labels** = `first_keys` + `second_keys` (used when ≤25 files visible)
- **Double labels** = `first_keys` × `second_keys` (used when >25 files)

With the default 14 first_keys and 11 second_keys, you get 25 single labels and
154 double labels.

**Important:** `first_keys` and `second_keys` must not share any characters. If
they overlap, an error notification is displayed and the defaults are used
instead.

### Keymap

Set a shortcut key to toggle easyjump mode. For example, set `i`:

```toml
# ~/.config/yazi/keymap.toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run  = "plugin easyjump"
desc = "easyjump"
```

When you see a character (single or double) on the left side of the entry. Press
the key of the character to jump to the corresponding entry.

## Acknowledgements 🙏🏻

Originally developed by DreamMaoMao. The original version is hosted at
<https://gitee.com/DreamMaoMao/easyjump.yazi>. I liked this plugin so much that
I wanted to add tests and maintain it.
