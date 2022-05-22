--Create a weather widget
weatherwidget = widget({ type = "textbox" })
weatherwidget.text = awful.util.pread(
  "weather -i METARID --headers=Temperature --quiet -m | awk '{print $2, $3}'"
) -- replace METARID with the metar ID for your area. This uses metric. If you prefer Fahrenheit remove the "-m" in "--quiet -m".
weathertimer = timer(
  { timeout = 900 } -- Update every 15 minutes.
)
weathertimer:add_signal(
  "timeout", function()
     weatherwidget.text = awful.util.pread(
     "weather -i METARID --headers=Temperature --quiet -m | awk '{print $2, $3}' &"
   ) --replace METARID and remove -m if you want Fahrenheit
 end)

weathertimer:start() -- Start the timer
weatherwidget:add_signal(
"mouse::enter", function()
  weather = naughty.notify(
    {title="Weather",text=awful.util.pread("weather -i METARID -m")})
  end) -- this creates the hover feature. replace METARID and remove -m if you want Fahrenheit
weatherwidget:add_signal(
  "mouse::leave", function()
    naughty.destroy(weather)
  end)
-- I added some spacing because on my computer it is right next to my clock.
awful.widget.layout.margins[weatherwidget] = { right = 5 }
