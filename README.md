# cheeky

A cheeky window switcher for Awesome WM

## Description

It pops up a menu with all your clients. As you type, it
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

Include the module in your `rc.lua` file:

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

#### Other options

The full table you can pass to the `switcher` function:

```lua
  {
    coords = { x = 0, y = 0 },   -- position of TL corner of menu (default: the mouse's coordinates)
    hide_notification = true,    -- hide the cheeky notification if nothing matches (default: false)
    notification_text = "NOPE",  -- contents of cheeky notification (default: "No matches. Resetting")
    notification_timeout = 5,    -- time for notifications to remain onscreen (default: 1)
    show_tag = true,             -- display tag at left side of menu (default: true)
    show_screen = true,          -- display screen index at left side of menu (default: false)
  }
```

Type away!

## TODO

- Reduce the flickering (it's not too bad)
