# cheeky

A cheeky window switcher for Awesome WM

## Description

It pops up a menu with all your clients. As you type, it
case-insensitively filters the clients that match with the
name or class. Alternatively, you can scroll through the list 
of clients with Down/Up or Tab/Shift-Tab. Press Enter to switch
to the selected client.

It's cheeky. If no clients match your filter, it resets to the complete list
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
    show_tag = true,             -- display tag at left side of menu (default: false)
    show_screen = true,          -- display screen index at left side of menu (default: false)
    menu_theme = {height = 20, width = 400}, -- theme options for menu (default: nil)
  }
```

Note: for `menu_theme`, the options you can change are listed in the awesomewm API for awful.menu.new:
https://awesomewm.org/doc/api/modules/awful.menu.html
The contents of the `menu_theme` table will only be applied to the cheeky switcher menu, not other menus in awesomewm. If left blank, the cheeky switcher menu will use theme settings defined by your theme.

Type away!

## TODO

- Reduce the flickering (it's not too bad)
