
## Install

### Linux

```bash
git clone https://gitee.com/DreamMaoMao/easyjump.yazi.git ~/.config/yazi/plugins/easyjump.yazi
```

### Windows

With `Powershell` :

```powershell
if (!(Test-Path $env:APPDATA\yazi\config\plugins\)) {mkdir $env:APPDATA\yazi\config\plugins\}
git clone https://gitee.com/DreamMaoMao/easyjump.yazi.git $env:APPDATA\yazi\config\plugins\easyjump.yazi
```

## Usage

set shortcut key to toggle easyjump mode in `~/.config/yazi/keymap.toml`. for example set `i` to toggle easyjump mode

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run = "plugin easyjump"
desc = "easyjump"
```

When you see some character(singal character or double character) in left of the entry.
Press the key of the character will jump to the corresponding entry
