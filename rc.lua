-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- 状态栏插件.
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
-- local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
-- local weather_widget = require("awesome-wm-widgets.weather-widget.weather")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local cmus_widget = require('awesome-wm-widgets.cmus-widget.cmus')
-- local email_widget, email_icon = require("awesome-wm-widgets.email_widget.email")
local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
-- local gerrit_widget = require("awesome-wm-widgets.gerrit-widget.gerrit")
-- local github_activity_widget = require("awesome-wm-widgets.github-activity-widget.github-activity-widget")
local github_contributions_widget = require("awesome-wm-widgets.github-contributions-widget.github-contributions-widget")
-- local github_prs_widget = require("awesome-wm-widgets.github-prs-widget")
local mpdarc_widget = require("awesome-wm-widgets.mpdarc-widget.mpdarc")
local mpris_widget = require("awesome-wm-widgets.mpris-widget")
local run_shell = require("awesome-wm-widgets.run-shell-3.run-shell")
local spotify_shell = require("awesome-wm-widgets.spotify-shell.spotify-shell")
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
-- local gerrit_widget = require("awesome-wm-widgets.gerrit-widget.gerrit")


--  状态栏插件
local vicious = require("vicious")

-- 天气插件sudo apt-get install weather-util
-- require("weather")

-- 电量插件sudo apt-get install acpitool
-- require("power")


-- Standard awesome library
-- 加载Awesome API library
-- gears 常用的工具
-- wibox Awesome的widget框架
-- awful window managment方面的功能
-- naughty 有关通知的功能
-- menubar XDG menu相关实现
-- beautiful Awesome主题相关的功能
local gears = require("gears")
local awful = require("awful")
-- 自动聚焦
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- 通知
local naughty = require("naughty")
naughty.config.defaults.shape = gears.shape.rounded_rect
naughty.config.defaults.position = 'top_right'
-- Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "CaskadiaCove Nerd Font Mono Regular 10"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 32
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- 多显示器
local xrandr = require("xrandr")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
-- awesome.startup_errors 中包含的是awesome启动期间的错误信息
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
-- awesome.connect_signal(event,func) 来注册当时间发生时调用哪个函数，其中 event为字符串形式的时间名称,func为触发调用的函数
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- beautiful.init(config) 函数初始化主题
-- {{{ Variable definitions theme: default  sky  xresources  zenburn
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")

-- 颜色主题：cool-blue  bamboo  brown  grey-old  grey-clean rbown  sky-grey  snow  wabbit  worm  fence
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "snow"))

-- beautiful.init(awful.util.getdir("config") .. "/themes/elric/theme.lua")
-- beautiful.init("~/.config/awesome/themes/bamboo/theme.lua")

-- 更改背景图片
-- beautiful.get().wallpaper = "~/图片/Wallpapers/wallhaven-4yr2mx.jpg"

-- 定义终端、默认编辑器
-- This is used later as the default terminal and editor to run.
terminal        =    "st"
editor          =    os.getenv("EDITOR") or "nvim"
editor_cmd      =    terminal .. " -e " .. editor
browser         =    "google-chrome-stable"
music           =    "netease-cloud-music"
gui_editor      =    "gvim"
filemgr         =    "thunar"
filemanager     =    "pcmanfm"
flameshot       =    "flameshot gui"
gediteditor     =    "gedit"


-- 设置默认的modkey
modkey = "Mod4"
altkey = "Mod1"

-- awful.layout.layouts 中包含了所有可用的layout
-- 定义可用的布局
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys",           function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual",            terminal .. " -e man awesome" },
   { "edit config",       editor_cmd .. " " .. awesome.conffile },
   { "restart",           awesome.restart },
   { "quit",              function() awesome.quit() end },
   { "reboot",            awesome.reboot },
   { "shutdown",          awesome.shutdown },
   {"关机",               "shutdown -h now"},
   {"重启",               "reboot"},
}

appsmenu = {
   { "urxvt",                  "urxvt" },
   { "sakura",                 "sakura" },
   { "ncmpcpp",                terminal .. " -e ncmpcpp" },
   { "luakit",                 "luakit" },
   { "uzbl",                   "uzbl-browser" },
   { "firefox",                "firefox" },
   { "google-chrome-stable",   "google-chrome-stable" },
   { "thunar",                 "thunar" },
   { "ranger",                 terminal .. " -e ranger" },
   { "gvim",                   "gvim" },
   { "leafpad",                "leafpad" },
   { "htop",                   terminal .. " -e htop" },
   { "sysmonitor",            "gnome-system-monitor" },
   -- { "pasystray",             "pasystray" },
   -- { "kmix",                  "kmix" },
   -- { "pa-applet",             "/foo/bar/bin/pa-applet" },
   -- { "mictray",               "mictray" },
   -- { "nm-applet",             "nm-applet" },
   -- { "blueman-applet",        "blueman-applet" },
}

chatsmenu = {
   { "QQ",                  "qq" },
   { "wechat",              "wechat" },
   { "TIM",                 "TIM" },
   { "baidudisk",           "baidudisk" },
   { "thundrbird",          "thundrbird" },
   { "wangyiyunyinyue",     "netease-clod-music" },

}


editorsmenu = {
   { "VSCode",                  "urxvt" },
   { "gedit",                  "urxvt" },
   { "notepad++",                  "urxvt" },
   { "wps",                  "urxvt" },
   { "et",                  "urxvt" },
   { "wpp",                  "urxvt" },
   { "Latex",                  "urxvt" },
   { "Lyx",                  "urxvt" },

}



gamesmenu = {
   { "warsow", "warsow" },
   { "nexuiz", "nexuiz" },
   { "xonotic", "xonotic" },
   { "openarena", "openarena" },
   { "alienarena", "alienarena" },
   { "teeworlds", "teeworlds" },
   { "frozen-bubble", "frozen-bubble" },
   { "warzone2100", "warzone2100" },
   { "wesnoth", "wesnoth" },
   { "supertuxkart", "supertuxkart" },
   { "xmoto" , "xmoto" },
   { "flightgear", "flightgear" },
   { "snes9x" , "snes9x" }
}


local menu_awesome     = { "awesome",        myawesomemenu,    beautiful.awesome_icon }
local menu_terminal    = { "open terminal",  terminal,      }
local gamemenu         = { "游戏",           gamesmenu,     }
local appmenu          = { "APP",            appsmenu,      }
local chatmenu         = { "视讯",           chatsmenu,     }
local editormenu       = { "编辑器",         editorsmenu,   }


-- awful.menu:new(args,parent)用于生成menu对象，
if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                  gamemenu,
                  appmenu,
                  chatmenu,
                  editormenu
                }
    })
end

-- mymainmenu = awful.menu({
--     items = {
--               { "awesome",        myawesomemenu,    beautiful.awesome_icon },
--               { "Debian",         debian.menu.Debian_menu.Debian },
--               { "open terminal",  terminal        },
--               { "游戏",           gamesmenu,        beautiful.theme.fav_icon},
--               { "APP",            appsmenu        },
--               { "视讯",           chatmenus       },
--               { "编辑器",         editorsmenu     },
--             }
-- })




-- awful.widget.launcher:new (args)函数创建一个button widget，点击之后执行特点的命令。
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

emacslauncher = awful.widget.launcher({ image = "/usr/share/icons/hicolor/128x128/apps/emacs.png",
                                         command = "/usr/bin/emacsclient -a '' -n -c"})

-- menubar.utils.terminal指定了当应用需要在终端运行时，打开哪个终端
-- Menubar configuration
menubar.utils.terminal = terminal

-- Set the terminal for applications that require it
-- }}}

--  awful.widget.keyboardlayout:new ()创建一个键盘布局的widget,用于显示当前的键盘布局
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- 创建一个textclock widget，用于显示时间。其中
-- format
-- 指明时间的格式，默认为"%a %b %d"
-- timeout
-- 指定多少秒更新一次时间，默认为60
-- timezone
-- 指明时区默认为本地时区
-- Create a textclock widget
-- mytextclock = wibox.widget.textclock("%Y-%m-%d %A %H:%M:%S",1)
-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %Y-%m-%d %A %H:%M:%S",1)

-- or customized
local cw = calendar_widget({
    --  nord outrun  light dark naughty  monokai
    theme = 'monokai',
    placement = 'top_right',
    start_sunday = false,
    radius = 12,
-- with customized next/previous (see table above)
    previous_month_button = 1,
    next_month_button = 3,
})
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)

--定义点击tag的行为
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    -- 点击左键，切换到该tag
                    awful.button({ }, 1, function(t) t:view_only() end),
                    -- modkey+左键，将当前window移动到指定tag
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    -- 点击右键，让指定tag也可见
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    --   modkey+右键，让当前window在指定tag也可见
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )


-- 定义点击任务栏的行为
local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- 当屏幕发生改变时，重新设置壁纸
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)



--==================================================================================================
--========================= 定制标签=======================================
--==================================================================================================

-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox(beautiful.arrl)
arrl_dl = wibox.widget.imagebox(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox(beautiful.arrl_ld)


--=======================================================================================================
--========================  设置屏幕布局  ==============================================
--=======================================================================================================
--  awful.screen.connect_for_each_screen (func) 为每个已存在的，且后面新创建的屏幕都调用 func, 其中 func 接受一个 screen 作为参数
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- awful.tag({ "➊", "➋", "➌", "➍" , "5", "6", "7📀", "8", "9" }, s, awful.layout.layouts[1])
    awful.tag({ "Brows", "code", "Term", "File" ,"Word" , "Chat", "Graph", "Video", "♪Music"}, s, awful.layout.layouts[1])



    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,

        style = {
                	border_width = 1,
               	border_color = '#000',
            -- shape = gears.shape.powerline
            -- shape = gears.shape.rectangular_tag
            -- shape = gears.shape.hexagon
            -- shape = gears.shape.rounded_bar
            -- shape = gears.shape.rounded_rect

        },
        layout = {
            spacing = 1,
            spacing_widget = {
                {forced_width = 0, widget = wibox.widget.separator},
                valign = 'right',
                halign = 'center',
                widget = wibox.container.place
            },

            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {id = 'icon_role', widget = wibox.widget.imagebox},
                        margins = 0,
                        widget = wibox.container.margin
                    },

                    {id = 'text_role', widget = wibox.widget.textbox},
                    layout = wibox.layout.fixed.horizontal
                },
                left = 20,
                right = 20,
                widget = wibox.container.margin
            },
            id = 'background_role',
            forced_width = 200,
            widget = wibox.container.background
        }
    }



    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = 28,
        opacity = 1,
    })

    mysystray = wibox.widget.systray()

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        align = "centered",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        -- s.mytasklist, -- Middle widget
        -- { -- Right widgets
        --     layout = wibox.layout.fixed.horizontal,
        --     mykeyboardlayout,
        --     wibox.widget.systray(),
        --     mytextclock,
        --     s.mylayoutbox,
        -- },

        {
            layout = wibox.layout.fixed.horizontal,
            --   s.mytasklist -- Middle widget
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacer,
            net_speed_widget(),
            spacer,
            ram_widget(),
            spacer,
            cpu_widget({
                    width = 70,
                    step_width = 2,
                    step_spacing = 1,
                    --enable_kill_button=true,
                    timeout=5
                    }),
            spacer,
            fs_widget({ mounts = { '/','/home'} }), -- multiple mounts
            spacer,
            mpdarc_widget,
            spacer,
            mpris_widget(),
            spacer,
            cmus_widget{
                        space = 5,
                        timeout = 5
                    },
            spacer,
            volume_widget{
                       widget_type = 'arc'
                    },
            spacer,
            battery_widget(),
            spacer,
            batteryarc_widget({
                        show_current_level = true,
                        arc_thickness = 1,
                    }),
            -- weather_curl_widget({
            --     api_key='254413c4983a9d2ec7d40932524c97b0',
            --     coordinates = {45.5017, -73.5673},
            --     time_format_12h = true,
            --     units = 'imperial',
            --     both_units_widget = true,
            --     font_name = 'Carter One',
            --     icons = 'VitalyGorbachev',
            --     icons_extension = '.svg',
            --     show_hourly_forecast = true,
            --     show_daily_forecast = true,
            -- }),
            spacer,
            brightness_widget{
                        type = 'icon_and_text',
                        program = 'xbacklight',
                        step = 2,
                    },
            spacer,
            -- github_contributions_widget({username = 'junjiecjj'}),
            spacer,
            -- github_prs_widget {
            --         reviewer = 'streetturtle'
            --     },
            spotify_widget({
                       font = 'Ubuntu Mono 9',
                       play_icon = '/usr/share/icons/Papirus-Light/24x24/categories/spotify.svg',
                       pause_icon = '/usr/share/icons/Papirus-Dark/24x24/panel/spotify-indicator.svg'
                    }),
            spacer,
            mytextclock,
            spacer,
            logout_menu_widget(),
            arrl_ld,
            spacer,
            mysystray,
            spacer,
            s.mylayoutbox,
            spacer,
            layout = wibox.layout.fixed.horizontal
        }
    }


end)
-- }}}


--===============================================================================================================
--==================  自启动程序 =======================================
--===============================================================================================================
-- -- 方法一：
-- autorun = true
-- autorunApps =
-- {
--     "nm-applet &",
--     "blueman-applet  &",
--     "xscreensaver  -no-splash &",
--     "redshift-gtk  &",
--     "picom --experimental-backends -b",
--     "feh --recursive --randomize --bg-fill /home/jack/图片/Wallpapers/",
--     "nohup  flameshot >/dev/null 2>&1 &",
--     "dunst &",
--     "copyq &",
--     "fcitx &",
--     "fcitx5 &",
--     --  yinpin
--     "nohup pasystray  >/dev/null 2>&1 &",
--     "nohup kmix   >/dev/null 2>&1 &",
--     "nohup /foo/bar/bin/pa-applet   >/dev/null 2>&1 &",
--     "nohup mictray   >/dev/null 2>&1 &",
--     "gnome-settings-daemon"
-- }

-- if autorun then
--     for app = 1, #autorunApps do
--         awful.util.spawn_with_shell(autorunApps[app])
--     end
-- end
-- -- 但这种自启动方式会在每次启动Awesome的时候都运行这些程序，每次需要重启Awesome时，会发现这些程序又再次启动了一次。因此最好是让这些程序只启动一次。将上面的代码改为： 方法二


-- -- 方法二：

-- Autostart windowless processes
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
            findme = cmd:sub(0, firstspace-1)
        end
        awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
    end
end


-- --  "by kelu",
-- local function run_once(cmd_arr)
--     for _, cmd in ipairs(cmd_arr) do
--         awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
--     end
-- end


-- run_once({"kbdd"})
-- run_once({"redshift-gtk &"})
-- run_once({"blueman-applet &"})
-- run_once({"nm-applet &"})
-- run_once({"xscreensaver  -no-splash &"})
-- run_once({ "picom --experimental-backends -b"})
-- run_once({"feh --recursive --randomize --bg-fill /home/jack/图片/Wallpapers/"})
-- run_once({"nohup  flameshot >/dev/null 2>&1 &"  })
-- run_once({"dunst &"})
-- run_once({"fcitx &"})
-- run_once({"fcitx5 &"})
-- run_once({"nohup pasystray  >/dev/null 2>&1 &"})
-- run_once({"nohup kmix   >/dev/null 2>&1 &"})
-- run_once({"nohup /foo/bar/bin/pa-applet   >/dev/null 2>&1 &"})
-- run_once({"nohup mictray   >/dev/null 2>&1 &"})
-- run_once({"gnome-settings-daemon"})




-- 方法三： 执行自启动脚本
awful.spawn.with_shell("bash ~/.config/awesome/autostart_cjj.sh &")

--============================================================================================================
--==================================   设置快捷键 ====================================
--============================================================================================================

-- {{{ Mouse bindings
-- 设置全局鼠标操作
-- 全局鼠标操作是在root窗口进行鼠标操作时触发的操作，awesome不带任何参数调用对应的函数。
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}


-- 设置全局快捷
-- 全局快捷键在任何情况下都可触发，当触发全局快捷键的函数时，awesome并不会传递任何参数
-- {{{ Key bindings
globalkeys = gears.table.join(
    -- 打开所有的快捷键命令列表
    awful.key({ modkey,           }, "h",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    --  ==================================================================================================
    --  ======================  切换桌面快捷键 ==============================
    --  ==================================================================================================
    --  依次顺序切换到上一个标签页(桌面，workspace)  Mod4 + Left
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    --   切换到下一个标签页(桌面，workspace)  Mod4 + Right
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    --   切换到上一个标签页(桌面，workspace) 切换标签  Mod4 + ;
    awful.key({ modkey,           }, ";",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    --   切换到下一个标签页(桌面，workspace)  Mod4 + '
    awful.key({ modkey,           }, "'",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    -- Mod4 + Esc 快速切换到上一个聚焦的标签页(桌面)
    -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    --           {description = "go back", group = "tag"}),
    -- awful.key({ modkey,           }, "Tab", awful.tag.history.restore,
    --           {description = "go back", group = "tag"}),
    awful.key({ modkey,           }, "`", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    -- Mod4 + b 快速切换到上一个聚焦的标签页(桌面)
    awful.key({ modkey,           }, "b", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    --  ==================================================================================================
    --  ======================  切换窗口快捷键 ==============================
    --  ==================================================================================================
    -- 跳转到紧急窗口
    --awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    --          {description = "jump to urgent client", group = "client"}),

    -- 切换至下一窗口 Mod4 + j    切换到其它窗口,不跨越显示器
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    --  切换至上一窗口 Mod4 + k,不跨越显示器
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- 切换至下一窗口 Mod4 + w    切换到其它窗口,不跨越显示器
    awful.key({ modkey,           }, "w",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    --  切换至上一窗口 Mod4 + q,不跨越显示器
    awful.key({ modkey,           }, "q",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- 切换至下一窗口 Mod4 + .    切换到其它窗口
    awful.key({ modkey,           }, ".",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    --  切换至上一窗口 Mod4 + ,
    awful.key({ modkey,           }, ",",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    --  在两个窗口间切换  Mod4 + Tab, 切换至前一个聚焦的窗口：
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    -- -- 在两个窗口间切换  alt + tab  把Alt+Tab绑定到切换至前一个窗口：
    -- awful.key({ "Mod1", }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),
    -- 打开菜单 mod4 + u
    awful.key({ modkey,           }, "u", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- =================================================================================
    -- ========================= 窗口布局
    -- =================================================================================
    --   切换窗口布局  比如水平布局下，新开窗口与原窗口水平分割桌面  mod4 + Shift + space
    awful.key({ modkey,  "Shift"   }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    --  反向更改桌面布局  mod4 + Control + space
    awful.key({ modkey, "Control"  }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),


    -- Layout manipulation
    --  将当前窗口与下一窗口互换位置  Mod4 + Shift + j
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    -- 将当前窗口与上一窗口互换位置  Mod4 + Shift + k
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

    --  增加窗口大小 Mod4 + =  调整当前窗口大小
    awful.key({ modkey,           }, "=",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    --  减小窗口大小 Mod4 + -
    awful.key({ modkey,           }, "-",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),

    awful.key({ modkey,  "Shift"   }, "=",     function () awful.client.incwfact( 0.05)      end,
             {description = "increase height", group = "layout"}),

    awful.key({ modkey,  "Shift"   }, "-",     function () awful.client.incwfact(-0.05)      end,
            {description = "decrease height", group = "layout"}
        ),

    --  减少主窗口个数 Mod4 + Shift + h, 增加一个主视窗区
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    --  增加主窗口个数 Mod4 + Shift + l, 减少一个主视窗区
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    -- 增加主轴的聚焦窗口数量, 增加一个非主视窗区的column数
    awful.key({ modkey, "Mod1" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    -- 减少主轴的聚焦窗口数量, 减少一个非主视窗区的column数
    awful.key({ modkey, "Mod1" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    --  ==================================================================================
    --  窗口最小化还原  Mod4 + Shift + n
    --  ==================================================================================
    awful.key({ modkey, "Shift" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),


    --  ==================================================================================================
    --  ======================  切换显示器快捷键 ==============================
    --  ==================================================================================================
    -- awesome桌面与显示器关系如下：每个显示器都可以打开所有的桌面，显示器之间的桌面完全独立，也就是如果有7个桌面，则显示器1和2都可以有7个桌面，且在显示器1中切换桌面不会影响显示器2,系统托盘只在primary显示.

    --  切换到下一个显示器屏幕  Mod4 + Control + j   切换不同的screen,聚焦下一个屏幕, 这会将您的光标从一个屏幕移动到另一个屏幕。它将焦点从一个屏幕上的客户端窗口更改为下一个屏幕上的客户端窗口。
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    --  切换到上一个显示器屏幕 Mod4 + Control + k
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    --  切换到下一个显示器屏幕  Mod4 + ]
    awful.key({ modkey,           }, "]", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    --  切换到上一个显示器屏幕 Mod4 + [
    awful.key({ modkey,           }, "[", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    --  切换到下一个显示器屏幕  Mod4 + s
    awful.key({ modkey,           }, "s", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    --  切换到上一个显示器屏幕 Mod4 + a
    awful.key({ modkey,           }, "a", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),

    --  切换到下一个显示器屏幕  Mod4 + Escape
    awful.key({ modkey,           }, "Escape", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

    --  https://awesomewm.org/recipes/xrandr/
    --Pressing this key binding will open a popup with a possible screen arrangement. Pressing the key again will replace this popup with the next possibility, eventually arriving at "keep the current configuration".
    -- If the key is not pressed again within four seconds, the configuration described in the current popup is applied.
    awful.key({modkey,  "Mod1"   }, "s", function() xrandr.xrandr() end),
    awful.key({ modkey, "Mod1" }, "m", function() xrandr.switch(2) end),
    --  ==================================================================================================
    --  ======================  自定义的 APP快捷键 ==============================
    --  ==================================================================================================

    -- Standard program
    --  打开终端  mod4 + enter
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "x", function () awful.spawn("xterm") end,
              {description = "open a terminal", group = "launcher"}),

    --  重启awesome  mod4 + ctrl + r
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    -- 退出awesome  mod4 + Control + e
    awful.key({ modkey, "Control" }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Prompt
    ----	mod4 + r  打开程序或命令
    --awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    --          {description = "run prompt", group = "launcher"}),

    -- --  mod4 + x 执行lua代码
    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"}),

    -- -- Menubar
    -- --  显示菜单栏，和mod+u以及rofi功能类似
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"}),


    -- 亮度/音量快捷键
    awful.key({}, "XF86MonBrightnessUp", function() os.execute("xbacklight -inc 5") end,
              {description = "+5%", group = "custom"}),
    awful.key({}, "XF86MonBrightnessDown", function() os.execute("xbacklight -dec 5") end,
              {description = "-5%", group = "custom"}),

    -- amixer useless here
    -- awful.key({}, "XF86AudioRaiseVolume", function() os.execute("amixer set Master '5%+'") end,
    --           {description = "volume up", group = "custom"}),
    -- awful.key({}, "XF86AudioLowerVolume", function() os.execute("amixer set Master '5%-'") end,
    --           {description = "volume down", group = "custom"}),
    -- awful.key({}, "XF86AudioMute", function() os.execute("amixer -D pulse set Master 1+ toggle") end,
    --           {description = "toggle mute", group = "custom"}),

    awful.key({}, "XF86AudioRaiseVolume", function() os.execute("pactl set-sink-volume @DEFAULT_SINK@ +8%") end,
              {description = "volume up", group = "custom"}),
    awful.key({}, "XF86AudioLowerVolume", function() os.execute("pactl set-sink-volume @DEFAULT_SINK@ -8%") end,
              {description = "volume down", group = "custom"}),
    awful.key({}, "XF86AudioMute", function() os.execute("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
              {description = "toggle mute", group = "custom"}),


    awful.key({modkey, "Shift" }, "=", function() os.execute("amixer set Master '5%+'") end,
              {description = "volume up", group = "custom"}),
    awful.key({modkey, "Shift" }, "-", function() os.execute("amixer set Master '5%-'") end,
              {description = "volume down", group = "custom"}),
    awful.key({modkey, "Shift" }, "BackSpace", function() os.execute("amixer -D pulse set Master 1+ toggle") end,
              {description = "toggle mute", group = "custom"}),

    awful.key({modkey, "Control" }, "=", function() os.execute("pactl set-sink-volume @DEFAULT_SINK@ +8%") end,
              {description = "volume up", group = "custom"}),
    awful.key({modkey, "Control" }, "-", function() os.execute("pactl set-sink-volume @DEFAULT_SINK@ -8%") end,
              {description = "volume down", group = "custom"}),
    awful.key({modkey, "Control" }, "BackSpace", function() os.execute("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
              {description = "toggle mute", group = "custom"}),




    -- -- ALSA volume control
    -- awful.key({  }, "XF86AudioRaiseVolume",
    --     function ()
    --         os.execute(string.format("amixer -q set %s 5%%+", beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end,{description = "volume up", group = "hotkeys"}),
    -- awful.key({  }, "XF86AudioLowerVolume",
    --     function ()
    --         os.execute(string.format("amixer -q set %s 5%%-", beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end,{description = "volume down", group = "hotkeys"}),
    -- awful.key({  }, "XF86AudioMute",
    --     function ()
    --         os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end,{description = "toggle mute", group = "hotkeys"}),


    awful.key({ modkey, altkey}, "+", function () brightness_widget:inc() end, {description = "increase brightness", group = "custom"}),
    awful.key({ modkey, altkey}, "-", function () brightness_widget:dec() end, {description = "decrease brightness", group = "custom"}),


    awful.key({ }, "XF86AudioNext",function () awful.util.spawn( "mpc next" ) end),
    awful.key({ }, "XF86AudioPrev",function () awful.util.spawn( "mpc prev" ) end),
    awful.key({ }, "XF86AudioPlay",function () awful.util.spawn( "mpc play" ) end),
    awful.key({ }, "XF86AudioStop",function () awful.util.spawn( "mpc pause" ) end),

    -- awful.key({ }, "XF86AudioNext",function () awful.util.spawn( "playerctl next" ) end),
    -- awful.key({ }, "XF86AudioPrev",function () awful.util.spawn( "playerctl prev" ) end),
    -- awful.key({ }, "XF86AudioPlay",function () awful.util.spawn( "playerctl play-pause" ) end),
    -- awful.key({ }, "XF86AudioStop",function () awful.util.spawn( "playerctl pause" ) end),

    awful.key({ modkey, altkey }, "k", function() awful.spawn.with_shell("xkill") end,
              {description = "xkill", group = "custom"}),

    -- 音乐控制，MPD control
    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.spawn.with_shell("mpc toggle")
            beautiful.mpd.update()
        end,{description = "mpc toggle", group = "widgets"}),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.spawn.with_shell("mpc stop")
            beautiful.mpd.update()
        end,{description = "mpc stop", group = "widgets"}),
    awful.key({ altkey, "Control" }, "Left",
        function ()
            awful.spawn.with_shell("mpc prev")
            beautiful.mpd.update()
        end,{description = "mpc prev", group = "widgets"}),
    awful.key({ altkey, "Control" }, "Right",
        function ()
            awful.spawn.with_shell("mpc next")
            beautiful.mpd.update()
        end,{description = "mpc next", group = "widgets"}),
    awful.key({ altkey }, "0",
        function ()
            local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
            if beautiful.mpd.timer.started then
                beautiful.mpd.timer:stop()
                common.text = common.text .. lain.util.markup.bold("OFF")
            else
                beautiful.mpd.timer:start()
                common.text = common.text .. lain.util.markup.bold("ON")
            end
            naughty.notify(common)
        end,{description = "mpc on/off", group = "widgets"}),


    -- -- Widgets popups
    -- awful.key({ altkey, }, "p", function () lain.widget.calendar.show(7) end,
    --           {description = "show calendar", group = "widgets"}),
    -- awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
    --           {description = "show filesystem", group = "widgets"}),
    -- awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
    --           {description = "show weather", group = "widgets"}),


    -- 截图快捷键
    awful.key({"Shift"}, "Print", function() awful.spawn.with_shell("flameshot gui -p  $(xdg-user-dir PICTURES) -d 2000 ;exec notify-send '火焰截图 无延时 自己选择截图区域 保存在~/图片'") end,
              {description = "take a screenshot", group = "custom"}),

    awful.key({"Control"}, "Print", function() awful.spawn.with_shell("flameshot full -c -p  $(xdg-user-dir PICTURES)  -d 2000 ;exec notify-send '火焰截图 捕获全屏（无GUI）并保存到剪贴板和路径~/图片 延迟2秒'") end,
              {description = "take a screenshot", group = "custom"}),

    awful.key({modkey,"Shift"}, "Print", function() awful.spawn.with_shell("deepin-screenshot;exec notify-send '深度截图' ") end,
              {description = "take a screenshot", group = "custom"}),


    awful.key({}, "Print", function() awful.spawn.with_shell("scrot -cd 3 $(xdg-user-dir PICTURES)/'Scrot_%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'xclip -selection clipboard -target image/png -i $f; viewnior $f';exec notify-send 'Scrot截图 截取全屏 无GUI 保存指定路径 延迟3s 复制到剪切板 打开查看'") end,
              {description = "take a screenshot", group = "custom"}),

    awful.key({modkey}, "Print", function() awful.spawn.with_shell("scrot $(xdg-user-dir PICTURES)/'Scrot_%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'viewnior $f';exec notify-send 'Scrot截图 截取全屏，无GUI，保存指定路径 打开查看'") end,
              {description = "take a screenshot", group = "custom"}),

    awful.key({ modkey, "Control" }, "t", function() awful.spawn.with_shell("bash ~/.config/awesome/script/touchpad.sh") end,
              {description = "touchpad toggle", group = "custom"}),


    -- 文件管理器
    awful.key({ modkey }, "t", function() awful.spawn.with_shell("thunar /home/jack/") end,
              {description = "open file manager", group = "custom"}),
    -- dmenu程序启动器
    awful.key({ modkey }, "d", function() awful.spawn.with_shell("dmenu_run") end,
              {description = "dmenu程序启动器", group = "custom"}),
    -- rofi程序启动器
    awful.key({ modkey }, "r", function() awful.spawn.with_shell("rofi  -show combi") end,
              {description = "rofi程序启动器", group = "custom"}),
    -- gmrun程序启动器
    awful.key({ modkey }, "\\", function() awful.spawn.with_shell("gmrun") end,
              {description = "gmrun程序启动器", group = "custom"}),

    -- goole浏览器
    awful.key({ modkey }, "g", function() awful.spawn.with_shell("google-chrome-stable") end,
              {description = "google  Browser", group = "custom"}),
    -- slock锁屏
    awful.key({ modkey, "Control" }, "s", function() awful.spawn.with_shell("slock") end,
              {description = "slock锁屏", group = "custom"}),
    -- xscreensaver锁屏
    awful.key({ modkey, "Control" }, "x", function() awful.spawn.with_shell("xscreensaver-command -lock") end,
              {description = "xscreensaver锁屏", group = "custom"}),
    -- betterlockscreen锁屏
    awful.key({ modkey, "Control" }, "b", function() awful.spawn.with_shell("betterlockscreen -l") end,
              {description = "betterlockscreen锁屏", group = "custom"}),
    -- awful.key({ modkey, "Mod1" }, "Escape", function() awful.spawn.with_shell("bash ~/.config/awesome/script/dmenu-logout.sh") end,
    --           {description = "betterlockscreen锁屏", group = "custom"}),
    --  feh更换壁纸
    awful.key({ modkey, "Shift" }, "b", function() awful.spawn.with_shell("feh --recursive --randomize --bg-fill $(xdg-user-dir PICTURES)'/Wallpapers/'") end,
              {description = "betterlockscreen锁屏", group = "custom"}),
    awful.key({ modkey, "Shift"   }, "p", function() cmus_widget:play_pause() end,
            {description = "play/pause cmus", group = "custom"}),

    awful.key({modkey,"Shift"}, "r", function () run_shell.launch() end),
    awful.key({ modkey, "Shift"  }, "d", function () spotify_shell.launch() end, {description = "spotify shell", group = "music"})


)


-- 设置client快捷键
-- client快捷键是当有焦点在window(client)上时才能触发的。这时awesome调用快捷键上的函数时会将当前client作为参数传递过去。
clientkeys = gears.table.join(
    --  全屏与还原	Mod4 + f
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
   --  关闭当前窗口  Mod4 + Shift + q
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),

    --  切换当前窗口是否为浮动     Mod4 +  Space
    awful.key({ modkey,           }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    -- 将当前窗口提升为主窗口，将当前窗口与主窗口互换，单向
    awful.key({ modkey, "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    --  ==================================================================================================
    --  ======================  窗口在显示器间切换快捷键 ==============================
    --  ==================================================================================================

    -- 把当前程序发送到下一个显示器中, 通过 modkey + o 快捷键可以发送 window 窗口到另一个显示器，并聚焦于另一个显示器。
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    -- 将窗口移动到另一个屏幕并且保持焦点在当前屏幕
    awful.key({ modkey, "Shift" }, "o", function (c) c:
          move_to_screen()
          awful.screen.focus_relative(-1)
        end, {description = "move to other screen without move focus", group = "client"}),

    -- 将当前窗口移动到上一个显示器,聚焦于上一个显示器
    awful.key({ modkey, "Control"  }, "[",
              function (c)
                  c:move_to_screen((awful.screen.focused().index - 1) % 3)
              end, {description = "move to previous screen", group = "client"}),
    -- 将当前窗口移动到下一个显示器,聚焦于下一个显示器
    awful.key({ modkey, "Control"  }, "]",
              function (c)
                  c:move_to_screen((awful.screen.focused().index + 1) % 3)
              end, {description = "move to previous screen", group = "client"}),
    -- 将当前窗口移动到上一个显示器,但聚焦于当前显示器
    awful.key({ modkey, "Shift"   }, "[",  function (c) c:
            move_to_screen((awful.screen.focused().index - 1) % 3)
            awful.screen.focus_relative(1)
        end, {description = "move to previous screen", group = "client"}),
    -- 将当前窗口移动到下一个显示器,但聚焦于当前显示器
    awful.key({ modkey, "Shift"   }, "]", function (c) c:
                  move_to_screen((awful.screen.focused().index + 1) % 3)
                  awful.screen.focus_relative(-1)
              end, {description = "move to previous screen", group = "client"}),


    --  标记窗口（可标记多个）Mod4 + Shift + t
    awful.key({ modkey,   "Shift" }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    --  窗口最小化  Mod4 + n
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    -- 窗口最大化,退出最大化  Mod4+m
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    -- 窗口垂直最大化    Mod4+Control+m
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    -- 窗口水平最大化    Mod4+Shift+m
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),

    --  移动浮动窗口To move windows with mod+shift+←/↓/↑/→
    awful.key({ modkey, "Shift"   }, "Down",   function (c) c:relative_move(  0,  20,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Up",     function (c) c:relative_move(  0, -20,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Left",   function (c) c:relative_move(-20,   0,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Right",  function (c) c:relative_move( 20,   0,   0,   0) end),

    --  改变浮动窗口大小
    awful.key({ modkey, "Control"   }, "Up",   function (c) c:relative_move( 20,  20, -40, -40) end),
    awful.key({ modkey,  "Control"  }, "Down",  function (c) c:relative_move(-20, -20,  40,  40) end)

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        --  mod4+1-9  切换标签ye   切换到tag 1-9
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        --  mod4 + ctrl + num 将另一桌面的内容显示至当前桌面   把当前桌面和1~9桌面一起显示
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),

        -- Move client to tag.
        -- mod4+shift+1-9  把当前窗口发送到其它工作区(桌面)   发送客户点到标签tag
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),



        -- Toggle tag on focused client.
        -- 将当前窗口复制一份到指定标签页tag
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end


-- 设置client鼠标操作
-- client鼠标操作是当有window获取到焦点时触发的操作，awesome将当前捕获到焦点的window作为参数传递给对应的函数。
clientbuttons = gears.table.join(
    --  鼠标左击  获取聚焦
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    -- Mod4+鼠标左键   移动窗口
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    -- Mod4+鼠标右键   缩放窗口
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}


--============================================================================================================
--==================================   设置快捷键over ====================================
--============================================================================================================

--============================================================================================================
--==================================   设置规则表 ====================================
--============================================================================================================

-- 需要自动设置为浮动的程序
-- 只需要把你想要设置为浮动窗口的程序的Instance或者class按照下面的格式写进去就行
-- 了。在awesome下用Mod4 + Ctr + i就可以看到当前程序的instance和class名字



-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
                     border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     -- placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     placement = awful.placement.centered + awful.placement.top+awful.placement.no_overlap + awful.placement.no_offscreen
     }
    },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Firefox", name="Download" },
      properties = { floating = true } },
    -- 这里class通过xprop程序来获取
    { rule = { class = "VirtualBox Manager" },
      properties = { tag="5.VM", switchtotag = true } },
    {
        rule_any = {class = {"netease-cloud-music"}},
        properties = {
            floating = true,
            placement = awful.placement.centered,
            border_width = 2,
            titlebars_enabled = true
        }
    },
    {rule = {class = 'Alacritty'}, properties = {width = 960, height = 640}},
    {
        rule = {class = 'uTools'},
        properties = {
            placement = (awful.placement.center + awful.placement.top),
            ontop = true,
            border_width = 0
        }
    },
   {
        rule = {class = 'Wine'},
        properties = {
            border_width = 0,
            floating = true,
            titlebars_enabled = false
        }
    },
    {
        rule = {class = 'qqmusic'},
        properties = {
            floating = true,
            placement = awful.placement.centered,
            width = 640,
            height = 48,
            titlebars_enabled = false
        }
    },
    {
        rule = {class = 'TeamViewer'},
        properties = {
            floating = true,
            placement = awful.placement.centered
            --       titlebars_enabled = false
        }
    },
    {
        rule = {class = 'Opera'},
        properties = {
            --       floating = true,
            placement = awful.placement.centered,
            titlebars_enabled = false
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    --标题栏太碍眼了，取消掉。搜索 titlebars_enabled ，设置为 false 来取消标题栏。
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}


--========================================================================================================================
--=====================  注册事件发生时的触发函数,该函数接受一个窗口(client对象)作为参数 =============
--========================================================================================================================

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    --圆角
    c.shape = function(cr,w,h)
      gears.shape.rounded_rect(cr,w,h,5)
    end
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)



-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    local top_titlebar = awful.titlebar(c, {size = 19,
  })
    -- buttons for the titlebar
    local buttons = gears.table.join(awful.button({}, 1, function()
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
    end))
    top_titlebar:setup{

        { -- Left
            spacer,
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

--  https://www.chengweiyang.cn/2018/04/28/awesome-multi-monitor-2/
--当只使用一个 screen 的时候，切换 screen 的时候，所有窗口和 systray 自动发送到另一个 screen 去，且保持布局不变。
tag.connect_signal("request::screen", function(t)
    for s in screen do
        if s ~= t.screen then
            local t2 = awful.tag.find_by_name(s, t.name)
            if t2 then
                t:swap(t2)
            else
                t.screen = s
            end
            return
        end
    end
end)

-- }}}





