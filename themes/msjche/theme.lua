--[[
                                   
     msjche Awesome WM config 1.0 
     github.com/msjche
                                   
--]]

local awful = require("awful")
awful.util = require("awful.util")

--{{{ Main
theme = {}

home          = os.getenv("HOME")
config        = awful.util.getdir("config")
shared        = "/usr/share/awesome"
if not awful.util.file_readable(shared .. "/icons/awesome16.png") then
    shared    = "/usr/share/local/awesome"
end
sharedicons   = shared .. "/icons"
sharedthemes  = shared .. "/themes"
themes        = config .. "/themes"
themename     = "/msjche"
if not awful.util.file_readable(themes .. themename .. "/theme.lua") then
       themes = sharedthemes
end
themedir      = themes .. themename

--wallpaper1    = themedir .. "/wall.png"
wallpaper1    = themedir .. "/wall.jpg"
wallpaper2    = themedir .. "/background.png"
wallpaper3    = sharedthemes .. "/zenburn/zenburn-background.png"
wallpaper4    = sharedthemes .. "/default/background.png"
wpscript      = home .. "/.wallpaper"

if awful.util.file_readable(wallpaper1) then
  theme.wallpaper = wallpaper1
elseif awful.util.file_readable(wallpaper2) then
  theme.wallpaper = wallpaper2
elseif awful.util.file_readable(wpscript) then
  theme.wallpaper_cmd = { "sh " .. wpscript }
elseif awful.util.file_readable(wallpaper3) then
  theme.wallpaper = wallpaper3
else
  theme.wallpaper = wallpaper4
end
--}}}

theme.font                          = "Droid Sans 15"
theme.taglist_font                  = "Droid Sans 17"
theme.fg_normal                     = "#747474"
theme.fg_focus                      = "#DDDCFF"
theme.bg_normal                     = "#12121200"
theme.bg_focus                      = "#101010"
theme.fg_urgent                     = "#CC9393"
theme.bg_urgent                     = "#2A1F1E"
theme.border_width                  = "2"
theme.border_normal                 = "#121212"
theme.border_focus                  = "#747474"
theme.titlebar_bg_focus             = "#292929"

theme.taglist_fg_focus              = "#DDDCFF"
theme.taglist_bg_focus              = "#121212"
theme.menu_height                   = "30"
theme.menu_width                    = "80"


theme.widget_net_up				= themedir .. "/icons/net_up.png"
theme.widget_net_down			= themedir .. "/icons/net_down.png"
theme.widget_up					= themedir .. "/icons/up.png"
theme.widget_kill				= themedir .. "/icons/kill.png"
theme.widget_play				= themedir .. "/icons/play.png"
theme.widget_pause 				= themedir .. "/icons/pause.png"
theme.widget_stop				= themedir .. "/icons/stop.png"
theme.widget_system				= themedir .. "/icons/system.png"
theme.widget_weather			= themedir .. "/icons/weather.png"
theme.widget_temp               = themedir .. "/icons/temp.png"
theme.widget_pac                = themedir .. "/icons/pac.png"
theme.widget_pacnew             = themedir .. "/icons/pacnew.png"
theme.widget_mail               = themedir .. "/icons/mail.png"
theme.widget_uptime             = themedir .. "/icons/uptime.png"
theme.widget_mpd                = themedir .. "/icons/mpd.png"
theme.widget_mpd_paused      	= themedir .. "/icons/mpd_paused.png"
theme.widget_pianobar           = themedir .. "/icons/pianobar.png"
theme.widget_pianobar_stopped	= themedir .. "/icons/pianobar_stopped.png"
theme.widget_vol                = themedir .. "/icons/vol.png"
theme.widget_cpu                = themedir .. "/icons/cpu.png"
theme.widget_mem                = themedir .. "/icons/mem.png"
theme.widget_hdd                = themedir .. "/icons/hdd.png"
theme.widget_wifi_high          = themedir .. "/icons/wifi_high.png"
theme.widget_wifi_medhigh       = themedir .. "/icons/wifi_medhigh.png"
theme.widget_wifi_med           = themedir .. "/icons/wifi_med.png"
theme.widget_wifi_medlow        = themedir .. "/icons/wifi_medlow.png"
theme.widget_wifi_low           = themedir .. "/icons/wifi_low.png"
theme.widget_wifi_no            = themedir .. "/icons/wifi_no.png"
theme.widget_bat_full			= themedir .. "/icons/bat_full.png"
theme.widget_bat_90				= themedir .. "/icons/bat_90.png"
theme.widget_bat_80        		= themedir .. "/icons/bat_80.png"
theme.widget_bat_70				= themedir .. "/icons/bat_70.png"
theme.widget_bat_60		        = themedir .. "/icons/bat_60.png"
theme.widget_bat_50         	= themedir .. "/icons/bat_50.png"
theme.widget_bat_40 		    = themedir .. "/icons/bat_40.png"
theme.widget_bat_30 	        = themedir .. "/icons/bat_30.png"
theme.widget_bat_20				= themedir .. "/icons/bat_20.png"
theme.widget_bat_10	            = themedir .. "/icons/bat_10.png"
theme.widget_bat_empty          = themedir .. "/icons/bat_empty.png"
theme.widget_charge_ac			= themedir .. "/icons/charge_ac.png"
theme.widget_charge_full		= themedir .. "/icons/charge_full.png"
theme.widget_charge_90			= themedir .. "/icons/charge_90.png"
theme.widget_charge_80			= themedir .. "/icons/charge_80.png"
theme.widget_charge_70			= themedir .. "/icons/charge_70.png"
theme.widget_charge_60			= themedir .. "/icons/charge_60.png"
theme.widget_charge_50			= themedir .. "/icons/charge_50.png"
theme.widget_charge_40			= themedir .. "/icons/charge_40.png"
theme.widget_charge_30			= themedir .. "/icons/charge_30.png"
theme.widget_charge_20			= themedir .. "/icons/charge_20.png"
theme.widget_charge_10			= themedir .. "/icons/charge_10.png"
theme.widget_charge_empty		= themedir .. "/icons/charge_empty.png"


theme.menu_submenu_icon             = themedir .. "/icons/submenu.png"
theme.taglist_squares_sel           = themedir .. "/icons/square_sel.png"
theme.taglist_squares_unsel         = themedir .. "/icons/square_unsel.png"
theme.arrl_lr_pre                   = themedir .. "/icons/arrl_lr_pre.png"
theme.arrl_lr_post                  = themedir .. "/icons/arrl_lr_post.png"

theme.layout_tile                   = themedir .. "/icons/tile.png"
theme.layout_tilegaps               = themedir .. "/icons/tilegaps.png"
theme.layout_tileleft               = themedir .. "/icons/tileleft.png"
theme.layout_tilebottom             = themedir .. "/icons/tilebottom.png"
theme.layout_tiletop                = themedir .. "/icons/tiletop.png"
theme.layout_fairv                  = themedir .. "/icons/fairv.png"
theme.layout_fairh                  = themedir .. "/icons/fairh.png"
theme.layout_spiral                 = themedir .. "/icons/spiral.png"
theme.layout_dwindle                = themedir .. "/icons/dwindle.png"
theme.layout_max                    = themedir .. "/icons/max.png"
theme.layout_fullscreen             = themedir .. "/icons/fullscreen.png"
theme.layout_magnifier              = themedir .. "/icons/magnifier.png"
theme.layout_floating               = themedir .. "/icons/floating.png"

theme.tasklist_disable_icon         = false
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

-- lain related
theme.useless_gap_width             = 10
theme.layout_uselesstile            = themedir .. "/icons/uselesstile.png"
theme.layout_uselesstileleft        = themedir .. "/icons/uselesstileleft.png"
theme.layout_uselesstiletop         = themedir .. "/icons/uselesstiletop.png"

return theme
