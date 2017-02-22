--require('strict') -- [farhaven] strict checking for unassigned variables, like perl's use strict;
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- needed for awesome-client to work
require("awful.remote")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

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
theme_path = os.getenv( "HOME" ) .. "/.config/awesome/theme.lua"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
terminalb = "urxvt -name urxb"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
terminal_run = terminal .. " -e "


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,		-- 1
     -- ^^ the "classic" model
    awful.layout.suit.tile,		-- 2
    awful.layout.suit.tile.left,	-- 3
    awful.layout.suit.tile.bottom,	-- 4
    awful.layout.suit.tile.top,		-- 5
    awful.layout.suit.spiral,		-- 6
    awful.layout.suit.spiral.dwindle	-- 7
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- Define if we want to use titlebar on all applications.
titlebars_all = false

-- XXXX BAD:-- MYMOD: Titlebar properties for floating apps
--flotitles = { use = true, size = 14, pos = "top" }

-- MYMOD: Titlebar properties set per app
apptitles = 
{
	["urxvt"]            = { size = 12, position = "right" },
-- NIE na rady (brak class/	["VLC media player"] = { size = 14, position = "top"   },
}


-- {{{ Tags
-- Define tags table.
gold_ratio = 0.6180339
function gen_tagnames( change_font )
    return { "⋰➊⋱",  --"⋰➊✍⋱", --1
	     "⋰➋" .. ( change_font and "<span font_desc='Fixed 8'>" or "" ) 
                .. ".web" .. ( change_font and "</span>" or "" ) .. "⋱", --2
	     "⋰➌" .. ( change_font and "<span color='#7f5f2f' font_desc='Fixed 9'>" or "" )
                .. "⠠⠵" .. ( change_font and "</span>" or "" ) .. "⋱", --3
	     "⋰➍" .. ( change_font and "<span font_desc='Fixed 8'>" or "" )
                .. ".dev" .. ( change_font and "</span>" or "" ) .. "⋱", --4
             "⋰➎⋱", --5 
	     "⋰➏⋱" } --6
end

-- !!! ZMIANA FONTU MOŻLIWA TYLKO PO EDYCJI
-- PLIKU 	/usr/share/awesome/lib/awful/widget/taglist.lua (dla wersji 3.3.1)
-- LUB		/usr/share/awesome/lib/awful/widget.lua 	(dla wersji 3.2.1-r3)
-- !!!
--tags_name   = { "➊", "➋⋮@", "➌⋮⠠⠵",

tags_name = gen_tagnames( false )
tags_layout = {  1 , 1 , 2 , 1 , 1 , 1 }
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags_name, s)
    --for tagnumber, tagname in ipairs(tags_name) do
    for tagnumber = 1, #tags[s] do
        awful.layout.set(layouts[tags_layout[tagnumber]], tags[s][tagnumber])
        tags[s][tagnumber].mwfact = gold_ratio
    end
end
    
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

dofile( os.getenv( "HOME" ) .. "/.config/awesome/menu.lua" )
mymainmenu = awful.menu({ items = { 
		  { ":browsers:" , menbrow },
		  { ":editors:"  , menedit },
		  { ":fileUtil:" , menfile },
		  { ":dev: "     , mendev },
		  { ":media:"    , menmedia },
		  { ":misc:"     , menmisc },
		  { ":im/irc:"   , menirc },
		  { ":office:"   , menoffice },
		  { ":awesome:"  , myawesomemenu, beautiful.awesome_icon }
		}
	       })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

ThinkVantageMenuItems = {}
function add_TVantageMenuItem( TVitem )
    local termSTART      = "urxvt -name urxCmd -e sh -c \""
    local scriptSTART    = "su -c \\\"/etc/init.d/"
    local scriptEND      = " start\\\"; "
    local termEND        = "[ $? -eq 0 ] &&" 
                        .. " (echo Zamkniecie okna za 1 sek; sleep 1) ||"
                        .. " (echo Wcisnij ENTER by zamknac okno; read) \""

    --[[ TODO
    -- dorobić util.escape do przetwarzania parametrów "fg" i "bg"
    --]]
    table.insert( ThinkVantageMenuItems ,
        { TVitem[1] ,
            termSTART 
            .. scriptSTART .. TVitem[1] .. scriptEND 
            .. ( TVitem.bg and " nohup sh -c \\\"" .. TVitem.bg .. "\\\" &>/dev/null & " or "" )
            .. ( TVitem.fg or "" )
            .. termEND 
        })
end
                                     
add_TVantageMenuItem( { "wicd" , bg = "pgrep wicd && ( pgrep wicd-client || wicd-client )" } )
add_TVantageMenuItem( { "net.eth0"   } )
add_TVantageMenuItem( { "tor"        } )
add_TVantageMenuItem( { "cupsd"      } )
add_TVantageMenuItem( { "sshd"       } )

myThinkVantageMenu = awful.menu({ items = ThinkVantageMenuItems })



-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()


mytextbox = wibox.widget.textbox()
mytextbox:set_text(awesome.release)
--mytextbox:set_font("-*-neep-medium-*-*-*-8-*-*-*-*-*-iso8859-2")

-- require( os.getenv( "HOME" ) .. "/.config/awesome/rooty.lua")
require("rooty")

ntop_graphs = {
    through = { base = "action=arbreq&which=graph&arbfile=throughput&end=now&arbiface=",
        iface = "eth0",
        since = 20, -- in minutes
        postproc = "| convert - -crop 575x185+8+8 -depth 3 -negate -transparent '#000000' " },
        history = { base = "action=graphSummary&graphId=4&end=now&key=interfaces/",
        iface = "eth0",
        since = 40,
        postproc = "| convert - -crop 471x134+8+22 -depth 3 -negate -transparent '#000000' " }
}

function make_cmd(graph, args)
    local cmd 
    cmd = "curl -s -m"
     .. (args.timeout or 1)
     .. " 'http://"
     .. (args.host or "127.0.0.1") .. ":"
     .. (args.port or 3000)
     .. "/plugins/rrdPlugin?" .. graph.base
     .. (args.iface or graph.iface)
     .. "&start=now-"
     .. (args.since or graph.since) .. "min' "
     .. (args.postproc or graph.postproc) .. " "
    return cmd
end


pogoda = {
    zkiedy = --string.match(
            --awful.util.pread("curl -s -m7 'http://new.meteo.pl/info_um.php'"),
	    --"2009...... [0-2][0268]") 
	    --or
            os.date("%Y.%m.%d", os.time() - 24*3600) .. " 06",

    prodcmd = function()
        return "curl -s -m10 'http://new.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate="
            .. string.gsub(pogoda.zkiedy, "[ .]", "") .. "&row=345&col=208&lang=pl' "
            .. "| convert - -crop 525x370+0+27 -depth 4 -negate -matte -fill '#00000080' "
            .. "-draw 'matte 30,20 reset' -transparent '#00001180' "
    end,
    update = function()
	local last = pogoda.zkiedy -- to ignore if could not connect!
            last = string.match(
	    awful.util.pread("curl -s -m10 'http://new.meteo.pl/info_um.php'"),
	    "2009...... [0-2][0268]") 
            if last ~= pogoda.zkiedy then
            pogoda.zkiedy = last
            rooty2.cmd[1] = pogoda:prodcmd()
            rooty.update(rooty2)
            naughty.notify( { text = "Jest nowa prognoza - z " .. last, timeout = 13 } )
--        else
--        naughty.notify( { text = "brak nowych prognoz", title = "Tralala", timeout = 11 } )

        end
    end,
        fragm = { nagl = {27,54}, temp = {54,138}, opad = {138,225}, cisn = {225,310},
        wiatrpr = {310,396}, wiatrk = {396,431}, widz = {431,518}, zachm = {518,617} }
    }

--rooty1 = rooty.new({ 
--        make_cmd(ntop_graphs.through, {} ),
--        make_cmd(ntop_graphs.history, {} )
--        },
--        2, -- posx
--        21 ) --posy

---- rooty2 = rooty.new(
--      { pogoda:prodcmd() },
--{ "curl -s -m10 'http://new.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate="
--	    .. os.date("+%Y%m%d") - 1 .. "12&row=345&col=208&lang=pl' "
--	    .. "| convert - -crop 525x370+0+27 -depth 4 -negate -matte -fill '#00000080' "
--	    .. "-draw 'matte 30,20 reset' -transparent '#00001180' " },
----	5, 390)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
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
--OLD    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
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
--OLD    mytasklist[s] = awful.widget.tasklist(function(c)
--OLD                                              return awful.widget.tasklist.label.currenttags(c, s)
--OLD                                          end, mytasklist.buttons)
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray())
    else right_layout:add(mytextbox) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
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
--hist_preserved = {}globalkeys = awful.util.table.join(
--- takie tam...    awful.key({ modkey }, "e",  revelation.revelation),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ "Mod1", "Control" }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ "Mod1", "Control" }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "F9",
      -- Try to imitate "widget layer"... Being an empty desktop!
      function()
            if awful.tag.selected() then
                awful.tag.viewnone()
            else
                awful.tag.history.restore()
            end
        end),
--	    if hist_preserved == {} then
--	        hist_preserved = awful.tag.selectedlist()
--		awful.tag.history.restore()
--		-- hist_preserved.prev = awful.tag.selectedlist(mouse.screen)
--                awful.tag.viewnone()
--	    else
--               -- awful.tag.viewmore( hist_preserved.prev )
--               -- awful.tag.viewmore( hist_preserved.cur )
--		awful.tag.history.restore()
--		awful.tag.viewmore(hist_preserved)
--		awful.tag.history.restore()
--		hist_preserved = {}
--	    end
--        end),

    awful.key({ modkey,           }, "j",
        function ()
            local cg;
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
	    --tenc=client.focus
	    --awful.client.property.set(tenc, koordynaty, {x=30, y=222})
            cg=client.focus:geometry()
	    --mouse.coords({x=awful.client.property.get(tenc,koordynaty).x,
	    --		y=awful.client.property.get(tenc.koordynaty).y})
	    mouse.coords({ x=cg['x']+2, y=cg['y']+cg['height']/2 })
        end),
    awful.key({ modkey,           }, "k",
        function ()
            local cg;
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
            cg=client.focus:geometry()
            mouse.coords({ x=cg['x']+2, y=cg['y']+cg['height']/2 })
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true})        end),
--NEW    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ "Mod1",           }, "Tab",
        function ()
	    local cg;
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end 
	    cg = client.focus:geometry()
	    mouse.coords({ x=cg['x']+5, y=cg['y']+cg['height']/2 })
        end),

    -- Standard program
    awful.key({ "Mod1", "Control" }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminalb) end),
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

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ modkey, "Control", "Shift"}, "=",	
        function ()
            ntop_graphs.through.since = ntop_graphs.through.since * 2
            rooty1.cmd[1] = make_cmd(ntop_graphs.through, {} )
            rooty.update(rooty1)
	    naughty.notify( {text = "ntop throughput graph depth\n changed to " 
	        .. ntop_graphs.history.since .. " minutes", timeout = 4} )
	end),
    awful.key({ modkey, "Control", "Shift"}, "-",
        function ()
            ntop_graphs.through.since = math.max(ntop_graphs.through.since / 2 , 5)
            rooty1.cmd[1] = make_cmd(ntop_graphs.through, {} )
            rooty.update(rooty1)
	    naughty.notify( {text = "ntop throughput graph depth\n changed to " 
	        .. ntop_graphs.history.since .. " minutes", timeout = 4} )
	end),
    awful.key({ modkey, "Control"}, "=",	
        function ()
            ntop_graphs.history.since = ntop_graphs.history.since * 2
            rooty1.cmd[2] = make_cmd(ntop_graphs.history , {} )
            rooty.update(rooty1)
	    naughty.notify( {text = "ntop history graph depth\n changed to " 
	        .. ntop_graphs.history.since .. " minutes", timeout = 4} )
	end),
    awful.key({ modkey, "Control"}, "-",
        function ()
            ntop_graphs.history.since = math.max(ntop_graphs.history.since / 2 , 5)
            rooty1.cmd[2] = make_cmd(ntop_graphs.history , {} )
            rooty.update(rooty1)
	    naughty.notify( {text = "ntop history graph depth\n changed to " 
	        .. ntop_graphs.history.since ..  " minutes", timeout = 4} )
	end),
    awful.key({ modkey, "Control"}, "i",
        function ()
            if ntop_graphs.history.iface == "eth0" then
                ntop_graphs.history.iface = "ath0"
                ntop_graphs.through.iface = "ath0"
		naughty.notify( {text = "ntop graphs showing\n interface ath0", timeout=11} )
            else
                ntop_graphs.through.iface = "eth0"
                ntop_graphs.history.iface = "eth0"
		naughty.notify( {text = "ntop graphs showing\n interface eth0", timeout=11} )
            end
            rooty1.cmd[1] = make_cmd(ntop_graphs.through , {} )
            rooty1.cmd[2] = make_cmd(ntop_graphs.history , {} )
            rooty.update(rooty1)
        end),
    awful.key({ modkey, "Control"}, "p",
        function ()
            pogoda:update()
        end)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    -- + close window using classic Alt+F4
    awful.key({ "Mod1"            }, "F4",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey 	          }, "g",      function (c) awful.placement.under_mouse(c)   end),
    awful.key({ modkey, "Shift"   }, "g",      function (c) awful.placement.under_mouse(c)
    							    awful.placement.no_offscreen(c)    end),
    awful.key({ modkey }, "t", awful.client.togglemarked),
    awful.key({ modkey, "Shift" }, "t",	 
    	function (c) 
		if c.titlebar then 
			awful.titlebar.remove(c) 
		else 
			local target
			target = apptitles[c.class] or apptitles[c.instance] or { size = 14, position = "right" }
			awful.titlebar.add(c, { modkey = modkey,
			width = target.size,
			height = target.size,
			position = target.position })
			-- XXX NIE TAK..:
        		-- awful.placement.no_offscreen(c)
		end 
	end), 

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    --------------- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    awful.key({ modkey }, "Tab", function ()
     -- If you want to always position the menu on the same place set coordinates
        awful.menu.menu_keys.down = { "Down", "Tab" }
        ---awful.menu.menu_keys.exec = { odkey }
        local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=525, y=330} })
        end),
    --------------- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
            -- View tag only.
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
                  {description = "toggle focused client on tag #" .. i, group = "tag"}),
        awful.key({ modkey, "Shift" }, "F" .. i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          for k, c in pairs(awful.client.getmarked()) do
                              awful.client.movetotag(tags[screen][i], c)
                          end
                      end
                   end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    --MYMOD:
	awful.button({ "Mod1" }, 1, awful.mouse.client.move),
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
                     buttons = clientbuttons },
--XXX mialo otwierac nowe okna zawsze na bieżącym tagu, ale nie działa
--      callback = function(c)
--            c.screen = mouse.screen
--            c:tags({ awful.tag.selected(mouse.screen) }) 
--            end
                 },
    { rule = { class = "MPlayer" },
               properties = { floating = true } },
    { rule = { class = "Wicd-client.py" },
               properties = { floating = true } },
--    { rule = { instance = "kate" },
--      properties = { tag = tags[1][1] } },
    { rule = { class = "OpenOffice.org 3.2" },
               properties = { tag = tags[1][1] } },
    { rule = { instance = "opera" },
               properties = { tag = tags[1][2] } },
    { rule = { class = "Firefox" },
               properties = { tag = tags[1][2] } },
    { rule = { class = "chromium-browser" },
               properties = { tag = tags[1][2] } },
    { rule = { class = "luakit" },
               properties = { tag = tags[1][2] } },
    { rule = { instance = "midori" },
               properties = { tag = tags[1][2] } },
    { rule = { instance = "urxb" },
               callback = function(c)
                   c.screen = mouse.screen
                   c:tags({ tags[c.screen][3] })
               end},
    { rule = { instance = "urxCmd" },
            properties =  { floating = true } },
    { rule = { class = "gimp" },
            properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "Adl" },
               properties = { floating = true } },
    { rule = { class = "Eclipse" },
               properties = { tag = tags[1][4] } },
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


-- AUTOSTART ------------
--  => [Ogolnie autostart powinien byc raczej u uzytkownika...]
os.execute( "pgrep conky &>/dev/null || conky -d -c ~/.conkyrc-awesome &" )
os.execute( "pgrep xfsettings &>/dev/null || /usr/bin/xfsettingsd" )
-- os.execute( "pgrep xcompmgr || /usr/local/bin/xcompmgr_MY2 -C -c -r2 &" )
-- os.execute( "pgrep xcompmgr || xcompmgr -c -C -n &" )
os.execute( "/usr/bin/xsetroot -cursor_name arrow &" ) -- circle &" )
os.execute( "pgrep wicd && ( pgrep wicd-client || wicd-client ) &" )
