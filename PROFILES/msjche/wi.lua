-----------------------
-- AwesomeWM widgets --
--     by msjche	 --
-----------------------

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")
local lain = require("lain")

home 			= os.getenv("HOME")
confdir 		= home .. "/.config/awesome"
scriptdir 		= confdir .. "/scripts/"
themes 			= confdir .. "/themes"
active_theme 	= themes .. "/msjche"
language 		= string.gsub(os.getenv("LANG"), ".utf8", "")

beautiful.init(active_theme .. "/theme.lua")

markup      = lain.util.markup
darkblue    = theme.bg_focus
white       = beautiful.fg_focus
blue        = "#1793D0"
yellow		= "#E3E34E"
red         = "#EB8F8F"
gray        = "#858585"
border      = "#4A4A4A"
bright_red  = "#FF0000"
green       = "#41F300"

widheight = 30
cpuwidth = 50
wifiwidth = 50

local util = awful.util

local tostring     = tostring
local string       = { format = string.format,
                       gsub   = string.gsub,
                       match  = string.match }
local math         = { floor  = math.floor }

----------------------------------------------------------------------------------------
-- Launchers
launcher_dir = active_theme .. "/icons/launchers/"
icon_dir = active_theme .. "/icons/"

virtualbox_launcher= awful.widget.launcher({ image = launcher_dir .. "virtualbox.png", command = "VirtualBox" })
SSR_launcher= awful.widget.launcher({ image = launcher_dir .. "SSR.png", command = "simplescreenrecorder" })
torbrowser_launcher = awful.widget.launcher({ image = launcher_dir .. "tor.png", command = "tor-browser-en" })
steam_launcher = awful.widget.launcher({ image = launcher_dir .. "steam.png", command = "steam" })
libreoffice_launcher = awful.widget.launcher({ image = launcher_dir .. "libreoffice.png", command = "libreoffice" })
thunderbird_launcher = awful.widget.launcher({ image = launcher_dir .. "thunderbird.png", command = "thunderbird-bin" })
kill_launcher = awful.widget.launcher({ image = launcher_dir .. "kill.png", command = "/home/msjche/Scripts/minimal.sh" })
up_launcher = awful.widget.launcher({ image = launcher_dir .. "up.png", command = "/home/msjche/Scripts/up.sh" })
hud_launcher = awful.widget.launcher({ image = launcher_dir .. "hud.png", command = "/home/msjche/Scripts/start_HUD.sh" })
gimp_launcher = awful.widget.launcher({ image = launcher_dir .. "gimp.png", command = "gimp" })
filezilla_launcher = awful.widget.launcher({ image = launcher_dir .. "filezilla.png", command = "filezilla" })
chrome_launcher = awful.widget.launcher({ image = launcher_dir .. "chrome.png", command = "google-chrome-beta" })
firefox_launcher = awful.widget.launcher({ image = launcher_dir .. "firefox.png", command = "firefox-developer" })
telegram_launcher= awful.widget.launcher({ image = launcher_dir .. "telegram.png", command = "telegram" })
pycharm_launcher= awful.widget.launcher({ image = launcher_dir .. "pycharm.png", command = "pycharm" })
skype_launcher= awful.widget.launcher({ image = launcher_dir .. "skype.png", command = "skype" })
youtube_dl= awful.widget.launcher({ image = launcher_dir .. "youtube.png", command = "/home/msjche/Scripts/youtube_download.sh" })

----------------------------------------------------------------------------------------
-- System Info

systemicon = wibox.widget.imagebox(beautiful.widget_system)
vicious.cache(vicious.widgets.os)

systemwidget = wibox.widget.textbox()
  systemwidget:set_align("left")
  vicious.register(systemwidget, vicious.widgets.os, markup(gray, "User ") ..markup(blue, "$3") .. markup(gray, " ┈ ") .. markup(gray, "Hostname ") .. markup(blue, "$4") .. markup(gray, " ┈ ") .. markup(gray, "System ") .. markup(blue, "$2"))

-- Initialize widget
entnow = awful.widget.graph()
-- Graph properties
entnow:set_width(80)
entnow:set_scale(true)
entnow:set_max_value(1000)
entnow:set_background_color("#000000")
entnow:set_border_color(border)
entnow:set_color(blue)
-- Register widget
vicious.register(entnow, vicious.widgets.dio, "$1")

----------------------------------------------------------------------------------------
-- Weather

--weathericon = wibox.widget.imagebox(beautiful.widget_weather)
--weathericon:buttons(awful.util.table.join(awful.button({ }, 1, function () yawn.show(7) end)))


yawn = lain.widgets.yawn(2513768,
{
    settings = function()
        yawn_notification_preset.fg = gray
    end
})

----------------------------------------------------------------------------------------
-- Coretemp

tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_markup(markup(blue, coretemp_now) .. markup(gray, "°C"))
    end
})


----------------------------------------------------------------------------------------
-- Gmail

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

----------------------------------------------------------------------------------------
-- Pacman

-- Icon
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)

pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg, function(widget, args)
   if args[1] > 0 then
   pacicon:set_image(beautiful.widget_pacnew)
   else
   pacicon:set_image(beautiful.widget_pac)
   end

  return args[1]
  end, 1, "Arch S") -- Arch S for ignorepkg
--
-- Buttons
  function popup_pac()
  local pac_updates = ""
  local f = io.popen("sudo pacman -S --dbpath /tmp/checkup-db-msjche/sync")
--  local f = io.popen("cat /tmp/off.updates")
  if f then
	pac_updates = f:read("*a"):match(".*/(.*)-.*\n$")
  else
	local pac_updates = ""
  end
  f:close()
  if not pac_updates then
	  pac_updates = "System is up to date"
  end
  naughty.notify { text = pac_updates }
  end
  pacwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_pac)))
  pacicon:buttons(pacwidget:buttons())


----------------------------------------------------------------------------------------
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
        pianobaricon:set_image(beautiful.widget_pause)
--		return markup(gray, band)
		return markup(gray, "")
    elseif play_or_pause == "1" then
        pianobarwidget.width = 0
		return markup(blue, band) .. markup(gray, " ") .. markup(white, song)
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
mpdwidget = lain.widgets.mpd({
    settings = function()
        mpd_notification_preset.fg = gray
		mpdicon:set_image(beautiful.widget_mpd)
--        artist = mpd_now.artist .. " "
        artist = mpd_now.artist
        title  = mpd_now.title  .. " "
--		mpdwidget:set_markup(markup(blue, artist) .. markup(gray, " ┈ ") .. markup(green, title))
		mpdwidget:set_markup(markup(gray, " ") .. markup(blue, artist) .. markup(gray, " ") .. markup(white, title))
		

        if mpd_now.state == "pause" then
--            artist = "mpd"
        	artist = mpd_now.artist
            title  = "paused"
			mpdicon:set_image(beautiful.widget_mpd_paused)
--			mpdwidget:set_markup(markup(gray, artist) .. markup(gray, " ") .. markup(gray, title))
--			mpdwidget:set_markup(markup(gray, artist))
			mpdwidget:set_markup(markup(gray, ""))
        elseif mpd_now.state == "stop" then
            artist = ""
            title  = ""
			mpdicon:set_image(beautiful.widget_mpd)
        end
--		mpdwidget:set_markup(markup(blue, artist) .. markup(gray, " ┈ ") .. markup(green, title))
    end
})

----------------------------------------------------------------------------------------
-- Volume

volicon = wibox.widget.imagebox(beautiful.widget_vol)
vicious.cache(vicious.widgets.volume)

-- ALSA
volumewidget = lain.widgets.alsa({
    settings = function()
        header = " Vol "
        vlevel  = volume_now.level

        if volume_now.status == "off" then
            vlevel = vlevel .. "M "
        else
            vlevel = vlevel .. " "
        end

        widget:set_markup(markup(blue, vlevel))
    end
})

volumewidget:buttons(awful.util.table.join(
    awful.button({}, 1, function ()
        awful.util.spawn("pavucontrol")
        volumewidget.update()
    end)
))

----------------------------------------------------------------------------------------
-- CPU Graph

cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
vicious.cache(vicious.widgets.cpu)

-- Initialize widget
cpugraph1 = awful.widget.graph()
-- Graph properties
cpugraph1:set_width(cpuwidth)
cpugraph1:set_height(widheight)
cpugraph1:set_background_color("#000000")
cpugraph1:set_border_color(border)
cpugraph1:set_color(blue)
-- Register widget
vicious.register(cpugraph1, vicious.widgets.cpu, "$2")

-- Initialize widget
cpugraph2 = awful.widget.graph()
-- Graph properties
cpugraph2:set_width(cpuwidth)
cpugraph2:set_height(widheight)
cpugraph2:set_background_color("#000000")
cpugraph2:set_border_color(border)
cpugraph2:set_color(blue)
-- Register widget
vicious.register(cpugraph2, vicious.widgets.cpu, "$3")

-- Initialize widget
cpugraph3 = awful.widget.graph()
-- Graph properties
cpugraph3:set_width(cpuwidth)
cpugraph3:set_height(widheight)
cpugraph3:set_background_color("#000000")
cpugraph3:set_border_color(border)
cpugraph3:set_color(blue)
-- Register widget
vicious.register(cpugraph3, vicious.widgets.cpu, "$4")

-- Initialize widget
cpugraph4 = awful.widget.graph()
-- Graph properties
cpugraph4:set_width(cpuwidth)
cpugraph4:set_height(widheight)
cpugraph4:set_background_color("#000000")
cpugraph4:set_border_color(border)
cpugraph4:set_color(blue)
-- Register widget
vicious.register(cpugraph4, vicious.widgets.cpu, "$5")

-- Initialize widget
cpugraph5 = awful.widget.graph()
-- Graph properties
cpugraph5:set_width(cpuwidth)
cpugraph5:set_height(widheight)
cpugraph5:set_background_color("#000000")
cpugraph5:set_border_color(border)
cpugraph5:set_color(blue)
-- Register widget
vicious.register(cpugraph5, vicious.widgets.cpu, "$6")

-- Initialize widget
cpugraph6 = awful.widget.graph()
-- Graph properties
cpugraph6:set_width(cpuwidth)
cpugraph6:set_height(widheight)
cpugraph6:set_background_color("#000000")
cpugraph6:set_border_color(border)
cpugraph6:set_color(blue)
-- Register widget
vicious.register(cpugraph6, vicious.widgets.cpu, "$7")

-- Initialize widget
cpugraph7 = awful.widget.graph()
-- Graph properties
cpugraph7:set_width(cpuwidth)
cpugraph7:set_height(widheight)
cpugraph7:set_background_color("#000000")
cpugraph7:set_border_color(border)
cpugraph7:set_color(blue)
-- Register widget
vicious.register(cpugraph7, vicious.widgets.cpu, "$8")

-- Initialize widget
cpugraph8 = awful.widget.graph()
-- Graph properties
cpugraph8:set_width(cpuwidth)
cpugraph8:set_height(widheight)
cpugraph8:set_background_color("#000000")
cpugraph8:set_border_color(border)
cpugraph8:set_color(blue)
-- Register widget
vicious.register(cpugraph8, vicious.widgets.cpu, "$9")

----------------------------------------------------------------------------------------
-- File System

vicious.cache(vicious.widgets.fs)

-- Initialize widget
fshome = lain.widgets.fs({
    partition = "/home",
    settings  = function()
        fs_notification_preset.fg = gray
        fs_header = ""
        fs_p      = ""
		fs_ps	  = ""

        if fs_now.used >= 75 then
            fs_header = " Hdd "
            fs_p      = fs_now.used
			fs_ps	  = "%"
        end

        widget:set_markup(markup(gray, " ◘ ") .. markup(red, fs_header) .. markup(bright_red, fs_p) .. markup(gray, fs_ps))
    end
})

----------------------------------------------------------------------------------------
-- Memory

memicon = wibox.widget.imagebox(beautiful.widget_mem)
memicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("urxvt -e htop -s PERCENT_MEM", false) end)))
memwidget = lain.widgets.mem({
    settings  = function()
        mem_header = "mem "
        mem_u      = mem_now.used
        mem_t      = mem_now.total
        mem_p      = mem_now.percent
--        widget:set_markup(markup(blue, mem_u) .. markup(gray, "MB"))
        widget:set_markup(markup(blue, mem_u))
    end
})

----------------------------------------------------------------------------------------
-- Battery

-- Battery
baticon = wibox.widget.imagebox()
batwidget = lain.widgets.bat({

settings = function(widget, args)

batwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
baticon:buttons(batwidget:buttons())

	local bat_state  = ""
	local bat_charge = 0
	local bat_time   = 0
	local blink      = true

	bat_90	= tostring (92)
	bat_80	= tostring (85)
	bat_70	= tostring (75)
	bat_60	= tostring (65)
	bat_50	= tostring (55)
	bat_40	= tostring (45)
	bat_30	= tostring (35)
	bat_20	= tostring (25)
	bat_10	= tostring (15)
	bat_5	= tostring (7)

--	bat_perc = "/sys/class/power_supply/BAT1/capacity"
--	bat_perc = bat_now.perc

	bat_pc = bat_now.perc
	bat_p = tostring (bat_pc) 
	bat_s = bat_now.status
	bat_t = bat_now.time
        
    if bat_s == "Full" then
			baticon:set_image(beautiful.widget_charge_ac)
            return batwidget:set_markup(markup(gray, ""))
       
	elseif bat_s == "Discharging" then

	bat_perc = bat_now.perc

		if 	bat_perc >= bat_90 then
			baticon:set_image(beautiful.widget_bat_full)

		elseif bat_perc >= bat_80 and bat_perc < bat_90 then
			baticon:set_image(beautiful.widget_bat_90)
            return batwidget:set_markup(markup(gray, " ") .. markup(green, bat_t))

		elseif bat_perc >= bat_70 and bat_perc < bat_80 then
			baticon:set_image(beautiful.widget_bat_80)
            return batwidget:set_markup(markup(gray, " ") .. markup(blue, bat_t))

		elseif bat_perc >= bat_60 and bat_perc < bat_70 then
			baticon:set_image(beautiful.widget_bat_70)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t))

		elseif bat_perc >= bat_50 and bat_perc < bat_60 then
			baticon:set_image(beautiful.widget_bat_60)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t)) 

		elseif bat_perc >= bat_40 and bat_perc < bat_50 then
			baticon:set_image(beautiful.widget_bat_50)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t))
		
		elseif bat_perc >= bat_30 and bat_perc < bat_40 then
			baticon:set_image(beautiful.widget_bat_40)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t))
		
		elseif bat_perc >= bat_20 and bat_perc < bat_30 then
			baticon:set_image(beautiful.widget_bat_30)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t))
		
		elseif bat_perc >= bat_10 and bat_perc < bat_20 then
			baticon:set_image(beautiful.widget_bat_20)
            return batwidget:set_markup(markup(gray, " ") .. markup(red, bat_t) 
			.. markup(red, " ⚠"))
	
		elseif bat_perc > bat_5 and bat_perc < bat_10 then
			baticon:set_image(beautiful.widget_bat_10)
            return batwidget:set_markup(markup(gray, " ") .. markup(red, bat_t) 
			.. markup(red, " ⚠"))
	
		else
			baticon:set_image(beautiful.widget_bat_empty)
            return batwidget:set_markup(markup(gray, "  ") .. markup(bright_red, bat_t) 
			.. markup(red, " ☠ plug in charger now! ☠ "))
		end

	else

	bat_perc = bat_now.perc

		if 	bat_perc >= bat_90 then
			baticon:set_image(beautiful.widget_charge_full)

		elseif bat_perc >= bat_80 and bat_perc < bat_90 then
			baticon:set_image(beautiful.widget_charge_90)
            return batwidget:set_markup(markup(gray, " ") .. markup(green, bat_t))

		elseif bat_perc >= bat_70 and bat_perc < bat_80 then
			baticon:set_image(beautiful.widget_charge_80)
            return batwidget:set_markup(markup(gray, " ") .. markup(blue, bat_t))

		elseif bat_perc >= bat_60 and bat_perc < bat_70 then
			baticon:set_image(beautiful.widget_charge_70)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t))

		elseif bat_perc >= bat_50 and bat_perc < bat_60 then
			baticon:set_image(beautiful.widget_charge_60)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t)) 

		elseif bat_perc >= bat_40 and bat_perc < bat_50 then
			baticon:set_image(beautiful.widget_charge_50)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t))
		
		elseif bat_perc >= bat_30 and bat_perc < bat_40 then
			baticon:set_image(beautiful.widget_charge_40)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t))
		
		elseif bat_perc >= bat_20 and bat_perc < bat_30 then
			baticon:set_image(beautiful.widget_charge_30)
            return batwidget:set_markup(markup(gray, " ") .. markup(gray, bat_t))
		
		elseif bat_perc >= bat_10 and bat_perc < bat_20 then
			baticon:set_image(beautiful.widget_charge_20)
            return batwidget:set_markup(markup(gray, " ") .. markup(red, bat_t))
	
		elseif bat_perc > bat_5 and bat_perc < bat_10 then
			baticon:set_image(beautiful.widget_charge_10)
            return batwidget:set_markup(markup(gray, " ") .. markup(red, bat_t))
		
		else
			baticon:set_image(beautiful.widget_charge_empty)
            return batwidget:set_markup(markup(gray, " ") .. markup(red, bat_t))
		end
	end
end
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
--WiFi

net_up = wibox.widget.imagebox(beautiful.widget_net_up)
vicious.cache(vicious.widgets.wifi)

net_down = wibox.widget.imagebox(beautiful.widget_net_down)
vicious.cache(vicious.widgets.wifi)

local tostring     = tostring
local string       = { format = string.format,
                       gsub   = string.gsub,
                       match  = string.match }
local math         = { floor  = math.floor }

wifiicon = wibox.widget.imagebox()
wifiwidget = lain.widgets.net({
       settings = function ()
                     
       high_signal = tostring (62)
       medhigh_signal = tostring (45)
       med_signal = tostring (32)
       medlow_signal = tostring (19)

--       link = tostring (40)      -- for testing

       local link = awful.util.pread("iwconfig wlp6s0 | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1")
       
	if link == "" then
	       wifiicon:set_image(beautiful.widget_wifi_no)
			
	elseif link > high_signal then
		wifiicon:set_image(beautiful.widget_wifi_high)

	elseif link > medhigh_signal and link <= high_signal then
		wifiicon:set_image(beautiful.widget_wifi_medhigh)

	elseif link > med_signal and link <= medhigh_signal then
		wifiicon:set_image(beautiful.widget_wifi_med)

	elseif link > medlow_signal and link <= med_signal then
		wifiicon:set_image(beautiful.widget_wifi_medlow)

	else wifiicon:set_image(beautiful.widget_wifi_low)

	end
end
})

-- Net checker
netcheck = lain.widgets.net({
    settings = function()
        if net_now.state == "up" then net_state = "On"
        else net_state = "Off" end
        if net_state == "On" then
              widget:set_markup("  " .. markup(green, net_state) .. " ")
        else 
              widget:set_markup("  " ..markup(bright_red, net_state) .. " ")
        end
    end
})

wifiwidgetwidth = 50
-- Initialize widget
wifiwidget = wibox.widget.textbox()
wifiwidget.width = wifiwidgetwidth 
-- Register widget
vicious.register(wifiwidget, vicious.widgets.wifi,
    function(wifiwidget, args)
       
       if args["{ssid}"] == "N/A" then
              return " - "
       else
              return markup(yellow, " ☣ ") .. markup(blue, args["{ssid}"]) .. markup(yellow, " ☣ ")
       end
    end, 10, "wlp6s0")

vicious.cache(vicious.widgets.wifi)
vicious.cache(vicious.widgets.net)

-- Initialize widget
wifidown = awful.widget.graph()
-- Graph properties
wifidown:set_width(wifiwidth)
wifidown:set_height(widheight)
wifidown:set_scale(true)
wifidown:set_max_value(20)
wifidown:set_background_color("#000000")
wifidown:set_border_color(border)
wifidown:set_color(blue)
-- Register widget
--vicious.register(wifidown, vicious.widgets.net, "${wlp6s0 down_kb}")
vicious.register(wifidown, vicious.widgets.net, "${wlp6s0 down_kb}")

-- Initialize widget
wifiup = awful.widget.graph()
-- Graph properties
wifiup:set_width(wifiwidth)
wifiup:set_height(widheight)
wifiup:set_scale(true)
wifiup:set_max_value(5)
wifiup:set_background_color("#000000")
wifiup:set_border_color(border)
wifiup:set_color(blue)
-- Register widget
--vicious.register(wifiup, vicious.widgets.net, "${wlp6s0 up_kb}")
vicious.register(wifiup, vicious.widgets.net, "${wlp6s0 up_kb}")

----------------------------------------------------------------------------------------
-- VPN

vpnwidget = wibox.widget.textbox()
vpnwidget:set_text(" VPN")
vpnwidgettimer = timer({ timeout = 5 })
vpnwidgettimer:connect_signal("timeout",
  function()
    status = io.popen("ifconfig | grep tun0")
    if status:read() == nil then
        vpnwidget:set_markup(markup(red, ""))
    else
        vpnwidget:set_markup(markup(green, " VPN"))
    end
    status:close()    
  end    
)    
vpnwidgettimer:start()

----------------------------------------------------------------------------------------
-- Uptime

uptimeicon = wibox.widget.imagebox(beautiful.widget_uptime)
vicious.cache(vicious.widgets.uptime)

uptimewidget = wibox.widget.textbox()
  uptimewidget:set_align("right")
  --vicious.register(uptimewidget, vicious.widgets.uptime, markup(blue, "$1") .. markup (gray, "D ┈ ") .. markup(blue, "$2") .. markup(gray, "h ") .. markup(blue, "$3") .. markup(gray, "m"))

  --vertical widget:
  vicious.register(uptimewidget, vicious.widgets.uptime, markup(blue, "$1") .. markup (gray, "D ") .. markup(blue, "$2") .. markup(gray, "h ") .. markup(blue, "$3") .. markup(gray, "m"))

----------------------------------------------------------------------------------------
-- Conky HUD

function get_conky()
    local clients = client.get()
    local conky = nil
    local i = 1
    while clients[i]
    do
        if clients[i].class == "Conky"
        then
            conky = clients[i]
        end
        i = i + 1
    end
    return conky
end
function raise_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = true
    end
end
function lower_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = false
    end
end
function toggle_conky()
    local conky = get_conky()
    if conky
    then
        if conky.ontop
        then
            conky.ontop = false
        else
            conky.ontop = true
        end
    end
end

----------------------------------------------------------------------------------------
-- Test

mygraph = awful.widget.graph()
mygraph:set_width(50)
--mygraph:set_scale(true)
mygraph:set_max_value(100)
mygraph:set_background_color('#494B4F')
mygraph:set_color('#FF5656')
mygraph:set_color('#FF5656')

mygraph:add_value(50)

----------------------------------------------------------------------------------------
