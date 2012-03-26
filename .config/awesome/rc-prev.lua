-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- my root images drawing lib
--------------------------------------CHUJ!!! require("rooty")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
--theme_path = "/usr/share/awesome/themes/my1/theme.lua"
theme_path = os.getenv( "HOME" ) .. "/.config/awesome/theme.lua"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/share/awesome/themes/sky/theme.lua"

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
     -- ^^git! (klasyczny :D)
    awful.layout.suit.tile.top,		-- 2
    awful.layout.suit.tile.bottom,	-- 3
    awful.layout.suit.tile,		-- 4
    awful.layout.suit.tile.left,	-- 5
    awful.layout.suit.fair,		-- 6
    awful.layout.suit.fair.horizontal,	-- 7
    awful.layout.suit.spiral,		-- 8
    awful.layout.suit.spiral.dwindle	-- 9
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
--    ["MPlayer"] = true,
--    ["pinentry"] = true,
--    ["gimp"] = true,
    -- by instance
    ["mocp"] = true,
    ["ida"] = true
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


-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    -- ["Conky"] = { screen = 1, tag = 9 }
    --
    ["kate"] 	= { screen = 1, tag = 1 },
    ["opera"] 	= { screen = 1, tag = 2 },
    ["chrome"] 	= { screen = 1, tag = 2 },
    ["midori"] 	= { screen = 1, tag = 2 },
    ["gecko"] 	= { screen = 1, tag = 2 },	-- ("gecko", "Firefox-bin") -> Firefox
    ["urxb"] 	= { screen = 1, tag = 3 },
    ["MATLAB"]	= { screen = 1, tag = 4 },
    ["com.mathworks.mde.desk.MLMainFrame"] = { screen = 1, tag = 4 }, -- Matlab - okno gl.
    ["matlab"]	= { screen = 1, tag = 4 },
    -- !! Tu można dać widzety - na przykład tak:
    ["WIDGEee"]	= { screen = 1, tag = 6 }	-- widzety wszystkie (NA PRZYSZLOSC TEZ!)
}
-- }}}

-- {{{ Tags
-- Define tags table.
gold_ratio = 0.6180339
-- !!! ZMIANA FONTU MOŻLIWA TYLKO PO EDYCJI
-- PLIKU 	/usr/share/awesome/lib/awful/widget/taglist.lua (dla wersji 3.3.1)
-- LUB		/usr/share/awesome/lib/awful/widget.lua 	(dla wersji 3.2.1-r3)
-- !!!
--tags_name   = { "➊", "➋⋮@", "➌⋮⠠⠵",
tags_name   = { "⋰➊✍⋱", --1
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
    tags[s] = {}
    for tagnumber, tagname in ipairs(tags_name) do
        tags[s][tagnumber] = tag(tagnumber)
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
        tags[s][tagnumber].name = tagname
        awful.layout.set(layouts[tags_layout[tagnumber]], tags[s][tagnumber])
        tags[s][tagnumber].mwfact = gold_ratio
    end
    tags[s][1].selected = true
end
    
-- OGIGINAL BELOW
--tags = {}
--for s = 1, screen.count() do
--    -- Each screen has its own tag table.
--    tags[s] = {}
--    -- Create 9 tags per screen.
--    for tagnumber = 1, 9 do
--        tags[s][tagnumber] = tag(tagnumber)
--        -- Add tags to screen one by one
--        tags[s][tagnumber].screen = s
--        awful.layout.set(layouts[1], tags[s][tagnumber])
--    end
--    -- I'm sure you want to see at least one tag.
--    tags[s][1].selected = true
--end
-- }}}

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
mymainmenu = awful.menu.new({ items = { 
		  { "open terminal", terminal },
		  { "opera"   , "opera" },
		  { " :browsers:" , menbrow },
		  { " :editors:"  , menedit },
		  { " :fileUtil:" , menfile },
		  { " :media:"    , menmedia },
		  { " :misc:"     , menmisc },
		  { " :im/irc:"   , menirc },
		  { " :office:"   , menoffice },
		  { " :awesome:"  , myawesomemenu, beautiful.awesome_icon }
		}
	       })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Create a systray
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
	    awful.util.pread("curl -s -m7 'http://new.meteo.pl/info_um.php'"),
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

rooty1 = rooty.new({ 
        make_cmd(ntop_graphs.through, {} ),
        make_cmd(ntop_graphs.history, {} )
        },
        2, -- posx
	21 ) --posy

rooty2 = rooty.new(
        { pogoda:prodcmd() },
--{ "curl -s -m10 'http://new.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate="
--	    .. os.date("+%Y%m%d") - 1 .. "12&row=345&col=208&lang=pl' "
--            .. "| convert - -crop 525x370+0+27 -depth 4 -negate -matte -fill '#00000080' "
--	    .. "-draw 'matte 30,20 reset' -transparent '#00001180' " },
	5, 390)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, function (tag) tag.selected = not tag.selected end),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.border_width = 1
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
                                                  instance = awful.menu.clients({ width=260 })
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
    mypromptbox[s] = awful.widget.prompt({ align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
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
    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mylauncher,
                           mytaglist[s],
                           mytasklist[s],
                           mypromptbox[s],
                           mylayoutbox[s],
                           mytextbox,
                           s == 1 and mysystray or nil }
    mywibox[s].screen = s

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
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus( 1)       end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus(-1)       end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
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
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle  ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey 	          }, "g",      function (c) awful.placement.under_mouse(c)   end),
    awful.key({ modkey, "Shift"   }, "g",      function (c) awful.placement.under_mouse(c)
    							    awful.placement.no_overlap(c)    end),
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
                          tags[screen][i].selected = not tags[screen][i].selected
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

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    local cls = c.class
    local inst = c.instance
    
    -- Add a titlebar
    if titlebars_all then
        awful.titlebar.add(c, { modkey = modkey, width = "14", position = "right"})
    end
    
    local titlesp
    titlesp = apptitles[cls] or apptitles[inst]
    if titlesp and awful.layout.get(c.screen) == awful.layout.suit.floating then
	   -- XXX! usunac konflikt z titlebars_all
        awful.titlebar.add(c, 
	    { modkey = modkey,
	    width = titlesp.size,
	    height = titlesp.size,
	    position = titlesp.position})
    end
-- NIE DZIAŁA
--    if flotitles.use and awful.client.property.get(c, "floating") then
--	    	    --  ^^ co innego, niż awful.client.floating.get(c) !!
--		    --  (drugie uwzględnia zmaksymalizowane i pełnoekranowe)
--	    awful.titlebar.add(c, 
--	        { modkey = modkey, 
--		position = flotitles.pos,
--		width = flotitles.size,
--		height = flotitles.size})
--    end

    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
        -- MYMOD: floating windows under mouse, but within visible area.. 
        if awful.client.floating.get(c) or awful.layout.get(c.screen) == awful.layout.suit.floating then
            awful.placement.under_mouse(c)
        end
        -- (not covering wibox either)
        awful.placement.no_offscreen(c)
    end

    -- Add mouse bindings
    c:buttons(awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ "Mod1" }, 1, awful.mouse.client.move),
        awful.button({ "Mod1" }, 3, awful.mouse.client.resize),
        awful.button({ modkey }, 3, awful.mouse.client.resize)
	-- MYMOD: dodano opcję z Altem ("Mod1")
    ))

    -- Check if the application should be floating.
    if floatapps[cls] ~= nil then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] ~= nil then
        awful.client.floating.set(c, floatapps[inst])
    end

    -- Check application->screen/tag mappings.
    local target
    target = apptags[cls] or apptags[inst]
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
-- DUUUPA!! --
--    if not c.maximized_vertical and not c.maximized_vertical and not c.fullscreen then
        c.border_width = beautiful.border_width
	c.border_color = beautiful.border_normal
--    end

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c

    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.size_hints_honor = false

end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Hook called every minute
awful.hooks.timer.register(60, function ()
    -- MYMOD: data po polsku :) [nie działa bez '.UTF-8']
    os.setlocale('pl_PL.UTF-8')
    mytextbox.text = os.date(" %a %d %b, %H:%M ")
end)

-- lastweather={ day = os.date(
awful.hooks.timer.register(28, function ()
    rooty.update(rooty1)
    collectgarbage("collect")
--    naughty.notify({text=#rooty1.cmd[1], timeout = 15})
end)

awful.hooks.timer.register(800, function ()
    pogoda:update()
end)

-- }}}


-- AUTOSTART ------------
--  => [Ogolnie autostart powinien byc raczej u uzytkownika...]
os.execute( "pgrep conky || conky -d -c ~/.conkyrc-awesome &" )
-- os.execute( "pgrep xcompmgr || /usr/local/bin/xcompmgr_MY2 -C -c -r2 &" )
-- os.execute( "pgrep xcompmgr || xcompmgr -c -C -n &" )
os.execute( "/usr/bin/xsetroot -cursor_name arrow &" ) -- circle &" )
os.execute( "pgrep wicd && ( pgrep wicd-client || wicd-client ) &" )
