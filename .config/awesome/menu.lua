menbrow = {
	{ "Iron+plug" , "/home/janek/bin/iron/iron" , "/home/janek/bin/iron/product_logo_48.png" },
	{ "Opera"    , "opera"  , "/usr/share/icons/black-white_2-Style/scalable/apps/256/opera.png" },
	{ "Midori"   , "midori" , "/usr/share/icons/hicolor/24x24/apps/midori.png" },
	{ "Chromium" , "/usr/bin/chromium --disable-plugins" , "/home/janek/.config/cairo-dock/misc-nice-icons/chromium.png" },
	{ "Chromium+plug" , "/usr/bin/chromium" , "/home/janek/.config/cairo-dock/misc-nice-icons/chromium.png" },
	{ "FireFox"  , "firefox" , "/usr/share/icons/black-white_2-Style/scalable/apps/256/firefox.png" },
	{ "luakit"    , "luakit" } 
}

menedit = {
	{ "kate"     , "/usr/bin/kate" },
	{ "gvim"     , "gvim", "/usr/share/pixmaps/gvim.xpm" },
	{ "vim @term"      , terminal .. " -e vim" },
	{ "bluefish" , "bluefish" },
	{ "mousepad" , "mousepad" }
}

menmisc = {
	{ "Muz-aurel @t", terminal .. " -e /home/janek/.scripts/aurel_muza.sh" },
--	{ "Matlab", "env LIBXCB_ALLOW_SLOPPY_LOCK=1 urxvt -e \"/home/janek/bin/matlab\"",
--					"/usr/kde/3.5/share/icons/hicolor/32x32/apps/koctave3.png" },
	{ "VYM"  , "vym", "/usr/share/vym/icons/vym-16x16.png"}
}

menirc = {
	{ "Skype" , "skype" },
	{ "EKG"   , terminal .. " -e uekg"}
}

menmedia = {
	{ "QMPDClient", "qmpdclient"},
	{ "ncmpcpp @t" , terminal .. " -e ncmpcpp"},
	{ "vlc"     , "vlc" },
	{ "mplayer"  , "smplayer" },
	{ "aqualung" , "aqualung" },
	{ "cmus @term" , terminal .. " -e cmus" },
	{ "xvid.oser.th." , "xvst" }
}

menoffice = {
	{ "OO Writer"  , "oowriter"  },
	{ "OO Calc"    , "oocalc"    },
	{ "OO Impress" , "ooimpress" },
	{ "Lyx"        , "lyx"       },
	{ "Evince"     , "evince"    },
	{ "Dia"        , "dia"       }
}

menfile = {
	{ "Krusader"  , "krusader"},
	{ "Thunar"    , "Thunar" },
	{ "mc @term"        , terminal .. " -e mc" }
}

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "QUIT", awesome.quit }
}
