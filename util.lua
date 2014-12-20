local awful   = require("awful")
local wibox   = require("wibox")
local naughty = require("naughty")

local string = string
local client = client
local pairs  = pairs
local table  = table

module("cheeky.util")

local matcher_str = nil
local cmenu       = nil

local options = nil

local function nocase(s)
  s = string.gsub(s, "%a", function (c)
                    return string.format("[%s%s]",
                                         string.lower(c),
                                         string.upper(c)) end)
  return s
end

function match_clients(s)
  local cls = {}

  for i, c in pairs(client.get()) do
    local nocase_s = nocase(s)

    if awful.rules.match(c, { name = nocase_s })
      or awful.rules.match(c, { class = nocase_s })
    then
      table.insert(cls, { c.name, function()
                            client.focus = c
                            c:raise()
                            awful.client.jumpto(c) end,
                          c.icon }) end
  end

  return cls
end

function cmenureset()
  if cmenu then cmenu:hide() end

  local clist = match_clients(matcher_str)

  if #clist == 0 then
    if not options.hide_notification then
      local text    = options.notification_text or "No matches. Resetting."
      local timeout = options.notification_timeout or 1

      naughty.notify({ text = text, timeout = timeout })
    end

    matcher_str = ""
    clist = match_clients(matcher_str)
  end

  cmenu = awful.menu(clist)
  cmenu:item_enter(1)
  cmenu:show(options)

  awful.keygrabber.run(grabber)
end

function grabber(mod, key, event)
  local sel = cmenu.sel or 0

  if event == "release" then return end

  if key == 'Down' then
    local sel_new = (sel + 1) > #cmenu.items and 1 or (sel + 1)
    cmenu:item_enter(sel_new)

  elseif key == 'Up' then
    local sel_new = (sel - 1) < 1 and #cmenu.items or (sel - 1)
    cmenu:item_enter(sel_new)

  elseif key == '1' or
    key == '2' or
    key == '3' or
    key == '4' or
    key == '5' or
    key == '6' or
    key == '7' or
    key == '8' or
    key == '9'
  then
    cmenu:exec(key + 0, { exec = true })
    awful.keygrabber.stop(grabber)

  elseif key == '0' then
    cmenu:exec(10, { exec = true })
    awful.keygrabber.stop(grabber)

  elseif sel > 0 and key == 'Return' then
    cmenu:exec(sel, { exec = true })
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
    cmenu:hide()

  elseif key == "BackSpace" then
    matcher_str = ""
    cmenureset()

  else
    matcher_str = matcher_str .. key
    cmenureset()
  end
end

function switcher(opts)
  options = opts
  awful.keygrabber.stop(grabber)
  matcher_str = ""
  cmenureset()
  awful.keygrabber.run(grabber)
end
