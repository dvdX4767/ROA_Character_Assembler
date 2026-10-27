set_cursor(cr_default);
tick_dragging_layer("Overlay")
global.scroll_y = clamp(global.scroll_y, -(19 + 102) * (array_length(all_sounds_builtin) + array_length(all_sounds_custom)), 0)

var k = 0;
var _col = c_white;

draw_sprite_ext(spr_UIbox, 0, 12, 74 + (19 + 102) * k + global.scroll_y, 5.64, 1.6, 0, _col, 1);
draw_sprite_ext(spr_plus, 0, 194, 125 + (19 + 102) * k + global.scroll_y, 1, 1, 0, c_white, 1);
if mouse_in_rectangle(12, 74 + (19 + 102) * k + global.scroll_y, 64 * 5.8, (64 * 1.6 * 1.7) + ((19 + 102) * k) + global.scroll_y) and focus == 0 {
	set_cursor(cr_handpoint);
	if mouse_check_button_pressed(mb_left) {
		var _path = string("{0}/sounds/", global.selected_path);

		if (import_custom_sound(_path)) {
			if audio_exists(loaded_sound) {
				audio_destroy_stream(loaded_sound);
			}
			room_restart();
		} else {
			show_message("Invalid file type or action was cancelled");
		}
	}
}

k++;
_col = multiplexer(selected == "CHARSELECT.OGG", c_fuchsia, c_aqua);
draw_sprite_ext(spr_UIbox, 0, 12, 74 + (19 + 102) * k + global.scroll_y, 5.64, 1.6, 0, _col, 1);
draw_sprite_ext(spr_sounds, 0, 21, 85 + (19 + 102) * k + global.scroll_y, 5, 5, 0, c_white, 1);
draw_text_ext_transformed_colour(111, 90 + (19 + 102) * k + global.scroll_y, "charselect", 60, 607, 0.4, 0.4, 0, _col, _col, _col, _col, 1);
draw_text_ext_transformed_colour(112, 129 + (19 + 102) * k + global.scroll_y, "SPECIAL SOUND", 60, 607, 0.4, 0.4, 0, c_fuchsia, c_fuchsia, c_fuchsia, c_fuchsia, 1);
if mouse_in_rectangle(12, 74 + (19 + 102) * k + global.scroll_y, 64 * 5.8, (64 * 1.6 * 1.7) + ((19 + 102) * k) + global.scroll_y) and focus == 0 {
	set_cursor(cr_handpoint);
	if mouse_check_button_pressed(mb_left) {
		selected = "CHARSELECT.OGG";
		if audio_exists(loaded_sound) {
			audio_destroy_stream(loaded_sound);
		}
		soundbar_percent = 0
		playing_instance = -1;
		use_array = lookfor_uses_custom();
		if !file_exists(get_full_path("charselect.ogg")) {file_copy("empty.ogg", get_full_path("charselect.ogg"))}
		loaded_sound = audio_create_stream(get_full_path("charselect.ogg"));
	}
}


var j;

for (j = 0; j < array_length(all_sounds_custom); j++) {
	k = j + 2;
	_col = multiplexer(selected == all_sounds_custom[j], c_lime, c_aqua);
	draw_sprite_ext(spr_UIbox, 0, 12, 74 + (19 + 102) * k + global.scroll_y, 5.64, 1.6, 0, _col, 1);
	draw_sprite_ext(spr_sounds, 0, 21, 85 + (19 + 102) * k + global.scroll_y, 5, 5, 0, c_white, 1);
	draw_text_ext_transformed_colour(111, 90 + (19 + 102) * k + global.scroll_y, all_sounds_custom[j], 60, 607, 0.4, 0.4, 0, _col, _col, _col, _col, 1);
	draw_text_ext_transformed_colour(112, 129 + (19 + 102) * k + global.scroll_y, "CUSTOM SOUND", 60, 607, 0.4, 0.4, 0, c_lime, c_lime, c_lime, c_lime, 1);
	if mouse_in_rectangle(12, 74 + (19 + 102) * k + global.scroll_y, 64 * 5.8, (64 * 1.6 * 1.7) + ((19 + 102) * k) + global.scroll_y) and focus == 0 {
		set_cursor(cr_handpoint);
		if mouse_check_button_pressed(mb_left) {
			selected = all_sounds_custom[j];
			if audio_exists(loaded_sound) {
				audio_destroy_stream(loaded_sound);
			}
			soundbar_percent = 0
			playing_instance = -1;
			use_array = lookfor_uses_custom();
			loaded_sound = audio_create_stream(string("{0}/sounds/{1}.ogg", global.selected_path, selected));
		}
	}
}

for (var i = 0; i < array_length(all_sounds_builtin); i++) {
	k = i + j + 2;
	_col = multiplexer(selected == all_sounds_builtin[i], c_orange, c_aqua);
	draw_sprite_ext(spr_UIbox, 0, 12, 74 + (19 + 102) * k + global.scroll_y, 5.64, 1.6, 0, _col, 1);
	draw_sprite_ext(spr_sounds, 0, 21, 85 + (19 + 102) * k + global.scroll_y, 5, 5, 0, c_white, 1);
	draw_text_ext_transformed_colour(111, 90 + (19 + 102) * k + global.scroll_y, all_sounds_builtin[i], 60, 607, 0.4, 0.4, 0, _col, _col, _col, _col, 1);
	draw_text_ext_transformed_colour(112, 129 + (19 + 102) * k + global.scroll_y, "BUILT IN SOUND", 60, 607, 0.4, 0.4, 0, c_orange, c_orange, c_orange, c_orange, 1);
	if mouse_in_rectangle(12, 74 + (19 + 102) * k + global.scroll_y, 64 * 5.8, (64 * 1.6 * 1.7)  + ((19 + 102) * k) + global.scroll_y) and focus == 0 {
		set_cursor(cr_handpoint);
		if mouse_check_button_pressed(mb_left) {selected = all_sounds_builtin[i]; use_array = lookfor_uses_builtin();}
	}
}

keyboard_string = string_filter_format_name(keyboard_string);
layer_text_text(layer_text_get_id("Assets_1", "SoundName"), multiplexer(focus == 1, selected, keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_")));

if array_contains(all_sounds_builtin, selected) {
	layer_sprite_alpha(layer_sprite_get_id("Assets_1", "player_button"), 0);
	layer_sprite_alpha(layer_sprite_get_id("Assets_1", "player_playbutton"), 0);
	layer_sprite_alpha(layer_sprite_get_id("Assets_1", "player_slider"), 0);
	layer_sprite_alpha(layer_sprite_get_id("Assets_1", "player_bar"), 0);
	layer_sprite_alpha(layer_sprite_get_id("Assets_1", "sound_replace"), 0);
	layer_sprite_alpha(layer_sprite_get_id("Assets_1", "sound_delete"), 0);
	layer_text_alpha(layer_text_get_id("Assets_1", "player_duration"), 0);
	layer_text_alpha(layer_text_get_id("Assets_1", "sound_replace_txt"), 0);
	layer_text_alpha(layer_text_get_id("Assets_1", "sound_delete_txt"), 0);
	if audio_exists(loaded_sound) {
		audio_destroy_stream(loaded_sound);
	}
	loaded_sound = -1;
	soundbar_percent = 0;
	playing_instance = -1;
} else {
	if loaded_sound != -1 {
		layer_sprite_alpha(layer_sprite_get_id("Assets_1", "player_button"), 1);
		layer_sprite_alpha(layer_sprite_get_id("Assets_1", "player_playbutton"), 1);
		layer_sprite_alpha(layer_sprite_get_id("Assets_1", "player_slider"), 1);
		layer_sprite_alpha(layer_sprite_get_id("Assets_1", "player_bar"), 1);
		layer_sprite_alpha(layer_sprite_get_id("Assets_1", "sound_replace"), 1);
		layer_sprite_alpha(layer_sprite_get_id("Assets_1", "sound_delete"), 1);
		layer_text_alpha(layer_text_get_id("Assets_1", "player_duration"), 1);
		layer_text_alpha(layer_text_get_id("Assets_1", "sound_replace_txt"), 1);
		layer_text_alpha(layer_text_get_id("Assets_1", "sound_delete_txt"), 1);
		layer_sprite_change(layer_sprite_get_id("Assets_1", "player_button"), multiplexer(audio_is_playing(loaded_sound), spr_play, spr_pause));
		layer_text_text(layer_text_get_id("Assets_1", "player_duration"), string("{0} / {1}", seconds_to_time(audio_sound_length(loaded_sound) * soundbar_percent), seconds_to_time(audio_sound_length(loaded_sound))));

		if mouse_in_rectangle(402, 157, 402 + 64, 157 + 64) and focus == 0 {
			set_cursor(cr_handpoint);
			if mouse_check_button_pressed(mb_left) {
				if !audio_is_playing(loaded_sound) {
					playing_instance = audio_play_sound(loaded_sound, 1, false);
					if soundbar_percent == 1 {soundbar_percent = 0}
					audio_sound_set_track_position(playing_instance, audio_sound_length(loaded_sound) * soundbar_percent)
				} else {
					audio_stop_sound(loaded_sound);
				}
			}
		}
		
		if audio_is_playing(loaded_sound) and playing_instance != -1 {
			var _total_length = audio_sound_length(loaded_sound);
			var _current_pos = audio_sound_get_track_position(playing_instance);
			soundbar_percent = 0;
			if (_total_length > 0) {
				soundbar_percent = (_current_pos / _total_length);
			}
		} else {
			if soundbar_percent > 0.9 {soundbar_percent = 1}
		}
		
		if mouse_in_rectangle(483, 157, 984, 220) and focus == 0 {
			set_cursor(cr_size_we);
			if mouse_check_button(mb_left) {
				if audio_is_playing(loaded_sound) {
					audio_stop_sound(loaded_sound);
					playing_instance = -1;
				}
				soundbar_percent = clamp(((mouse_x - 16) - 483) / 461, 0, 1);
			}
		}
		
		layer_sprite_x(layer_sprite_get_id("Assets_1", "player_slider"), 483 + (461 * soundbar_percent));
		
		if mouse_in_rectangle(1240, 62, 1364, 102) and focus == 0 {
			set_cursor(cr_handpoint);
			if mouse_check_button_pressed(mb_left) {
				var _path = string("{0}/sounds/{1}.ogg", global.selected_path, selected);
				if selected == "CHARSELECT.OGG" {
					_path = get_full_path("charselect.ogg");
				}
				if import_custom_sound_name(_path) {
					if audio_exists(loaded_sound) {
						audio_destroy_stream(loaded_sound);
					}
					room_restart();
				} else {
					show_message("Invalid file type or action was cancelled");
				}
			}
		}
		
		if mouse_in_rectangle(1240, 105, 1364, 145) and focus == 0 {
			set_cursor(cr_handpoint);
			if mouse_check_button_pressed(mb_left) {
				var _path = string("{0}/sounds/{1}.ogg", global.selected_path, selected);
				if selected == "CHARSELECT.OGG" {
					if show_question("Are you sure you want to reset this sound?") {
						file_copy("empty.ogg", get_full_path("charselect.ogg"))
						if audio_exists(loaded_sound) {
							audio_destroy_stream(loaded_sound);
						}
						room_restart();
					}
				} else {
					if show_question("Are you sure you want to delete this sound?") {
						file_delete(_path);
						file_replace_line_starting_with(string("{0}/scripts/init.gml", global.selected_path), "set_victory_theme(", "");
						if audio_exists(loaded_sound) {
							audio_destroy_stream(loaded_sound);
						}
						room_restart();
					}
				}
			}
		}
	}
}

if array_contains(all_sounds_custom, selected) and selected != "CHARSELECT.OGG" {
	if mouse_in_rectangle(390, 70, 1220, 130) and focus == 0 {
		set_cursor(cr_beam);
		if mouse_check_button_pressed(mb_left) {
			focus = 1;
			keyboard_string = selected;
		}
	} else if focus == 1 and mouse_check_button_pressed(mb_left) {
		focus = 0;
		keyboard_string = string_filter_format_name(keyboard_string);
		var _newpath = string("{0}/sounds/{1}.ogg", global.selected_path, keyboard_string);
		if keyboard_string != "" and !file_exists(_newpath) {
			var _path = string("{0}/sounds/{1}.ogg", global.selected_path, selected);
			var _path2 = string("{0}/scripts/", global.selected_path);
			file_rename(_path, _newpath);
			global_string_replace_in_directory(_path2, string("\"{0}\"", selected), string("\"{0}\"", keyboard_string));
			if audio_exists(loaded_sound) {
				audio_destroy_stream(loaded_sound);
			}
			room_restart();
		} else {
			show_message("Unable to rename: Invalid name or file with the same name already exists");
		}
	} else if focus == 1 and keyboard_check_pressed(vk_escape) {
		focus = 0;
	}
}

if keyboard_check_pressed(vk_up) {
	scroll = max(scroll - 1, 0);
}
if keyboard_check_pressed(vk_down) {
	scroll = min(scroll + 1, max(array_length(use_array) - 1, 0));
}

if selected != "CHARSELECT.OGG" {
	for (var ii = scroll; ii < clamp(array_length(use_array), 0, min(array_length(use_array), 14)); ii++) {
		draw_text_ext_transformed(395, 305 + 30 * (ii - scroll), string("{0} ({1})", use_array[ii][0], use_array[ii][1]), 999, 99999, 0.4, 0.4, 0);
		draw_sprite_ext(spr_UIbox, 0, 1264, 310 + 30 * (ii - scroll), 1.4, 0.45, 0, c_white, 1);
		draw_text_ext_transformed(1283, 316 + 30 * (ii - scroll), "INSPECT", 999, 99999, 0.2, 0.2, 0);
		if mouse_in_rectangle(1264, 310 + 30 * (ii - scroll), 1264 + 64 * 1.4, 310 + 64 * 0.45 + 30 * ii) and focus == 0 {
			set_cursor(cr_handpoint);
			if mouse_check_button_pressed(mb_left) {
				url_open(string("{0}/scripts/{1}", global.selected_path, use_array[ii][0]));
			}
		}
	}

	draw_text_ext_transformed_color(395, 305 + 30 * (array_length(use_array) - scroll), "CLICK HERE TO ADD BASIC SOUND USES", 999, 99999, 0.4, 0.4, 0, c_lime, c_lime, c_lime, c_lime, 1);
	if mouse_in_rectangle(395, 310 + 30 * (array_length(use_array) - scroll), 1264 + 64 * 1.4, 304 + 64 * 0.45 + 30 * array_length(use_array)) {
		set_cursor(cr_handpoint);
		if mouse_check_button_pressed(mb_left) and focus == 0 {
			focus = 2;
			GET_ME_WHAT_I_NEED();
		}
	}
} else {
	draw_text_ext_transformed_color(395, 305, "Character select sound", 999, 99999, 0.4, 0.4, 0, c_lime, c_lime, c_lime, c_lime, 1);
}

if focus == 2 {
	layer_set_visible("Assets_2", true);
	layer_text_blend(layer_text_get_id("Assets_2", "popup_close"), c_white);
	if mouse_in_rectangle(1150, 80, 1205, 140) {
		layer_text_blend(layer_text_get_id("Assets_2", "popup_close"), c_red);
		if mouse_check_button_pressed(mb_left) {
			focus = 0;
		}
	}
	
	var _path = string("{0}/scripts/init.gml", global.selected_path)
	var _function = multiplexer(array_contains(all_sounds_builtin, selected), "sound_get(", "asset_get(");
	// BEGIN HERE
	update_display(ATTIN.victorytype, layer_text_get_id("Assets_2", "linksound_vict"), ATTIN.victorytheme)
	if mouse_in_rectangle(170, 153, 410, 217) {
		set_cursor(cr_handpoint);
		if mouse_check_button_pressed(mb_left) {
			swap_and_shit(_path, "set_victory_theme(sound_get(", "set_victory_theme(asset_get(", string("set_victory_theme({0}\"{1}\"));", _function, selected))
			use_array = multiplexer(_function == "asset_get(", lookfor_uses_custom(), lookfor_uses_builtin());
			focus = 0;
		}
	}
	
	update_display(ATTIN.landtype, layer_text_get_id("Assets_2", "linksound_vict2"), ATTIN.landtheme)
	checkbutton(170, 230, "land_sound = sound_get(", "land_sound = asset_get(", string("land_sound = {0}\"{1}\");", _function, selected), _path, _function);
	
	update_display(ATTIN.landlagtype, layer_text_get_id("Assets_2", "linksound_vict3"), ATTIN.landlagtheme);
	checkbutton(170, 311, "landing_lag_sound = sound_get(", "landing_lag_sound = asset_get(", string("landing_lag_sound = {0}\"{1}\");", _function, selected), _path, _function);

	update_display(ATTIN.wavelandtype, layer_text_get_id("Assets_2", "linksound_vict4"), ATTIN.wavelandtheme);
	checkbutton(170, 393, "waveland_sound = sound_get(", "waveland_sound = asset_get(", string("waveland_sound = {0}\"{1}\");", _function, selected), _path, _function);

	update_display(ATTIN.jumptype, layer_text_get_id("Assets_2", "linksound_vict5"), ATTIN.jumptheme);
	checkbutton(170, 475, "jump_sound = sound_get(", "jump_sound = asset_get(", string("jump_sound = {0}\"{1}\");", _function, selected), _path, _function);

	update_display(ATTIN.djumptype, layer_text_get_id("Assets_2", "linksound_vict6"), ATTIN.djumptheme);
	checkbutton(170, 555, "djump_sound = sound_get(", "djump_sound = asset_get(", string("djump_sound = {0}\"{1}\");", _function, selected), _path, _function);

	update_display(ATTIN.airdodgetype, layer_text_get_id("Assets_2", "linksound_vict7"), ATTIN.airdodgetheme);
	checkbutton(170, 633, "air_dodge_sound = sound_get(", "air_dodge_sound = asset_get(", string("air_dodge_sound = {0}\"{1}\");", _function, selected), _path, _function);
	
	// END HERE
		
} else {
	layer_set_visible("Assets_2", false);
}

if mouse_in_rectangle(0, 0, 90, 60) {
	set_cursor(cr_handpoint);	
}