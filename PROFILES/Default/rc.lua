--Configure home path so you dont have too
home_path  = os.getenv('HOME') .. '/'

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
beautiful.init( awful.util.getdir("config") .. "/themes/default/theme.lua" )

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
--FreeDesktop
require('freedesktop.utils')
require('freedesktop.menu')
freedesktop.utils.icon_theme = 'gnome'
--Vicious + Widgets 
vicious = require("vicious")
local wi = require("wi")

-- Launchers
home 			= os.getenv("HOME")
confdir 		= home .. "/.config/awesome"
themes 			= confdir .. "/themes"
active_theme 	= themes .. "/default"
launcher_dir = active_theme .. "/icons/launchers/"

msjche_launcher= awful.widget.launcher({ image =  launcher_dir .. "tux.png", command = home .. "/Scripts/Theming/msjche.sh" })

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

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
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

-- {{{ Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "terminus 12"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 256
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil
-- -- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
 names  = { 
         '☭:Web',
         '⚡:Pacman', 
         '♨:News', 
         '☠:IRC',  
         '☃:Music', 
         '⌥:Arrrg', 
         '⌘:Multimedia',
         '✇:Gaming',
         '✣:Facepalm',
           },
 layout = {
      layouts[10],	-- 1:2eb
      layouts[2],  	-- 2:pacman
      layouts[8],	-- 3:news
      layouts[10],	-- 4:IRC
      layouts[4],	-- 5:music
      layouts[5],	-- 6:arrrg
      layouts[10],	-- 7:multimedia
      layouts[1],	-- 8:game
      layouts[1],	-- 9:facepalm
          }
       }
  for s = 1, screen.count() do
 -- Each screen has its own tag table.
 tags[s] = awful.tag(tags.names, s, tags.layout)
 end
-- }}}

-- Wallpaper Changer Based On 
-- menu icon menu pdq 07-02-2012
 local wallmenu = {}
 local function wall_load(wall)
 local f = io.popen('ln -sfn ' .. home_path .. '.config/awesome/wallpaper/' .. wall .. ' ' .. home_path .. '.config/awesome/themes/default/background.jpg')
 awesome.restart()
 end
 local function wall_menu()
 local f = io.popen('ls -1 ' .. home_path .. '.config/awesome/wallpaper/')
 for l in f:lines() do
local item = { l, function () wall_load(l) end }
 table.insert(wallmenu, item)
 end
 f:close()
 end
 wall_menu()

-- Widgets 

spacer       = wibox.widget.textbox()
spacer:set_text(' | ')

--Weather Widget
weather = wibox.widget.textbox()
vicious.register(weather, vicious.widgets.weather, "Weather: Sky: ${sky} - Temp: ${tempf}F - Humid: ${humid}% - Wind: ${windmph} mph", 1200, "KCCR")

--Battery Widget
batt = wibox.widget.textbox()
vicious.register(batt, vicious.widgets.bat, "Batt: $2% Rem: $3", 61, "BAT1")


-- {{{ Menu
-- Create a laucher widget and a main menu

--menu_items = freedesktop.menu.new()
--myawesomemenu = {
--   { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
--   { "edit config", editor_cmd .. " " .. awesome.conffile, freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
--   { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) },
--   { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) }
--       }
--
--        table.insert(menu_items, { "Awesome", myawesomemenu, beautiful.awesome_icon })
--        table.insert(menu_items, { "Wallpaper", wallmenu, freedesktop.utils.lookup_icon({ icon = 'gnome-settings-background' })}) 
--
--        mymainmenu = awful.menu({ items = menu_items, width = 150 })
--
--mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
myinfowibox = {}
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

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 30 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
--    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spacer)
    right_layout:add(mailicon)
    right_layout:add(mailwidget)
    right_layout:add(spacer)
    right_layout:add(baticon)
    right_layout:add(batpct)
    right_layout:add(spacer)
    right_layout:add(pacicon)
    right_layout:add(pacwidget)
    right_layout:add(spacer)
    right_layout:add(volicon)
    right_layout:add(volpct)
    right_layout:add(volspace)
    right_layout:add(spacer)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

   	mywibox[s]:set_widget(layout)
   
   -- Create the bottom wibox
     myinfowibox[s] = awful.wibox({ position = "bottom", screen = s, height = 30 })
   -- Widgets that are aligned to the bottom
    local bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(cpuicon)
    bottom_left_layout:add(cpu)
    bottom_left_layout:add(spacer)
    bottom_left_layout:add(memicon)
    bottom_left_layout:add(mem)
    bottom_left_layout:add(spacer)
    bottom_left_layout:add(wifiicon)
    bottom_left_layout:add(netdownicon)
    bottom_left_layout:add(netdown)
    bottom_left_layout:add(netup)
    bottom_left_layout:add(netupicon)
    bottom_left_layout:add(spacer)
    bottom_left_layout:add(wifi)
    bottom_left_layout:add(vpnwidget)
    bottom_left_layout:add(spacer)
    bottom_left_layout:add(weather)
    bottom_left_layout:add(spacer)
	
	-- Widgets that are aligned to the right
    local bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(pianobaricon)
    bottom_right_layout:add(pianobarwidget)
    bottom_right_layout:add(mpdicon)
    bottom_right_layout:add(mpdwidget)
    bottom_right_layout:add(spacer)
    bottom_right_layout:add(uptimeicon)
    bottom_right_layout:add(uptimewidget)
    bottom_right_layout:add(spacer)
    bottom_right_layout:add(msjche_launcher)
    
 	-- Now bring it all together 
    local bottom_layout = wibox.layout.align.horizontal()
	bottom_layout:set_right(bottom_right_layout)
    bottom_layout:set_left(bottom_left_layout)

    myinfowibox[s]:set_widget(bottom_layout)

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
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

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
    awful.key({ }, "Print", function () awful.util.spawn("upload_screens scr") end),

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


-- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end),
 	
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
--    awful.key({  }, "F4", function ()
  	awful.key({ modkey, "Control" }, "Left", function ()
    awful.util.spawn("mpc prev", false) end),
	
--Pianobar
       awful.key({ altkey }, "p", function () awful.util.spawn_with_shell( "urxvt -e ~/.config/pianobar/pianobar_headless.sh") end),
       awful.key({ }, "XF86AudioPlay", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/toggle.sh") end),
       awful.key({ }, "XF86AudioNext", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/next.sh") end),
       awful.key({ altkey }, "=", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/love.sh") end),
       awful.key({ altkey }, "-", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/ban.sh") end),
       awful.key({ altkey }, "i", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/status.sh") end),
--       awful.key({ altkey }, "x", function () awful.util.spawn_with_shell( "~/.config/pianobar/pianobar-scripts/stop.sh") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

	awful.key({ modkey, "Shift" }, "Delete", function() awful.util.spawn("oblogout") end),
	awful.key({ modkey }, "Escape", function() awful.util.spawn("poweroff") end),
	awful.key({ altkey }, "m", function () awful.util.spawn_with_shell( "urxvt -e htop -s PERCENT_MEM") end),
	awful.key({ altkey }, "s", function () awful.util.spawn_with_shell( "urxvt -e glances") end),
	awful.key({ modkey }, "b", function () awful.util.spawn( "luakit") end),
	awful.key({ modkey }, "o", function () awful.util.spawn( "opera") end),
	awful.key({ modkey, "Shift" }, "b", function () awful.util.spawn( "firefox-developer") end),
	awful.key({ modkey }, "w", function () awful.util.spawn( "nmcli_dmenu") end),
	awful.key({ modkey }, "v", function () awful.util.spawn( "kodi") end),
	awful.key({ modkey }, "t", function () awful.util.spawn( "turpial") end),
	awful.key({ modkey }, "o", function () awful.util.spawn( "opera") end),
	awful.key({ modkey }, "c", function () awful.util.spawn( "chromium") end),
	awful.key({ modkey }, "p", function () awful.util.spawn( "pavucontrol") end),
	awful.key({ modkey }, "s", function () awful.util.spawn( "steam") end),
	awful.key({ modkey }, "T", function () awful.util.spawn( "tor-browser-en") end),
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
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
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
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Vlc" },
      properties = { tag = tags[1][6] } },
    { rule = { class = "VirtualBox" },
      properties = { tag = tags[1][9] } },
    { rule = { class = "Gns3" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "luakit" },
      properties = { tag = tags[1][1] } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
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
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
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
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

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
autostart("nm-applet", 5)
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
