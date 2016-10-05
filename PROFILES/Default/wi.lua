local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")
local lain = require("lain")

-- Spacers
volspace = wibox.widget.textbox()
volspace:set_text(" ")

-- {{{ BATTERY
-- Battery attributes
local bat_state  = ""
local bat_charge = 0
local bat_time   = 0
local blink      = true

-- Icon
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batfull)

-----------------------------------
-- Pianobar

pianobaricon = wibox.widget.imagebox(beautiful.widget_pianobar)
pianobaricon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell("urxvt -e ~/.config/pianobar/pianobar_headless.sh") end)))

pianobarwidth    = 100

pianobarwidget = wibox.widget.textbox()
vicious.register(pianobarwidget, vicious.widgets.mpd,
  function(widget, args)
	pianobaricon:set_image(beautiful.widget_pianobar)
	local f = io.popen("pgrep pianobar")

--	if f:read("*line") then
--      f = io.open(os.getenv("HOME") .. "/.config/pianobar/isplaying")
--      play_or_pause = f:read("*line")
--      f:close()

      f = io.open(os.getenv("HOME") .. "/.config/pianobar/isplaying")
      play_or_pause = f:read("*line")
      f:close()

      -- Current song
      f = io.open(os.getenv("HOME") .. "/.config/pianobar/artist")
      band = f:read("*line"):match("(.*)")
      f:close()

      f = io.open(os.getenv("HOME") .. "/.config/pianobar/title")
      song = f:read("*line"):match("(.*)")
      f:close()
 	  
	  f = io.open(os.getenv("HOME") .. "/.config/pianobar/nowplaying")
      text = f:read("*line"):match("(.*)")
      f:close()
      -- Paused
    if play_or_pause == "0" then
        pianobaricon:set_image(beautiful.widget_pianobar_pause)
--		return markup(gray, band)
		return ""
    elseif play_or_pause == "1" then
        pianobaricon:set_image(beautiful.widget_pianobar_play)
        pianobarwidget.width = 0
		return " " .. band .. " - " .. song
    else
      	-- Stopped
      	pianobarwidget.width = 0
      	pianobaricon:set_image(beautiful.widget_pianobar_stopped)
      	info = "..."
	  	band = ""
	  	song = ""
    end

--	return markup(blue, band) .. markup(gray, " ┈ ") .. markup(green, song)

  end, 3)

----------------------------------------------------------------------------------------
-- MPD

mpdicon = wibox.widget.imagebox(beautiful.widget_mpd)
mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
-- Initialize widget
mpdwidget = wibox.widget.textbox()
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (mpdwidget, args)
        if args["{state}"] == "Pause" then 
            return ""
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 1)

----------------------------------------------------------------------------------------
-- Battery

baticon = wibox.widget.imagebox()
batwidget = lain.widgets.bat({

settings = function(widget, args)

batwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
baticon:buttons(batwidget:buttons())

	local bat_state  	= ""
	local bat_charge 	= 0
	local bat_time  	= 0
	local blink      	= true
	local timeout		= 1

	bat_70	= tostring (75)
	bat_40	= tostring (35)
	bat_10	= tostring (15)

	bat_perc = bat_now.perc
	bat_p = tostring (bat_perc) 
	bat_s = bat_now.status
	bat_t = bat_now.time
        
    if bat_s == "Full" then
		baticon:set_image(beautiful.widget_ac)
	elseif bat_s == "Discharging" then
			baticon:set_image(beautiful.widget_batfull)
			batwidget:set_text(" - ")
		if bat_perc >= bat_70 then
			baticon:set_image(beautiful.widget_batfull)
			batwidget:set_text(" - ")
		elseif bat_perc >= bat_40 then
			baticon:set_image(beautiful.widget_batmed)
			batwidget:set_text(" - ")
		elseif bat_perc > bat_10 then
			baticon:set_image(beautiful.widget_batlow)
			batwidget:set_text(" - ")
		elseif bat_perc > bat_10 then
		else
			baticon:set_image(beautiful.widget_batempty)
			batwidget:set_text(" ( - ) plug in now ")
		end
	else
		if 	bat_perc >= bat_70 then
			baticon:set_image(beautiful.widget_batfull)
			batwidget:set_text(" + ")
		elseif bat_perc >= bat_40 then
			baticon:set_image(beautiful.widget_batmed)
			batwidget:set_text(" + ")
		elseif bat_perc >= bat_10 then
			baticon:set_image(beautiful.widget_batlow)
			batwidget:set_text(" + ")
		else
			baticon:set_image(beautiful.widget_batempty)
			batwidget:set_text(" + ")
		end
	end
end, 1, "BAT1"
})

-- Buttons
function popup_bat()
  local state = ""
  local popup_bat_preset = { font = "Insonsolata 15" }
  if bat_state == "↯" then
    state = "Full"
  elseif bat_state == "↯" then
    state = "Charged"
  elseif bat_state == "+" then
    state = "Charging"
  elseif bat_state == "−" then
    state = "Discharging"
  elseif bat_state == "⌁" then
    state = "Not charging"
  else
    state = "Unknown"
  end

  naughty.notify { text = "Charge : " .. bat_p .. "%\nState  : " .. bat_s ..
    " (" .. bat_t .. ")", timeout = 5, hover_timeout = 0.5 }
end

-- Battery Warning
local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end

local function bat_notification()
  local f_capacity = assert(io.open("/sys/class/power_supply/BAT1/capacity", "r"))
  local f_status = assert(io.open("/sys/class/power_supply/BAT1/status", "r"))
  local bat_capacity = tonumber(f_capacity:read("*all"))
  local bat_status = trim(f_status:read("*all"))
  local bat_status_preset = { font = "Insonsolata 15" }

  if (bat_capacity <= 15 and bat_status == "Discharging") then
    naughty.notify({ title      = "Battery Warning"
      , text       = "Battery low! " .. bat_capacity .."%" .. " left!"
      , fg="#ffffff"
      , bg="#C91C1C"
      , timeout    = 10
      , position   = "top_right"
    })
  end
end

battimer = timer({timeout = 15})
battimer:connect_signal("timeout", bat_notification)
battimer:start()

----------------------------------------------------------------------------------------

-- {{{ PACMAN
-- Icon
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)
--
-- Upgrades
pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg, function(widget, args)
   if args[1] > 0 then
   pacicon:set_image(beautiful.widget_pacnew)
   else
   pacicon:set_image(beautiful.widget_pac)
   end

  return args[1]
  end, 240, "Arch S") -- Arch S for ignorepkg
--
-- Buttons
  function popup_pac()
  local pac_updates = ""
  local f = io.popen("pacman -Sup --dbpath /tmp/pacsync")
  if f then
  pac_updates = f:read("*a"):match(".*/(.*)-.*\n$")
  end
  f:close()
  if not pac_updates then
  pac_updates = "System is up to date"
  end
  naughty.notify { text = pac_updates }
  end
  pacwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_pac)))
  pacicon:buttons(pacwidget:buttons())
-- End Pacman }}}
--
-- {{{ VOLUME
-- Cache
vicious.cache(vicious.widgets.volume)
--
-- Icon
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
--
-- Volume %
volpct = wibox.widget.textbox()
vicious.register(volpct, vicious.widgets.volume, "$1%", nil, "Master")
--
-- Buttons
volicon:buttons(awful.util.table.join(
     awful.button({ }, 1,
     function() awful.util.spawn_with_shell("amixer -q set Master toggle") end),
     awful.button({ }, 4,
     function() awful.util.spawn_with_shell("amixer -q set Master 3+% unmute") end),
     awful.button({ }, 5,
     function() awful.util.spawn_with_shell("amixer -q set Master 3-% unmute") end)
            ))
     volpct:buttons(volicon:buttons())
     volspace:buttons(volicon:buttons())
 -- End Volume }}}
 --
-- {{{ Start CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
--
cpu = wibox.widget.textbox()
vicious.register(cpu, vicious.widgets.cpu, "All: $1% - 1:$2% - 2:$3% - 3:$4% - 4:$5% - 5:$6% - 6:$7%  7:$8% - 8:$9%", 2)
-- End CPU }}}

-- {{{ Start Mem
fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)

fs = wibox.widget.textbox()
vicious.register(fs, vicious.widgets.fs, " / ${/ used_p}% - /usr ${/usr used_p}% - /home ${/home used_p}%", 2)
-- End Mem }}}

-- {{{ Start Mem
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_ram)

mem = wibox.widget.textbox()
vicious.register(mem, vicious.widgets.mem, "Mem: $1% - $2MB", 2)
-- End Mem }}}

-- {{{ Start Gmail 
mailicon = wibox.widget.imagebox(beautiful.widget_mail)
mailwidget = wibox.widget.textbox()
gmail_t = awful.tooltip({ objects = { mailwidget },})
vicious.register(mailwidget, vicious.widgets.gmail,
        function (widget, args)
        gmail_t:set_text(args["{subject}"])
        gmail_t:add_to_object(mailicon)
            return args["{count}"]
                 end, 120) 

     mailicon:buttons(awful.util.table.join(
         awful.button({ }, 1, function () awful.util.spawn("urxvt -e mutt", false) end)
     ))
-- End Gmail }}}

-- Network 

vicious.cache(vicious.widgets.net)

netupicon= wibox.widget.imagebox(beautiful.widget_up)
netup= wibox.widget.textbox()
vicious.register(netup, vicious.widgets.net, "${wlp6s0 up_kb}", 3)

netdownicon= wibox.widget.imagebox(beautiful.widget_down)
netdown= wibox.widget.textbox()
vicious.register(netdown, vicious.widgets.net, "${wlp6s0 down_kb} - ", 3)

-- Wifi
wifiicon = wibox.widget.imagebox()
wifiicon:set_image(beautiful.widget_wifi)
--
wifi = wibox.widget.textbox()
vicious.register(wifi, vicious.widgets.wifi, "${ssid} - Link: ${link}%", 3, "wlp6s0")
-- End Wifi }}}

-- Uptime

uptimeicon = wibox.widget.imagebox(beautiful.widget_uptime)
vicious.cache(vicious.widgets.uptime)

uptimewidget = wibox.widget.textbox()
  uptimewidget:set_align("right")
  --vicious.register(uptimewidget, vicious.widgets.uptime, markup(blue, "$1") .. markup (gray, "D ┈ ") .. markup(blue, "$2") .. markup(gray, "h ") .. markup(blue, "$3") .. markup(gray, "m"))

  --vertical widget:
vicious.register(uptimewidget, vicious.widgets.uptime, "$1" .. "D " .. "$2" .. "h " .. "$3" .. "m")

-- VPN

vpnwidget = wibox.widget.textbox()
vpnwidget:set_text(" ...checking... ")
vpnwidgettimer = timer({ timeout = 5 })
vpnwidgettimer:connect_signal("timeout",
  function()
    status = io.popen("ifconfig | grep tun0")
    if status:read() == nil then
        vpnwidget:set_text("")
    else
        vpnwidget:set_text(" VPN ON")
    end
    status:close()    
  end    
)    
vpnwidgettimer:start()


