local awful   = require("awful")
local wibox   = require("wibox")
local naughty = require("naughty")

local string = string
local client = client
local pairs  = pairs
local table  = table

module("cheeky.util")

local matcher_str = ""
local client_menu = nil

local options = {
  -- coords are handled by Awesome --
  hide_notification     = false,
  notification_text     = "No matches. Resetting.",
  notification_timeout  = 1,
  quit_key              = nil,   -- close menu if this key is entered
}

function no_case(str)
  return string.gsub(str,
                     "%a",
                     function(s)
                       return string.format("[%s%s]",
                                            string.lower(s),
                                            string.upper(s)) end)
end

function draw_menu(list)
  if client_menu then client_menu:hide() end

  client_menu = awful.menu(list)
  client_menu:item_enter(1)
  client_menu:show(options)
end

function match_clients(str)
  local low_str = no_case(str)
  local clients = {}

  for i, c in pairs(client.get()) do
    if awful.rules.match(c, { name = low_str })
      or awful.rules.match(c, { class = low_str })

    then
      table.insert(clients, { c.name, function()
                                client.focus = c
                                c:raise()
                                awful.client.jumpto(c) end,
                              c.icon }) end
  end

  return clients
end

function rerun(str)
  local client_list = match_clients(str)

  if #client_list == 0 then
    if not options.hide_notification then
      naughty.notify({ text    = options.notification_text,
                       timeout = options.notification_timeout })
    end

    close()

    rerun("")

  else
    draw_menu(match_clients(str))
    awful.keygrabber.run(grabber)

  end
end

function append_rerun(key)
  matcher_str = matcher_str .. key

  rerun(matcher_str)
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
    close()

  elseif key == '0' then
    client_menu:exec(10, { exec = true })
    close()

  elseif sel > 0 and key == 'Return' then
    client_menu:exec(sel, { exec = true })
    close()

  elseif key == 'ISO_Level3_Shift'
    or key == 'Shift_L'
    or key == 'Shift_R'
    or key == 'Control_L'
    or key == 'Control_R'
    or key == 'Alt_L'
    or key == 'Super_L'
    or key == 'Super_R' then return

  elseif key == 'Escape' or key == options.quit_key then
    close()

  elseif key == "BackSpace" then
    rerun("")

  else
    append_rerun(key)

  end
end

function close()
  awful.keygrabber.stop(grabber)
  client_menu:hide()

  matcher_str = ""
end

function switcher(opts)
  if client.instances() < 1 then
    naughty.notify({ text    = "No clients. Exiting.",
                     timeout = options.notification_timeout })
    return false
  end

  if opts then
    for k,v in pairs(opts) do options[k] = v end
  end

  awful.keygrabber.stop(grabber)

  draw_menu(match_clients(""))

  awful.keygrabber.run(grabber)
end
