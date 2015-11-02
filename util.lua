local awful   = require("awful")
local wibox   = require("wibox")
local naughty = require("naughty")

local string = string
local client = client
local pairs  = pairs
local table  = table

module("cheeky.util")

local matcher_str = nil
local client_menu = nil

local options = {
  -- coords are handled by Awesome --
  hide_notification     = false,
  notification_text     = "No matches. Resetting.",
  notification_timeout  = 1
}

local function no_case(s)
  s = string.gsub(s, "%a", function (c)
                    return string.format("[%s%s]",
                                         string.lower(c),
                                         string.upper(c)) end)
  return s
end

function match_clients(s)
  local cls = {}

  for i, c in pairs(client.get()) do
    local nc_s = no_case(s)

    if awful.rules.match(c, { name = nc_s })
      or awful.rules.match(c, { class = nc_s })

    then
      table.insert(cls, { c.name, function()
                            client.focus = c
                            c:raise()
                            awful.client.jumpto(c) end,
                          c.icon }) end
  end

  return cls
end

function client_menu_reset()
  if client_menu then client_menu:hide() end

  local client_list = match_clients(matcher_str)

  if #client_list == 0 then
    if not options.hide_notification then
      naughty.notify({ text    = options.notification_text,
                       timeout = options.notification_timeout })
    end

    matcher_str = ""
    client_list = match_clients(matcher_str)
  end

  client_menu = awful.menu(client_list)
  client_menu:item_enter(1)
  client_menu:show(options)

  awful.keygrabber.run(grabber)
end

function grabber(mod, key, event)
  local sel = client_menu.sel or 0

  if event == "release" then return end

  if key == 'Down' then
    local sel_new = (sel + 1) > #client_menu.items and 1 or (sel + 1)
    client_menu:item_enter(sel_new)

  elseif key == 'Up' then
    local sel_new = (sel - 1) < 1 and #client_menu.items or (sel - 1)
    client_menu:item_enter(sel_new)

  elseif string.match(key, "[1-9]") then
    client_menu:exec(key + 0, { exec = true })
    awful.keygrabber.stop(grabber)

  elseif key == '0' then
    client_menu:exec(10, { exec = true })
    awful.keygrabber.stop(grabber)

  elseif sel > 0 and key == 'Return' then
    client_menu:exec(sel, { exec = true })
    awful.keygrabber.stop(grabber)

  elseif key == 'ISO_Level3_Shift'
    or key == 'Shift_L'
    or key == 'Shift_R'
    or key == 'Control_L'
    or key == 'Control_R'
    or key == 'Alt_L'
    or key == 'Super_L'
    or key == 'Super_R' then return

  elseif key == 'Escape' then
    awful.keygrabber.stop(grabber)
    client_menu:hide()

  elseif key == "BackSpace" then
    matcher_str = ""
    client_menu_reset()

  else
    matcher_str = matcher_str .. key
    client_menu_reset()
  end
end

function switcher()
  if opts then
    for k,v in pairs(opts) do options[k] = v end
  end

  awful.keygrabber.stop(grabber)
  matcher_str = ""
  client_menu_reset()
  awful.keygrabber.run(grabber)
end
