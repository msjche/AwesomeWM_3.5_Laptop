
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")

pandoraicon = wibox.widget.imagebox(beautiful.widget_pianobar)
pandoraicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell("urxvt -e ~/.config/pianobar/pianobar_headless.sh") end)))


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

