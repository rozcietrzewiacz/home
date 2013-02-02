--require('strict') -- [farhaven] strict checking for unassigned variables, like perl's use strict;
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")


-- Takie słabe a'la Expose require("revelation")

-- {{{ Variable definitions
theme_path = os.getenv( "HOME" ) .. "/.config/awesome/theme.lua"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
terminalb = "urxvt -name urxb"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
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
-- !!! ZMIANA FONTU MOŻLIWA TYLKO PO EDYCJI
-- PLIKU 	/usr/share/awesome/lib/awful/widget/taglist.lua (dla wersji 3.3.1)
-- LUB		/usr/share/awesome/lib/awful/widget.lua 	(dla wersji 3.2.1-r3)
-- !!!
--tags_name   = { "➊", "➋⋮@", "➌⋮⠠⠵",
tags_name   = { "⋰➊⋱",  --"⋰➊✍⋱", --1
		    "⋰➋<span font_desc='Fixed 8'>.web</span>⋱", --2
		        "⋰➌<span color='#7f5f2f' font_desc='Fixed 9'>⠠⠵</span>⋱", --3
			    "⋰➍<span font_desc='Fixed 8'>.dev</span>⋱", --4
			        "⋰➎⋱", --5 
				    "⋰➏⋱" } --6
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
    
-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. awesome.release .. " </small></b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

dofile( os.getenv( "HOME" ) .. "/.config/awesome/menu.lua" )
mymainmenu = awful.menu({ items = { 
		  { " :browsers:" , menbrow },
		  { " :editors:"  , menedit },
		  { " :fileUtil:" , menfile },
		  { " :dev: "     , mendev },
		  { " :media:"    , menmedia },
		  { " :misc:"     , menmisc },
		  { " :im/irc:"   , menirc },
		  { " :office:"   , menoffice },
		  { " :awesome:"  , myawesomemenu, beautiful.awesome_icon }
		}
	       })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

-- Create a systray
-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

mysystray = widget({ type = "systray", align = "right" })


-- dofile( os.getenv( "HOME" ) .. "/.config/awesome/rooty.lua")
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
--            naughty.notify( { text = "brak nowych prognoz", title = "Tralala", timeout = 11 } )
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
--	21 ) --posy

---- rooty2 = rooty.new(
----       { pogoda:prodcmd() },
--{ "curl -s -m10 'http://new.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate="
--	    .. os.date("+%Y%m%d") - 1 .. "12&row=345&col=208&lang=pl' "
--            .. "| convert - -crop 525x370+0+27 -depth 4 -negate -matte -fill '#00000080' "
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
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
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
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
---- OLD    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == screen.count() and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
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
--hist_preserved = {}
globalkeys = awful.util.table.join(
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
	    mouse.coords({ x=cg['x']+2, y=cg['y']+cg['height']/2 })
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

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    -- OLD prompt binding:
    awful.key({ modkey },            "F1",     function () mypromptbox[mouse.screen]:run() end),

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
    awful.key({ modkey }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, i,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
			  -- MYMOD: przełącz tam, gdzie przeniosłeś
			  awful.tag.viewonly(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end),
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
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
               properties = { floating = true } },
--    { rule = { instance = "kate" },
--      properties = { tag = tags[1][1] } },
    { rule = { class = "OpenOffice.org 3.2" },
               properties = { tag = tags[1][1] } },
    { rule = { instance = "opera" },
               properties = { tag = tags[1][2] } },
    { rule = { class = "Firefox" },
               properties = { tag = tags[1][2] } },
    { rule = { instance = "chrome" },
               properties = { tag = tags[1][2] } },
    { rule = { instance = "iron" },
               properties = { tag = tags[1][2] } },
    { rule = { instance = "midori" },
               properties = { tag = tags[1][2] } },
    { rule = { instance = "urxb" },
               properties = { tag = tags[1][3] } },
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
-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
--floatapps =
--{
    -- by class
--    ["MPlayer"] = true,
--    ["pinentry"] = true,
--    ["gimp"] = true,
    -- by instance
--    ["mocp"] = true,
--    ["ida"] = true
--}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Intuitive initial position of a floating window
    awful.placement.under_mouse(c)
    awful.placement.no_offscreen(c)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
	--OLD:-- Hook function to execute when unmarking a client.
	--OLD:awful.hooks.unmarked.register(function (c)
	--OLD:    c.border_color = beautiful.border_focus
	--OLD:end)
	--OLD:
	--OLD:-- Hook function to execute when the mouse enters a client.
	--OLD:awful.hooks.mouse_enter.register(function (c)
	--OLD:    -- Sloppy focus, but disabled for magnifier layout
	--OLD:    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
	--OLD:        and awful.client.focus.filter(c) then
	--OLD:        client.focus = c
	--OLD:    end
	--OLD:end)
	--OLD:
	--OLD:-- Hook function to execute when a new client appears.
	--OLD:awful.hooks.manage.register(function (c, startup)
	--OLD:    local cls = c.class
	--OLD:    local inst = c.instance
	--OLD:    
	--OLD:    -- Add a titlebar
	--OLD:    if titlebars_all then
	--OLD:        awful.titlebar.add(c, { modkey = modkey, width = "14", position = "right"})
	--OLD:    end
	--OLD:    
	--OLD:    local titlesp
	--OLD:    titlesp = apptitles[cls] or apptitles[inst]
	--OLD:    if titlesp and awful.layout.get(c.screen) == awful.layout.suit.floating then
	--OLD:	   -- XXX! usunac konflikt z titlebars_all
	--OLD:        awful.titlebar.add(c, 
	--OLD:	    { modkey = modkey,
	--OLD:	    width = titlesp.size,
	--OLD:	    height = titlesp.size,
	--OLD:	    position = titlesp.position})
	--OLD:    end
	--OLD:-- NIE DZIAŁA
	--OLD:--    if flotitles.use and awful.client.property.get(c, "floating") then
	--OLD:--	    	    --  ^^ co innego, niż awful.client.floating.get(c) !!
	--OLD:--		    --  (drugie uwzględnia zmaksymalizowane i pełnoekranowe)
	--OLD:--	    awful.titlebar.add(c, 
	--OLD:--	        { modkey = modkey, 
	--OLD:--		position = flotitles.pos,
	--OLD:--		width = flotitles.size,
	--OLD:--		height = flotitles.size})
	--OLD:--    end
	--OLD:
	--OLD:    -- If we are not managing this application at startup,
	--OLD:    -- move it to the screen where the mouse is.
	--OLD:    -- We only do it for filtered windows (i.e. no dock, etc).
	--OLD:    if not startup and awful.client.focus.filter(c) then
	--OLD:        c.screen = mouse.screen
	--OLD:        -- MYMOD: floating windows under mouse, but within visible area.. 
	--OLD:        if awful.client.floating.get(c) or awful.layout.get(c.screen) == awful.layout.suit.floating then
	--OLD:            awful.placement.under_mouse(c)
        end
    end)
--OLD:    end
--OLD:
--OLD:    -- Add mouse bindings
--OLD:    c:buttons(awful.util.table.join(
--OLD:        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
--OLD:        awful.button({ modkey }, 1, awful.mouse.client.move),
--OLD:        awful.button({ "Mod1" }, 1, awful.mouse.client.move),
--OLD:        awful.button({ "Mod1" }, 3, awful.mouse.client.resize),
--OLD:        awful.button({ modkey }, 3, awful.mouse.client.resize)
--OLD:	-- MYMOD: dodano opcję z Altem ("Mod1")
--OLD:    ))
--OLD:
--OLD:    -- Check if the application should be floating.
--OLD:    if floatapps[cls] ~= nil then
--OLD:        awful.client.floating.set(c, floatapps[cls])
--OLD:    elseif floatapps[inst] ~= nil then
--OLD:        awful.client.floating.set(c, floatapps[inst])
--OLD:    end
--OLD:
--OLD:    -- Check application->screen/tag mappings.
--OLD:    local target
--OLD:    target = apptags[cls] or apptags[inst]
--OLD:    if target then
--OLD:        c.screen = target.screen
--OLD:        awful.client.movetotag(tags[target.screen][target.tag], c)
--OLD:    end
--OLD:
--OLD:    -- New client may not receive focus
--OLD:    -- if they're not focusable, so set border anyway.
--OLD:-- DUUUPA!! --
--OLD:--    if not c.maximized_vertical and not c.maximized_vertical and not c.fullscreen then
--OLD:        c.border_width = beautiful.border_width
--OLD:	c.border_color = beautiful.border_normal
--OLD:--    end
--OLD:
--OLD:    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
--OLD:    client.focus = c
--OLD:
--OLD:    -- Set key bindings
--OLD:    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)
--OLD:
--OLD:    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
--OLD:    -- c.size_hints_honor = false
--OLD:
--OLD:end)
--OLD:
--OLD:-- Hook function to execute when arranging the screen.
--OLD:-- (tag switch, new client, etc)
--OLD:awful.hooks.arrange.register(function (screen)
--OLD:    local layout = awful.layout.getname(awful.layout.get(screen))
--OLD:    if layout and beautiful["layout_" ..layout] then
--OLD:        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
--OLD:    else
--OLD:        mylayoutbox[screen].image = nil
--OLD:    end
--OLD:
--OLD:    -- Give focus to the latest client in history if no window has focus
--OLD:    -- or if the current window is a desktop or a dock one.
--OLD:    if not client.focus then
--OLD:        local c = awful.client.focus.history.get(screen, 0)
--OLD:        if c then client.focus = c end
--OLD:    end
--OLD:end)
--OLD:
--OLD:-- Hook called every minute
--OLD:awful.hooks.timer.register(60, function ()
--OLD:    -- MYMOD: data po polsku :) [nie działa bez '.UTF-8']
--OLD:    os.setlocale('pl_PL.UTF-8')
--OLD:    mytextbox.text = os.date(" %a %d %b, %H:%M ")
--OLD:end)
--OLD:
--OLD:-- lastweather={ day = os.date(
--OLD:awful.hooks.timer.register(28, function ()
--OLD:    rooty.update(rooty1)
--OLD:    collectgarbage("collect")
--OLD:--    naughty.notify({text=#rooty1.cmd[1], timeout = 15})
--OLD:end)
--OLD:
--OLD:awful.hooks.timer.register(800, function ()
--OLD:    pogoda:update()
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- AUTOSTART ------------
--  => [Ogolnie autostart powinien byc raczej u uzytkownika...]
os.execute( "pgrep conky &>/dev/null || conky -d -c ~/.conkyrc-awesome &" )
os.execute( "pgrep xfsettings &>/dev/null || /usr/bin/xfsettingsd" )
-- os.execute( "pgrep xcompmgr || /usr/local/bin/xcompmgr_MY2 -C -c -r2 &" )
-- os.execute( "pgrep xcompmgr || xcompmgr -c -C -n &" )
os.execute( "/usr/bin/xsetroot -cursor_name arrow &" ) -- circle &" )
os.execute( "pgrep wicd && ( pgrep wicd-client || wicd-client ) &" )
