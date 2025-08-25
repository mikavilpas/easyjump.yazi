# easyjump.yazi

A yazi plugin for quickly jumping to the visible files.

A bit like [hop.nvim](https://github.com/smoka7/hop.nvim) in Neovim but for
yazi.

## Usage

Set a shortcut key to toggle easyjump mode in `~/.config/yazi/keymap.toml`. For
example, set `i`:

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run = "plugin easyjump"
desc = "easyjump"
```

When you see a character (single or double) on the left side of the entry. Press
the key of the character to jump to the corresponding entry.

## Acknowledgements 🙏🏻

Originally developed by DreamMaoMao. The original version is hosted at
<https://gitee.com/DreamMaoMao/easyjump.yazi>. I liked this plugin so much that
I wanted to add tests and maintain it.
