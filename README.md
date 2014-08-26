# cheeky

A cheeky window switcher for Awesome WM

## Description

It popus up a menu with all your clients. As you type,
case-insensitively filters the clients that match with the
name or class.

It's cheeky. If no clients are matched it resets to the complete list
of clients... and it tells you about it.

It was inspired by the oh-so-great:

- https://github.com/seanpringle/xowl
- https://github.com/seanpringle/simpleswitcher

## Installation


Clone this repository into your Awesome configuration directory:

```
  git clone https://github.com/svexican/cheeky ~/.config/awesome
```

## Usage

Include the module on your `rc.lua` file:

```lua
  require("cheeky")
```

and assign a shortcut in your `root.keys` table. For example:

```lua
  modkey = "Mod4"

  root.keys(awful.util.table.join(
    -- lots of your shortcuts

      awful.key({ modkey }, "/", function() cheeky.util.switcher() end),

    -- lots of more shortcuts
  ))
```

#### Setting the coordinates

You can set the coordinates at which you want the menu to appear like so

```lua
awful.key({ modkey }, "/", function()
  cheeky.util.switcher({ coords = { x = 200, y = 200 } })
end),
```

or if you want relative coordinates (per active screen) you can do

```lua
awful.key({ modkey }, "/", function()
  local offset = screen[client.focus.screen].workarea

  cheeky.util.switcher({ coords = { x = offset.x + 200,
                                    y = offset.y + 200 } })
end),
```

Type away!

## TODO

- Reduce the flickering (it's not too bad)
- Allow the user to
  * set a static screen and coordinates for the menu
  * disable the cheeky reset
  * disable the cheeky notification
- ~~Fuzzy matching?~~ (won't do. it's impractical, too many results are generated)
- ~~Select entry by number~~
- ~~Auto select when single match~~ (won't do. it creates a 'human' bug)
