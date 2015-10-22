-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious	= require("vicious")
-- Lain
local lain = require("lain")
-- freedesktop.org
local freedesktop = require('freedesktop')
-- Widget files
local wi = require("wi")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

home 			= os.getenv("HOME")
confdir 		= home .. "/.config/awesome"
themes 			= confdir .. "/themes"
active_theme 	= themes .. "/msjche"
language 		= string.gsub(os.getenv("LANG"), ".utf8", "")

beautiful.init(active_theme .. "/theme.lua")

terminal 	= "urxvt"
editor 		= os.getenv("EDITOR") or "vim"
editor_cmd 	= terminal .. " -e " .. editor
browser 	= "luakit"
mail 		= terminal .. " -e mutt "
musicplr 	= terminal .. " -g l30x34-320+16 -e ncmpcpp "

-- Default modkeys.

modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags

tags = 	{
	names = { "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒" },
	layout = { layouts[10], layouts[2], layouts[2], layouts[10], layouts[4], layouts[5], layouts[10], layouts[1], layouts [1] }
		}
for s = 1, screen.count() do
	tags[s] = awful.tag(tags.names, s, tags.layout)
end

-- }}}

-- {{{ Menu
require("freedesktop/freedesktop")

mymainmenu = awful.menu.new({ items = require("menugen").build_menu(),
                              theme = { height = 25, width = 250 }})
							  mylauncher = awful.widget.launcher({ image = active_theme .. "/icons/" .. "awesome_icon.png" ,
							                                       menu = mymainmenu })
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

markup      = lain.util.markup
darkblue    = theme.bg_focus
white       = beautiful.fg_focus
blue        = "#1793D0"
red         = "#EB8F8F"
gray        = "#858585"

local util = awful.util

-- Textclock
mytextclock = awful.widget.textclock(markup(gray, " %a")
.. markup(blue, " %d ") .. markup(gray, "%b ") ..  markup(blue, "%H:%M "))

-- Calendar
lain.widgets.calendar:attach(mytextclock, { fg = gray })

----------------------------------------------------------------------------------------
-- Spacers

space = wibox.widget.textbox(' ')
bigspace = wibox.widget.textbox('   ')
separator = wibox.widget.textbox(' ⁞ ')

----------------------------------------------------------------------------------------

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
myverticalwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
 
 -- Create the vertical wibox
    myverticalwibox[s] = awful.wibox({ position = "left", screen = s, width = 35 })

    -- Widgets that are aligned to the bottom left
    top_left_layout = wibox.layout.fixed.vertical()
    top_left_layout:add(mylauncher)
    top_left_layout:add(gimp_launcher)
    top_left_layout:add(filezilla_launcher)
    top_left_layout:add(libreoffice_launcher)
    top_left_layout:add(thunderbird_launcher)
    top_left_layout:add(steam_launcher)
    top_left_layout:add(torbrowser_launcher)
    top_left_layout:add(chrome_launcher)
    top_left_layout:add(firefox_launcher)
    top_left_layout:add(SSR_launcher)
    top_left_layout:add(telegram_launcher)
    top_left_layout:add(space)
 
	-- Now bring it all together (with the tasklist in the middle)
    top_layout= wibox.layout.align.vertical()
    top_layout:set_top(top_left_layout)
    myverticalwibox[s]:set_widget(top_layout)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 27 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(space)
    left_layout:add(mypromptbox[s])
	left_layout:add(separator)
    left_layout:add(pianobaricon)
    left_layout:add(space)
    left_layout:add(pianobarwidget)
    left_layout:add(separator)
    left_layout:add(mpdicon)
    left_layout:add(space)
    left_layout:add(mpdwidget)
    left_layout:add(space)
	left_layout:add(separator)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(separator)
    right_layout:add(pacicon)
    right_layout:add(pacwidget)
    right_layout:add(separator)
    right_layout:add(mailicon)
    right_layout:add(separator)
    right_layout:add(memicon)
    right_layout:add(space)
    right_layout:add(memwidget)
    right_layout:add(separator)
    right_layout:add(fshome)
    right_layout:add(separator)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(separator)
    right_layout:add(space)
    right_layout:add(wifiicon)
    right_layout:add(vpnwidget)
    right_layout:add(space)
    right_layout:add(separator)
    right_layout:add(space)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(space)
    right_layout:add(separator)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    -- Create the bottom wibox
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, height = 28 })

    -- Widgets that are aligned to the bottom left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(cpuicon)
    bottom_left_layout:add(cpugraph1)
    bottom_left_layout:add(space)
    bottom_left_layout:add(cpugraph1)
    bottom_left_layout:add(space)
    bottom_left_layout:add(cpugraph2)
    bottom_left_layout:add(space)
    bottom_left_layout:add(cpugraph3)
    bottom_left_layout:add(space)
    bottom_left_layout:add(cpugraph4)
    bottom_left_layout:add(space)
    bottom_left_layout:add(cpugraph5)
    bottom_left_layout:add(space)
    bottom_left_layout:add(cpugraph7)
    bottom_left_layout:add(space)
    bottom_left_layout:add(cpugraph8)
    bottom_left_layout:add(cpuicon)

    -- Widgets that are aligned to the bottom right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(net_down)
    bottom_right_layout:add(wifidown)
    bottom_right_layout:add(wifiwidget)
    bottom_right_layout:add(wifiup)
    bottom_right_layout:add(net_up)
    bottom_right_layout:add(separator)
    bottom_right_layout:add(uptimeicon)
    bottom_right_layout:add(space)
    bottom_right_layout:add(uptimewidget)
    bottom_right_layout:add(separator)
    bottom_right_layout:add(hud_launcher)
    bottom_right_layout:add(up_launcher)
    bottom_right_layout:add(kill_launcher)
    bottom_right_layout:add(separator)

    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
	bottom_layout:set_middle(mytasklist[s])
	bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)
 
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           	}, "Left",   	awful.tag.viewprev       ),
    awful.key({ modkey, "Control"	}, "h",   		awful.tag.viewprev       ),
    awful.key({ modkey,           	}, "Right",  	awful.tag.viewnext       ),
    awful.key({ modkey, "Control"	}, "l",  		awful.tag.viewnext       ),
    awful.key({ modkey,           	}, "Escape", 	awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "q", function () mymainmenu:show() end),

-- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end),

-- Custome key bindings
  	awful.key({ }, "XF86MonBrightnessUp", function ()
	awful.util.spawn("xbacklight -inc 2") end),
	awful.key({ }, "XF86MonBrightnessDown", function ()
	awful.util.spawn("xbacklight -dec 2") end),
	awful.key({ }, "XF86AudioRaiseVolume", function ()
	awful.util.spawn("amixer set Master 5%+", false) end),
	awful.key({ }, "XF86AudioLowerVolume", function ()
	awful.util.spawn("amixer set Master 5%-", false) end),
	awful.key({ }, "XF86AudioMute", function ()
	awful.util.spawn("amixer set Master toggle", false) end),

--    awful.key({  }, "F5", function ()
  awful.key({ modkey, "Control" }, "Up", function ()
    awful.util.spawn("mpc toggle", false) end),
--    awful.key({  }, "F6", function ()
  awful.key({ modkey, "Control" }, "Right", function ()
    awful.util.spawn("mpc next", false) end),
  awful.key({ modkey, "Control" }, "Left", function ()
--    awful.key({  }, "F4", function ()
    awful.util.spawn("mpc prev", false) end),
	
--Pianobar
       awful.key({ altkey }, "p", function () awful.util.spawn_with_shell( "urxvt -e ~/.config/pianobar/pianobar_headless.sh") end),
       awful.key({ }, "XF86AudioPlay", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/toggle.sh") end),
       awful.key({ }, "XF86AudioNext", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/next.sh") end),
       awful.key({ altkey }, "=", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/love.sh") end),
       awful.key({ altkey }, "-", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/ban.sh") end),
       awful.key({ altkey }, "i", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/status.sh") end),
--       awful.key({ altkey }, "x", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/stop.sh") end),
	
-- Conky keybindings
    awful.key({}, "F12", function() raise_conky() end, function() lower_conky() end),
    awful.key({}, "F10", function() toggle_conky() end),

-- Widgets popups
    awful.key({ altkey,           }, "q",      function () lain.widgets.calendar:show(7) end),
    awful.key({ altkey,           }, "h",      function () fshome.show(7) end),
    awful.key({ altkey,           }, "w",      function () yawn.show(7) end),
    awful.key({ altkey,           }, "b",      function () awful.util.table:popup_bat(7) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

-- User programs

	awful.key({ modkey, "Shift" }, "Delete", function() awful.util.spawn("oblogout") end),
	awful.key({ modkey }, "Escape", function() awful.util.spawn("poweroff") end),
	awful.key({ altkey }, "m", function () awful.util.spawn_with_shell( "urxvt -e htop -s PERCENT_MEM") end),
	awful.key({ altkey }, "s", function () awful.util.spawn_with_shell( "urxvt -e glances") end),
	awful.key({ modkey }, "b", function () awful.util.spawn( "luakit") end),
	awful.key({ modkey }, "o", function () awful.util.spawn( "opera") end),
	awful.key({ modkey, "Shift" }, "b", function () awful.util.spawn( "firefox-developer") end),
	awful.key({ modkey }, "w", function () awful.util.spawn( "nmcli_dmenu") end),
	awful.key({ modkey }, "v", function () awful.util.spawn( "kodi") end),
	awful.key({ modkey }, "T", function () awful.util.spawn( "turpial") end),
	awful.key({ modkey }, "o", function () awful.util.spawn( "opera") end),
	awful.key({ modkey }, "c", function () awful.util.spawn( "chromium") end),
	awful.key({ modkey }, "i", function () awful.util.spawn( "chromium -incognito") end),
	awful.key({ modkey }, "p", function () awful.util.spawn( "pavucontrol") end),
	awful.key({ modkey }, "s", function () awful.util.spawn( "steam") end),
	awful.key({ modkey }, "t", function () awful.util.spawn( "tor-browser-en") end),
	awful.key({ modkey }, "e", function () awful.util.spawn( "thunar") end),
	awful.key({ modkey }, "g", function () awful.util.spawn( "gvim") end),
	awful.key({ altkey }, "z", function () awful.util.spawn( "pkill youtube-viewer") end),
	awful.key({ altkey }, "x", function () awful.util.spawn( "pkill mpv") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "a", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",

    -- Move Windows with keyboard
   awful.key({ modkey, "Shift"   }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
   awful.key({ modkey, "Shift"   }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
   awful.key({ modkey, "Shift"   }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
   awful.key({ modkey, "Shift"   }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
   awful.key({ modkey, "Shift"   }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
   awful.key({ modkey, "Shift"   }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),

        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "e",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "Conky" },
       properties = {
      floating = true,
      sticky = true,
      ontop = false,
      focusable = false,
      size_hints = {"program_position", "program_size"}
  	} }
}

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
--            awful.placement.under_mouse(c)
--            awful.placement.centered(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Run autostarting applications only once
function autostart(cmd, delay)
    delay = delay or 0
    awful.util.spawn_with_shell("pgrep -u $USER -x -f '" .. cmd .. "' || ( sleep " .. delay .. " && " .. cmd .. " )")
end

-- Autostart applications. The extra argument is optional, it means how long to
-- delay a command before starting it (in seconds).
autostart("pkill conky", 1)
--autostart("urxvtd -q -f -o", 1)
autostart("mpd", 1)
autostart("xscreensaver -no-splash", 1)
autostart("xflux -z 94596", 1)
--autostart("pkill nm-applet", 1)
--autostart("nm-applet", 5)
autostart("udiskie -2", 1)
autostart("compton -b", 1)
--autostart("hp-systray", 1)
--autostart("dropbox", 1)
--autostart("insync start", 1)
--autostart("megasync", 1)
autostart("~/Scripts/Theming/1440.sh", 1)
--autostart("~/Scripts/start_HUD.sh", 3)
autostart("~/Scripts/blanking.sh", 3)

-- }}}

-- {{{ Run .desktop files with dex
-- Because 'dex' is not an application, autostart("dex -ae Awesome") will always
-- execute every entry (which is unwanted).
local dex_output = io.popen("dex -ade Awesome")
for cmd in dex_output:lines() do
    autostart(cmd:gsub("Executing command: ", ""), 4)
end
dex_output:close()
-- }}}
