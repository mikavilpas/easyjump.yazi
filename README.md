# easyjump.yazi

A yazi plugin for quickly jumping to the visible files.

A bit like [hop.nvim](https://github.com/smoka7/hop.nvim) in Neovim but for
yazi.

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
<https://github.com/mikavilpas/yazi.nvim/blob/main/documentation/plugin-management.md>

```lua
return {
  name = "easyjump.yazi",
  url = "https://github.com/mikavilpas/easyjump.yazi",
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
  icon_fg = "#94e2d5",
  first_key_fg = "#45475a",
})
```

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
