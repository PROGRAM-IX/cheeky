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
    hide_notification = false,   -- show the cheeky notification if nothing matches (default: true)
    notification_text = "NOPE",  -- contents of cheeky notification (default: "No matches. Resetting")
    notification_timeout = 5     -- time for notifications to remain onscreen (default: 1)
    menu_theme = {height = 20, width = 400}, -- theme options for menu (default: {height = 15, width = 400})
    show_tag = true,             -- display tag at left side of menu (default: true)
    show_screen = true,          -- display screen index at left side of menu (default: false)
    quit_key = '\',              -- close menu if this key is entered (default: '')
  }
```

Note: for menu_theme, the options you can change are:
- height -- of each item
- width  -- of entire menu
- [fg_bg]_[normal|focus] -- control colour of focused/other items, bg = background, fg = text
- border_[color|width] -- control border around whole menu
- submenu_icon -- path to image file
For any colours, like in awesome itself, the value is a hex string like '#ff00ff' or '00ff00'
If left alone these will be set matching your theme.

Type away!

## Further customisations in rc.lua:

```lua
    awful.key({ modkey,           }, "Tab", function () 
                                              mouse.screen = client.focus.screen
                                              -- place the switcher in the centre of the screen with focus
                                              local x_pos = screen[mouse.screen].geometry.width/2-200+screen[mouse.screen].geometry.x
                                              local y_pos = screen[mouse.screen].geometry.height/2-200+screen[mouse.screen].geometry.y
                                              -- move the mouse there as well
                                              mouse.coords({
                                                x = x_pos,
                                                y = y_pos
                                              })
                                              cheeky.util.switcher({
                                                coords = {
                                                  x = x_pos,
                                                  y = y_pos
                                                },
                                                menu_theme = {
                                                  height = 15,
                                                  width = 400
                                                },
                                                show_tag = false,
                                                show_screen = true,
                                                -- space is literal here for some reason
                                                -- but it is easier to hit than Escape
                                                quit_key = ' ', 
                                              }) end),
```

## TODO

- Reduce the flickering (it's not too bad)
