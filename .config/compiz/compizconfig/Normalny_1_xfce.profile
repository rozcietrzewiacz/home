[core]
as_active_plugins = core;ccp;decoration;wall;imgjpeg;widget;move;winrules;minimize;wobbly;regex;shift;png;splash;place;extrawm;svg;resize;workarounds;expo;fade;scale;staticswitcher;group;
as_texture_filter = 0
as_autoraise = false
as_edge_delay = 230
as_run_key = Disabled
as_command0 = urxvt -name URUK -geometry 126x50
as_command1 = opera
as_command2 = urxvt -tint "#10a090" -e mocp
as_command11 = xkill
as_run_command0_key = <Control><Alt>b
as_run_command1_key = <Control><Alt>o
as_run_command2_key = <Control><Alt>m
as_lower_window_button = Disabled
as_unmaximize_window_key = Disabled
as_maximize_window_key = Disabled
as_command_screenshot = ksnapshot
as_command_window_screenshot = ksnapshot -c
as_show_desktop_key = <Super>d
as_raise_on_click = false
as_toggle_window_maximized_key = <Control><Alt>x
as_toggle_window_shaded_key = Disabled
as_command_terminal = urxvt
as_run_command_terminal_key = <Control><Alt>Return
as_ping_delay = 4999
s0_refresh_rate = 63
s0_hsize = 2
s0_vsize = 2
s0_outputs = 1024x768+0+0;1024x768+1024+0;

[cube]
as_next_slide_key = Disabled
s0_skydome = true
s0_acceleration = 5.900000
s0_speed = 7.800000
s0_mipmap = false

[decoration]
as_shadow_y_offset = 2
as_command = emerald --replace & conky -d
as_mipmap = true
as_decoration_match = !(title=CONKy|title=URUK)
as_shadow_match = !(title=CONKy|title=URUK|title=opera)

[wall]
as_miniscreen = true
as_preview_timeout = 0.100000
as_preview_scale = 200
as_edge_radius = 4
as_border_width = 8
as_outline_color = #333333d9
as_background_gradient_base_color = #23312bf4
as_background_gradient_highlight_color = #586e64a9
as_background_gradient_shadow_color = #333b2af9
as_thumb_gradient_base_color = #2d2d2de9
as_thumb_gradient_highlight_color = #3f3f3f3f
as_thumb_highlight_gradient_base_color = #fffffff3
as_thumb_highlight_gradient_shadow_color = #dfdfdfa6
as_arrow_base_color = #060606ff
as_arrow_shadow_color = #808080e1
as_slide_duration = 0.888600
as_flip_left_edge = 
as_flip_right_edge = 
as_flip_up_edge = 
as_flip_down_edge = 
s0_mmmode = 1
s0_edgeflip_move = false

[staticswitcher]
as_prev_all_key = Disabled
s0_speed = 4.129900
s0_timestep = 2.470500
s0_saturation = 80
s0_brightness = 80
s0_opacity = 81
s0_icon = false

[colorfilter]
s0_filter_decorations = true

[switcher]
s0_auto_rotate = true

[annotate]
as_stroke_width = 3.597900

[expo]
as_zoom_time = 0.214500
as_distance = 0.040900
as_curve = 0.009500
as_hide_docks = false
as_vp_brightness = 70.792099
as_reflection = false
as_ground_color1 = #ffe800c3
as_ground_color2 = #290f91d9
as_ground_size = 1.000000

[widget]
s0_match = title=CONKy
s0_fade_time = 0.200000
s0_bg_brightness = 20
s0_bg_saturation = 81

[move]
as_opacity = 80
as_snapoff_maximized = false

[winrules]
s0_skiptaskbar_match = title=CONKy|title=URUK
s0_skippager_match = title=CONKy|title=URUK
s0_above_match = title=CONKy
s0_below_match = title=URUK
s0_sticky_match = title=CONKy
s0_fullscreen_match = title=URUK
s0_no_move_match = title=CONKy|title=URUK
s0_no_resize_match = title=CONKy
s0_no_minimize_match = title=CONKy|title=URUK
s0_no_maximize_match = title=CONKy
s0_no_close_match = title=CONKy
s0_no_focus_match = title=CONKy
s0_size_matches = title=URUK;title=CONKy;
s0_size_width_values = 1024;347;
s0_size_height_values = 768;700;

[group]
as_remove_key = Disabled
as_ignore_key = Disabled
s0_shade_all = true
s0_auto_group = true
s0_select_opacity = 90
s0_fill_color = #00000099
s0_bar_animations = false
s0_thumb_space = 2
s0_tabbar_font_size = 14

[cubeaddon]
s0_deformation = 0

[snap]
s0_snap_type = 0;1;
s0_attraction_distance = 30

[fade]
s0_fade_speed = 8.500000
s0_window_match = !title=opera

[vpswitch]
as_switch_to_1_key = <Control><Alt>1
as_switch_to_2_key = <Control><Alt>2
as_switch_to_3_key = <Control><Alt>3
as_switch_to_4_key = <Control><Alt>4
as_left_button = <LeftEdge><Alt>Button1
as_right_button = <RightEdge><Alt>Button1
as_init_action = initiate

[animation]
s0_close_matches = (type=Normal | Dialog | ModalDialog | Utility | Unknown) & !(name=gnome-screensaver);(type=Menu | PopupMenu | DropdownMenu);(type=Tooltip | Notification);
s0_close_options = ;;
s0_open_matches = (type=Normal | Dialog | ModalDialog | Utility | Unknown) & !(name=gnome-screensaver);(type=Menu | PopupMenu | DropdownMenu);(type=Tooltip | Notification);
s0_open_options = ;;
s0_minimize_matches = (type=Normal | Dialog | ModalDialog | Utility | Unknown);
s0_minimize_options = 
s0_shade_options = 
s0_focus_options = 
s0_fire_color = #ff3305ff
s0_beam_color = #7f7f7fff

[wobbly]
as_snap_inverted = true
s0_grid_resolution = 1
s0_min_grid_size = 4
s0_move_window_match = (Toolbar | Menu | Utility | Dialog | Normal | Unknown) & !title=CONKy
s0_maximize_effect = false

[shift]
s0_speed = 4.743700
s0_shift_speed = 2.343900
s0_timestep = 1.403800
s0_reflection = false
s0_ground_color1 = #b3b3b3cc
s0_ground_color2 = #b3b3b300

[resizeinfo]
as_gradient_1 = #cccce6cc
as_gradient_2 = #f3f3f3cc
as_gradient_3 = #d9d9d9cc

[thumbnail]
s0_thumb_size = 419
s0_show_delay = 1092
s0_border = 8
s0_thumb_color = #1a5485cc
s0_fade_speed = 0.128535
s0_window_like = false
s0_mipmap = true
s0_title_enabled = false
s0_font_bold = false

[rotate]
as_edge_flip_window = false
as_edge_flip_dnd = false
s0_snap_top = true
s0_speed = 7.800000
s0_zoom = 0.200000

[ring]
as_next_key = <Alt>Tab
as_prev_key = <Shift><Alt>Tab
s0_speed = 3.500000
s0_ring_width = 81
s0_ring_height = 50
s0_thumb_width = 687
s0_thumb_height = 487
s0_min_brightness = 0.270000
s0_min_scale = 0.260000
s0_title_font_bold = true
s0_title_font_size = 19

[showmouse]
s0_color = #b70602ff

[resize]
as_mode = 3

[scaleaddon]
s0_window_title = 0

[workarounds]
as_sticky_alldesktops = true

[firepaint]
s0_fire_color = #ff3305ff

