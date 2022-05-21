-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

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
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

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
-- awesome.connect_signal(event,func) 来注册当时间发生时调用哪个函数，其中
-- event为字符串形式的时间名称
-- func为触发调用的函数
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
beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")

-- 更改背景图片
beautiful.get().wallpaper = "/usr/share/awesome/themes/default/background.png"

-- 定义终端、默认编辑器
-- This is used later as the default terminal and editor to run.
terminal        =    "st"
editor          =    os.getenv("EDITOR") or "nvim"
editor_cmd      =    terminal .. " -e " .. editor
browser         =    "google-chrome-stable"
gui_editor      =    "gvim"
filemgr         =    "thunar"
gediteditor           = "gedit"


-- 设置默认的modkey
modkey = "Mod4"

-- awful.layout.layouts 中包含了所有可用的layout
-- 定义可用的布局
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   -- { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "edit config", gediteditor .. "~/..config/awesome/rc.lua" },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
   { "reboot", awesome.reboot },
   { "shutdown", awesome.shutdown }
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

chatmenus = {
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

-- -- 自动生成的xdg_menu
-- xdg_menu = require("archmenu")
-- mainmenu_items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                    { "Applications", xdgmenu },
--                    { "Eshell", "eshell.sh"},
--                    { "dired", "dired.sh" },
--                    { "Firefox", "firefox" },
--                    { "open terminal", terminal }
-- }

local menu_awesome     = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal    = { "open terminal", terminal }
local gamemenu         = { "Game",       gamesmenu}
local appmenu          = { "liaotian",        chatmenus}
local editormenu         = { "bianjiqi",        editorsmenu}


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
                  editormenu
                }
    })
end

-- mymainmenu = awful.menu({
--     items = {
--               menu_awesome,
--               { "Debian", debian.menu.Debian_menu.Debian },
--               menu_terminal,
--               gamemenu,
--               appmenu,
--               editormenu
--             }
-- })




-- awful.widget.launcher:new (args)函数创建一个button widget，点击之后执行特点的命令。
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

emacslauncher = awful.widget.launcher({ image = "/usr/share/icons/hicolor/128x128/apps/emacs.png",
                                         command = "/usr/bin/emacsclient -a '' -n -c"})

-- menubar.utils.terminal指定了当应用需要在终端运行时，打开哪个终端
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
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
mytextclock = wibox.widget.textclock()


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


--==========================================================================================================
--===================================   浮动窗口 ==========================================
--==========================================================================================================
-- 需要自动设置为浮动的程序
-- 只需要把你想要设置为浮动窗口的程序的Instance或者class按照下面的格式写进去就行
-- 了。在awesome下用Mod4 + Ctr + i就可以看到当前程序的instance和class名字
-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   {rule = {},
    properties = {border_width = beautiful.border_width,
                  border_color = beautiful.border_normal,
                  focus = true,
                  keys = clientkeys,
                  buttons = clientbuttons}},
   {rule = {class = "MPlayer"},
    properties = {floating = true}},
   {rule = {class = "Smplayer"},
    properties = {floating = true, tag = tags[1][1]}},
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   {rule = {class = "Firefox"},
     properties = {tag = tags[1][1]}},
   {rule = {class = "Firefox", name = "Download"},
     properties = {floating = true}},
   {rule = {class = "VirtualBox"},
     properties = {floating = true, tag = tags[1][2]}},
   -- Set Firefox to always map on tags number 2 of screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { tag = tags[1][2] } },
} -- }}}

--==================================================================================================
--========================= 定制标签=======================================
--==================================================================================================


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}
-- #+END_EXAMPLE
-- 现在我们可以改变每个标签的名字，并为每一个设置默认布局。参考下面这段代码：
 -- {{{ Tags
 -- Define a tag table which will hold all screen tags.
 tags = {
   names  = { "➊", "➋", "➌", "➍" , "5", "6", "7", "8", "9" },
   layout = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1],
              layouts[1], layouts[1], layouts[1], layouts[1]
 }}
 for s = 1, screen.count() do
     -- Each screen has its own tag table.
     tags[s] = awful.tag(tags.names, s, tags.layout)
 end
 -- }}}




-- 设置屏幕布局
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- awful.tag({ "➊", "➋", "➌", "➍" , "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    awful.tag({ "Browser", "code", "Term", "File" , "Chat", "Video", "ﱘMusic", "Graphic", "Game" }, s, awful.layout.layouts[1])

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
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}



-- <span style="font-size:18px;">
autorun = true
autorunApps =
{
    "nm-applet &",
    "blueman-applet  &",
    "xscreensaver  -no-splash &",
    "redshift-gtk  &",
    "picom --experimental-backends -b",
    "feh --recursive --randomize --bg-fill /home/jack/图片/Wallpapers/",
    "nohup  flameshot >/dev/null 2>&1 &",
    "dunst &",
    "copyq &",
    "fcitx &",
    "fcitx5 &",
    --  yinpin
    "nohup pasystray  >/dev/null 2>&1 &",
    "nohup kmix   >/dev/null 2>&1 &",
    "nohup /foo/bar/bin/pa-applet   >/dev/null 2>&1 &",
    "nohup mictray   >/dev/null 2>&1 &",
    "gnome-settings-daemon"
}

if autorun then
    for app = 1, #autorunApps do
        awful.util.spawn_with_shell(autorunApps[app])
    end
end
-- </span>

-- ============================================================================================================
---- 设置快捷键
-- ============================================================================================================

-- {{{ Mouse bindings
-- 设置全局鼠标操作
-- 全局鼠标操作是在root窗口进行鼠标操作时触发的操作，awesome不带任何参数调用对应的函数。
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


-- 设置全局快捷
-- 全局快捷键在任何情况下都可触发，当触发全局快捷键的函数时，awesome并不会传递任何参数
-- {{{ Key bindings
globalkeys = gears.table.join(
    --
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    --  查看前一个tag  切换标签  Mod4 + Left
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    --  查看后一个tag   Mod4 + Right
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    -- Mod4 + Esc 快速切换到上一个桌面
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    -- 切换至下一窗口 Mod4 + j    切换到其它窗口
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    --  切换至上一窗口 Mod4 + k
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    --  在两个窗口间切换  Mod4 + Tab
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    -- 在两个窗口间切换  alt + tab  把Alt+Tab绑定到切换至前一个窗口：
    awful.key({ "Mod1", }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    -- 打开菜单 mod4 + w
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    --  将当前窗口与下一窗口互换位置  Mod4 + Shift + j
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    -- 将当前窗口与上一窗口互换位置  Mod4 + Shift + k
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    --  切换到下一个xianshiqi屏幕  Mod4 + Control + j
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    --  切换到上一个xianshiqi屏幕 Mod4 + Control + k
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    --
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- Standard program
    --  打开终端  mod4 + enter
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    --  重启awesome  mod4 + ctrl + r
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    -- 退出awesome  mod4 + Control + e
    awful.key({ modkey, "Control" }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    --  Mod4 + l增加窗口大小   调整当前窗口大小
    awful.key({ modkey,           }, "XK_equal",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    -- 减小窗口大小 Mod4 + h
    awful.key({ modkey,           }, "-",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    --  减少主窗口个数 Mod4 + Shift + h
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    --  增加主窗口个数 Mod4 + Shift + l
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),

    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    --   切换窗口布局  比如水平布局下，新开窗口与原窗口水平分割桌面  mod4 + space
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    --  反向更改桌面布局  mod4 + shift + space
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    -- 窗口最小化还原  Mod4 + Ctrl + n
    awful.key({ modkey, "Control" }, "n",
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

    -- Prompt
    --	mod4 + r  打开程序或命令
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    --  mod4 + x 执行lua代码
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),


    -- 亮度/音量快捷键
    awful.key({}, "XF86MonBrightnessUp", function() os.execute("xbacklight -inc 5") end,
              {description = "+5%", group = "hotkeys"}),
    awful.key({}, "XF86MonBrightnessDown", function() os.execute("xbacklight -dec 5") end,
              {description = "-5%", group = "hotkeys"}),
    awful.key({}, "XF86AudioRaiseVolume", function() os.execute("amixer set Master 5%+") end,
              {description = "volume up", group = "hotkeys"}),
    awful.key({}, "XF86AudioLowerVolume", function() os.execute("amixer set Master 5%-") end,
              {description = "volume down", group = "hotkeys"}),
    awful.key({}, "XF86AudioMute", function() os.execute("amixer -D pulse set Master 1+ toggle") end,
              {description = "toggle mute", group = "hotkeys"}),
    -- 截图快捷键
    awful.key({}, "Print", function() awful.spawn.with_shell("flameshot gui -p  $(xdg-user-dir PICTURES) -d 2000 ") end,
              {description = "take a screenshot", group = "hotkeys"}),
    -- 文件管理器
    awful.key({ modkey }, "t", function() awful.spawn.with_shell("thunar /home/jack/") end,
              {description = "open file manager", group = "hotkeys"}),
    -- dmenu程序启动器
    awful.key({ modkey }, "d", function() awful.spawn.with_shell("dmenu_run") end,
              {description = "dmenu程序启动器", group = "hotkeys"}),
    -- rofi程序启动器
    awful.key({ modkey }, "r", function() awful.spawn.with_shell("rofi  -show combi") end,
              {description = "rofi程序启动器", group = "hotkeys"}),

    -- goolel
    awful.key({ modkey }, "g", function() awful.spawn.with_shell("google-chrome-stable") end,
              {description = "google  Browser", group = "hotkeys"})

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
    --  切换当前窗口是否为浮动     Mod4 + Ctrl + Space
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    --  标记窗口（可标记多个）Mod4 + t
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    --  窗口最小化	Mod4 + n
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    -- 窗口最大化  Mod4+m
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
        {description = "(un)maximize horizontally", group = "client"})
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
        --  mod4 + ctrl + num 将另一桌面的内容显示至当前桌面   把当前桌面和1~9桌面是显示
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
        -- mod4+shift+1-9  把当前窗口发送到其它工作区   发送客户点到标签tag
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

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
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
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
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
-- }}}
