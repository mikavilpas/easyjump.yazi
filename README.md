# keyjump.yazi

A Yazi plugin which like flash.nvim in Neovim, allow use key char to precise selection.

> [!NOTE]
> The latest main branch of Yazi is required at the moment.

## Global mode

Global mode, you can jump to everywhere.not only current window.
you also can use "Space" key to select/unselect item

https://github.com/DreamMaoMao/keyjump.yazi/assets/30348075/0a7a44cd-a91b-4377-9787-f4babb0303bf


## Keep mode

keep mode, when select a dir, it will auto enter and keep in "keyjump" mode.

https://github.com/DreamMaoMao/keyjump.yazi/assets/30348075/dd998a34-49b0-481d-b032-d9849a89ba48

## Normal mode

Normal mode, when select a item, it will auto leave keyjump mode

https://github.com/DreamMaoMao/keyjump/assets/30348075/6ba722ce-8b55-4c80-ac81-b6b7ade74491

## Select mode

Select mode, you can use "Space" key to select/unselect item

https://github.com/DreamMaoMao/keyjump.yazi/assets/30348075/84faf1b5-7466-49d5-9598-fe9ef9098acc

## special key
"Esc"  : exit keyjump (global,select,keep,normal)
"Enter" : open (global,select,keep,normal)
"Space" : toggle select (global,select,keep)
"Left" : leave to parent folder (global,select,keep,normal)
"Right" : enter folder (global,select,keep,normal)
"Up" : arrow up 1 entry (global,select,keep,normal)
"Down" : arrow down 1 entry (global,select,keep,normal)

"h" : leave to parent folder (global)
"l" : enter folder (global)
"k" : arrow up 1 entry (global)
"j" : arrow down 1 entry (global)



## Install

### Linux

```bash
git clone https://github.com/DreamMaoMao/keyjump.yazi.git ~/.config/yazi/plugins/keyjump.yazi
```

### Windows

With `Powershell` :

```powershell
if (!(Test-Path $env:APPDATA\yazi\config\plugins\)) {mkdir $env:APPDATA\yazi\config\plugins\}
git clone https://github.com/DreamMaoMao/keyjump.yazi.git $env:APPDATA\yazi\config\plugins\keyjump.yazi
```

## Usage

set shortcut key to toggle keyjump mode in `~/.config/yazi/keymap.toml`. for example set `i` to toggle keyjump mode

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run = "plugin keyjump --sync --args=keep"
desc = "Keyjump (Keep mode)"
```

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run = "plugin keyjump --sync"
desc = "Keyjump (Normal mode)"
```

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run = "plugin keyjump --sync --args=select"
desc = "Keyjump (Select mode)"
```

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run = "plugin keyjump --sync --args=global"
desc = "Keyjump (Global mode)"
```

When you see some character(singal character or double character) in left of the entry.
Press the key of the character will jump to the corresponding entry
