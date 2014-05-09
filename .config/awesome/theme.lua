-----------------------------
-- .yankee's awesome theme --
-----------------------------

theme = {}
--font          = Neep Alt 10
--font          = sans 8
theme.font          = "fixed 10"
theme.taglist_font  = "fixed 14"

theme.bg_normal     = "#22222288"
theme.bg_focus      = "#4c0c0c94"
theme.bg_urgent     = "#6f0f0f"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize  =  "#ffffff"

theme.border_width  = 1
theme.border_normal = "#111111"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

basepth = "/home/michal/.config/awesome"
-- There are another variables sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- Example:
--taglist_bg_focus = #ff0000

-- Display the taglist squares
theme.taglist_squares_sel = basepth .. "/theme/taglist/squarefb1.png"
--theme.taglist_squares_sel = basepth .. "/theme/taglist/squarefw.png"
theme.taglist_squares_unsel = basepth .. "/theme/taglist/squareb1.png"
--theme.taglist_squares_unsel = basepth .. "/theme/taglist/squarew.png"

theme.tasklist_floating_icon = basepth .. "/theme/tasklist/floating.png"

-- Variables set for theming menu
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_border_width = "1"
theme.menu_border_color = "#4a1a1a"
theme.menu_submenu_icon = basepth .. "/theme/submenu.png"
theme.menu_height   = "21"
theme.menu_width    = "127"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--bg_widget    = #cc0000

-- Define the image to load
--theme.titlebar_close_button = "true"
--theme.titlebar_close_text_focus = ᛆxᚿ
--theme.titlebar_close_text_normal = ᛆ ᚿ
theme.titlebar_close_button_normal = basepth .. "/zenburn-anrxc/titlebar/close_normal.png"
theme.titlebar_close_button_focus = basepth .. "/zenburn-anrxc/titlebar/close_focus.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { } --"/usr/bin/awsetbg /mnt/data/Zdj_n_pics/Screen/bg/Skrzydlata_w_chmurach_1.jpg" }
--theme/background.png

-- You can use your own layout icons like this:
theme.layout_fairh = basepth .. "/theme/layouts/fairh_b1.png"
theme.layout_fairv = basepth .. "/theme/layouts/fairv_b1.png"
theme.layout_floating = basepth .. "/theme/layouts/floating_b1.png"
theme.layout_magnifier = basepth .. "/theme/layouts/magnifier_b1.png"
theme.layout_max = basepth .. "/theme/layouts/max_b1.png"
theme.layout_tilebottom = basepth .. "/theme/layouts/tilebottom_b1.png"
theme.layout_tileleft = basepth .. "/theme/layouts/tileleft_b1.png"
theme.layout_tile = basepth .. "/theme/layouts/tile_b1.png"
theme.layout_tiletop = basepth .. "/theme/layouts/tiletop_b1.png"
theme.layout_spiral = basepth .. "/theme/layouts/spiralw.png"
theme.layout_dwindle = basepth .. "/theme/layouts/dwindlew.png"
theme.awesome_icon = basepth .. "/theme/awesome_red2_16.png"
--theme.awesome_icon = "/mnt/data/Zdj_n_pics/other/logo_Jankoo-red.png"
return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
