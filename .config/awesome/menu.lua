menbrow = {
        { "firefox"   , "firefox", "/usr/share/icons/hicolor/24x24/apps/firefox.png" },
--	{ "Chromium+plug" , "/usr/bin/chromium" , "/home/michal/.config/cairo-dock/misc-nice-icons/chromium.png" },
--	{ "Midori"   , "midori" , "/usr/share/icons/hicolor/24x24/apps/midori.png" },
--	{ "Iron+plug" , "/home/michal/bin/iron/iron" , "/home/michal/bin/iron/product_logo_48.png" },
        { "luakit"    , "luakit" }, 
--	{ "Opera-Beta"    , "opera-beta"  , "/usr/share/icons/hicolor/128x128/apps/opera-beta.png" },
--	{ "Chromium" , "/usr/bin/chromium --disable-plugins" , "/home/michal/.config/cairo-dock/misc-nice-icons/chromium.png" },
}

menedit = {
	{ "gvim"     , "gvim", "/usr/share/pixmaps/gvim.xpm" },
	{ "leafpad" , "leafpad", "/usr/share/icons/hicolor/24x24/apps/leafpad.png" },
	{ "vim @term"      , terminal .. " -e vim" },
--	{ "kate"     , "/usr/bin/kate" }
}

mendev = {
        { "eclipse",    "eclipse-3.7",  "/usr/lib/eclipse-3.7/icon.xpm" },
        { "CrossStudio", "/opt/crossworks_for_arm_3.0/bin/crossstudio", "/opt/crossworks_for_arm_3.0/bin/CrossWorksIcon48x48.png" }
}

menmisc = {
	{ "Muz-aurel @t", terminal .. " -e /home/michal/.scripts/aurel_muza.sh" },
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
	{ "cmus @term" , terminal .. " -e cmus" }
}

menoffice = {
	{ "Evince"     , "evince"    },
	{ "Xsane"      , "xsane"     },
	{ "LO Writer"  , "lowriter"  },
	{ "LO Calc"    , "localc"    },
--	{ "LO Impress" , "loimpress" },
	{ "Dia"        , "dia"       }
}

menfile = {
	{ "SpaceFM"    , "spacefm", "/usr/share/icons/hicolor/48x48/apps/spacefm.png" },
        { "Thunar"     , "Thunar" , "/usr/share/icons/hicolor/48x48/apps/Thunar.png" },
	{ "mc @term"        , terminal .. " -e mc" }
}

myawesomemenu = {
   { "restart", awesome.restart },
   { "QUIT", awesome.quit }
}
