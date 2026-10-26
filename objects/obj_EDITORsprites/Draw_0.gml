global.scroll_y = clamp(global.scroll_y, -308 * ((array_length(all_loaded_sprites) div 4) - 1), 0)
var _xoffset = 32;
var _yoffset = 96 + global.scroll_y;
set_cursor(cr_default);

if mouse_in_rectangle(0, 0, 90, 60) {
	set_cursor(cr_handpoint);
}

layer_set_visible(layer_get_id("Assets_3"), focus != "nothing");
tick_dragging_layer("Overlay");

if focus == "nothing" {
	layer_background_blend(layer_background_get_id("Background"), c_black);
	for (var i = 0; i < array_length(all_loaded_sprites); i++) {
	
		// draw sprite label thingmabob
		var _offx = (i mod 4) * 298 + _xoffset;
		var _offy = (i div 4) * 308 + _yoffset;
		var _path = all_loaded_sprites[i][3];
		var _type = all_loaded_sprites[i][2];
		var _name = all_loaded_sprites[i][1];
		var _sprite = all_loaded_sprites[i][0];
		var _col = multiplexer(_type, c_orange, c_aqua, c_lime, c_yellow);
		var _title = multiplexer(_type, "Single Sprite", string("Sprite Strip [{0}]", sprite_get_number(_sprite)), string("Sprite Hurtbox [{0}]", sprite_get_number(_sprite)), "Custom Sprite");
		draw_sprite_ext(spr_UIbox, 0, _offx, _offy, 4.34, 4.5, 0, _col, 1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text_ext_transformed_colour(_offx + 5, _offy + 5, _name, 99, 9999, 0.3, 0.3, 0, _col, _col, _col, _col, 1);
		draw_text_ext_transformed_colour(_offx + 5, _offy + 32, _title, 99, 9999, 0.3, 0.3, 0, c_gray, c_gray, c_gray, c_gray, 1);
		draw_sprite_ext(spr_UIbox, 0, _offx, _offy + 58, 4.34, 2.625, 0, _col, 1);
	
		// sprite resize code
	
		var _startW = sprite_get_width(_sprite);
		var _startH = sprite_get_height(_sprite);
		var _targetW = 64 * 4.2;
		var _targetH = 64 * 2.4;
	
		var _diffW = _targetW - _startW;
		var _diffH = _targetH - _startH;
	
		var _percW = 1 + (_diffW / _startW);
		var _percH = 1 + (_diffH / _startH);
	
		var _newScale = min(_percH, _percW) * 0.98;
	
		draw_sprite_ext(_sprite, round(global.tick / 4) mod sprite_get_number(_sprite), _offx + (_targetW / 2) - ((_startW * _newScale) / 2), _offy + 60, _newScale, _newScale, 0, c_white, 1);
	
		draw_set_halign(fa_right);
		draw_set_valign(fa_top);
		draw_text_ext_transformed_colour(_offx + 273, _offy + 40, string("{0}x{1}", _startW, _startH), 99, 9999, 0.23, 0.23, 0, c_gray, c_gray, c_gray, c_gray, 1);
		draw_set_halign(fa_left);
	
		draw_sprite_ext(spr_UIbox, 0, _offx + 78, _offy + 224, 1.82, 1, 0, _col, 1);
	
		var _touching = mouse_in_rectangle(_offx + 34 - 32, _offy + 322 - 96, _offx + 109 - 32, _offy + 380 - 96);
		var _touching2 = mouse_in_rectangle(_offx + 112 - 32, _offy + 322 - 96, _offx + 225 - 32, _offy + 380 - 96);
		var _touching3 = mouse_in_rectangle(_offx + 226 - 32, _offy + 322 - 96, _offx + 307 - 32, _offy + 380 - 96);
		var _col2 = c_white;
		draw_text_ext_transformed_colour(_offx + 7, _offy + 336 - 96, "SWAP", 99, 9999, 0.36, 0.36, 0, _col2, _col2, _col2, _col2, 1);
		draw_text_ext_transformed_colour(_offx + 129 - 32, _offy + 326 - 96, "EDIT", 99, 9999, 0.59, 0.59, 0, _col2, _col2, _col2, _col2, 1);
		var _col3 = c_red;
		draw_text_ext_transformed_colour(_offx + 228 - 32, _offy + 337 - 96, "DELETE", 99, 9999, 0.34, 0.34, 0, _col3, _col3, _col3, _col3, 1);
	
		if focus == "nothing" {
			if _touching or _touching2 or _touching3 {
				set_cursor(cr_handpoint);
			}
			// swap sprite code
			if mouse_check_button_pressed(mb_left) {
				if _touching {
					var _newFile = askfor_png_path();
					if _newFile != "" {
						if string_pos("_strip", filename_name(_path)) != 0 and string_pos("_strip", filename_name(_newFile)) != 0 {
							var _newpath = filename_name(_path);// name_strip3.png
							var _newfilename = filename_name(_newFile); // newspr_strip5.png
							var _untouched = string_copy_alt(_newpath, 1, string_pos("_strip", _newpath) + 6); // name_strip
							var _newcount = string_copy_alt(_newfilename, string_pos("_strip", _newfilename) + 6, string_pos(".png", _newfilename)); // 5
							var _newrenpath = "sprites/" + _untouched + string(max(1, round(real(string_digits(_newcount))))) + ".png"; // name_strip5.png
							if string_digits(_newcount) != "" {
								archive_edit_sprite(AP.SPRITES, _path, _newFile, get_full_path(_newrenpath));
							} else {
								show_message("Failed to replace sprite, invalid strip number");
							}
						} else if array_contains(forbidden, filename_name(_path)) {
							archive_edit_sprite(AP.MAIN, _path, _newFile, _path);
						} else {
							archive_edit_sprite(AP.SPRITES, _path, _newFile, _path);
						}
						load_all();
					} else {
						show_message("Failed to replace sprite: Invalid selected file or action was cancelled");
					}
				}
				
				if _touching2 {
					selected = i;
					focus = "spritedit";
					initialize_spriteditor(_path, _type, _sprite, _name);
					exit;
				}
		
				if _touching3 {
					if show_question("Please confirm you wish to delete this sprite, this cannot be undone and the sprite will be lost") {
						if string_pos(".", _name) != 0 {
							_name = string_copy(_name, 1, string_pos(".", _name) - 1);
						}
						
						var _arpos = archive_fetch_gml_string_startswith(AP.SCRIPTS, get_full_path("scripts/load.gml"), string("sprite_change_offset(\"{0}\"", _name), false);
						if _arpos == -2 {
							archive_create(AP.SCRIPTS, get_full_path("scripts/load.gml"), FT.GML);
						}
						if _arpos >= 0 {
							archive_edit_gml_remove(AP.SCRIPTS, get_full_path("scripts/load.gml"), _arpos);
						}
					
						if _type == 0 {
							if array_contains(forbidden, string("{0}.png", _name)) {
								archive_edit_sprite(AP.MAIN, _path, "empty.png", _path);
							} else {
								archive_edit_sprite(AP.SPRITES, _path, undefined, _path);
							}
						} else {
							archive_delete(AP.SPRITES, _path);
						}
						load_all();
					}
				}
			}
		}
	}

	if mouse_in_rectangle(1266, 77, 1266 + 64 * 1.39, 77 + 64 * 1.39) and focus == "nothing" {
		set_cursor(cr_handpoint);
		if mouse_check_button_pressed(mb_left) {
			var _newFile = askfor_png_path();
			if _newFile != "" {
				var _newPos = get_full_path(string("sprites/{0}", filename_name(_newFile)));
				if array_contains(forbidden, filename_name(_newFile)) {
					show_message("Failed to add new sprite: You cannot replace essential (orange) images this way, please use the swap button");
				} else {
					archive_create(AP.SPRITES, _newPos, FT.SPRITE);
					archive_edit_sprite(AP.SPRITES, _newPos, _newFile, _newPos);
					load_all();
				}
			} else {
				show_message("Failed to add new sprite: Invalid selected file or action was cancelled");
			}
		}
	}

	if mouse_in_rectangle(1265, 178, 2000, 735) and focus == "nothing" {
		set_cursor(cr_size_ns);
		if mouse_check_button(mb_left) {
			var _scroll = clamp(mouse_y, 182, 669) - 182;
			global.scroll_y = (_scroll / (669 - 182)) * (-308 * ((array_length(all_loaded_sprites) div 4) - 1));
		}
	}
	var _max_scroll = -308 * ((array_length(all_loaded_sprites) div 4) - 1);
	var _scroller_y = 182;
	
	if (_max_scroll != 0) {
		_scroller_y = 182 + (global.scroll_y / _max_scroll) * (669 - 182);
	}
	
	layer_sprite_y(layer_sprite_get_id("Assets_1", "sprite_scroller"), _scroller_y);
}

if focus == "spritedit" {
	layer_background_blend(layer_background_get_id("Background"), c_gray);
	var _graph_start_x = 14;
	var _graph_start_y = 77;
	var _graph_cam_y = 0;
	var _graph_end_x = 486;
	var _graph_end_y = 549;
	var _graph_width = _graph_end_x - _graph_start_x;
	var _graph_height = _graph_end_y - _graph_start_y;
	var _graph_color = multiplexer(keyboard_check(vk_shift), c_dkgray, multiplexer(global.tick mod 60 > 30, c_white, c_yellow));
	var _sprite = all_loaded_sprites[selected][0];
	var _center_x = graph_cam_x + (_graph_width / img_zoom) / 2;
	var _center_y = graph_cam_y + (_graph_height / img_zoom) / 2;
	
	if keyboard_check(vk_control) and mouse_wheel_up() {
		img_zoom = min(25, img_zoom + 1);
		graph_cam_x = floor(_center_x - (_graph_width / img_zoom) / 2);
		graph_cam_y = floor(_center_y - (_graph_height / img_zoom) / 2);
	}
	if keyboard_check(vk_control) and mouse_wheel_down() {
		img_zoom = max(3, img_zoom - 1);
		graph_cam_x = floor(_center_x - (_graph_width / img_zoom) / 2);
		graph_cam_y = floor(_center_y - (_graph_height / img_zoom) / 2);
	}
	
	var _graph_zoom = img_zoom;
	var _graph_cols = ceil(_graph_width / _graph_zoom);
	var _graph_rows = ceil(_graph_height / _graph_zoom);
	
	if keyboard_check(ord("W")) {
		if keyboard_check_pressed(ord("W")) or global.tick % 5 == 0 {
			graph_cam_y--;
		}
	}
	if keyboard_check(ord("A")) {
		if keyboard_check_pressed(ord("A")) or global.tick % 5 == 0 {
			graph_cam_x--;
		}
	}
	if keyboard_check(ord("S")) {
		if keyboard_check_pressed(ord("S")) or global.tick % 5 == 0 {
			graph_cam_y++;
		}
	}
	if keyboard_check(ord("D")) {
		if keyboard_check_pressed(ord("D")) or global.tick % 5 == 0 {
			graph_cam_x++;
		}
	}
	if pivot_x != -1 and pivot_y != -1 {
		if keyboard_check(vk_up) {
			if keyboard_check_pressed(vk_up) or global.tick % 10 == 0 {
				pivot_y--;
			}
		}
		if keyboard_check(vk_left) {
			if keyboard_check_pressed(vk_left) or global.tick % 10 == 0 {
				pivot_x--;
			}
		}
		if keyboard_check(vk_down) {
			if keyboard_check_pressed(vk_down) or global.tick % 10 == 0 {
				pivot_y++;
			}
		}
		if keyboard_check(vk_right) {
			if keyboard_check_pressed(vk_right) or global.tick % 10 == 0 {
				pivot_x++;
			}
		}
		pivot_x = max(0, pivot_x);
		pivot_y = max(0, pivot_y);
	}
	
	var _pivot = layer_sprite_get_id("Assets_3", "sprite_pointerpivot");
	if pivot_x == -1 or pivot_y == -1 or pivot_x - graph_cam_x  <= -1 or pivot_y - graph_cam_y <= -1 or pivot_x >= _graph_cols + graph_cam_x - 1 or pivot_y >= _graph_rows + graph_cam_y - 1 {
		layer_sprite_alpha(_pivot, 0);
	} else {
		layer_sprite_alpha(_pivot, 1);
	}
	
	if mouse_in_rectangle(14, 77, 14 + 64*7.367, 77 + 64*7.367) and !(pivot_x == -1 or pivot_y = -1) {
			set_cursor(cr_cross);
			if !notouch and mouse_check_button(mb_left) {
				var _correct_mx = mouse_x - _graph_start_x + (graph_cam_x * _graph_zoom);
				var _correct_my = mouse_y - _graph_start_y + (graph_cam_y * _graph_zoom);
				pivot_x = max(0, floor(_correct_mx / _graph_zoom));
				pivot_y = max(0, floor(_correct_my / _graph_zoom));
			}
		}
	
	layer_sprite_x(_pivot, _graph_start_x + pivot_x * _graph_zoom - graph_cam_x * _graph_zoom + _graph_zoom / 2);
	layer_sprite_y(_pivot, _graph_start_y + pivot_y * _graph_zoom - graph_cam_y * _graph_zoom + _graph_zoom / 2);
	
	if !img_timer_paused and global.tick mod 5 == 0 {
		img_timer = (img_timer + 1) mod sprite_get_number(_sprite);
	}
	
	draw_sprite_ext(_sprite, img_timer, _graph_start_x - graph_cam_x * _graph_zoom, _graph_start_y - graph_cam_y * _graph_zoom, _graph_zoom, _graph_zoom, 0, c_white, 1);
	
	if show_hurtbox {
		if hurttwin != -1 {
			draw_sprite_ext(all_loaded_sprites[hurttwin][0], img_timer, _graph_start_x - graph_cam_x * _graph_zoom, _graph_start_y - graph_cam_y * _graph_zoom, _graph_zoom, _graph_zoom, 0, c_white, multiplexer(keyboard_check(vk_shift), 0.5, 0.25));	
		}
		
	}
	
	
	if !keyboard_check(vk_shift) {
		for (var _gx = 1; _gx < _graph_cols; _gx++) {
			var _xpos = _graph_start_x + (_graph_zoom * _gx);
			draw_line_colour(_xpos, _graph_start_y, _xpos, _graph_end_y, _graph_color, _graph_color);
			for (var _gy = 1; _gy < _graph_rows; _gy++) {
				var _ypos = _graph_start_y + (_graph_zoom * _gy);
				draw_line_colour(_graph_start_x, _ypos, _graph_end_x, _ypos, _graph_color, _graph_color);
			}
		}
	} else if pivot_x != -1 and pivot_y != -1 {
		for (var pipis = 0; pipis < 12; pipis++) {
			draw_sprite_ext(spr_tile, 0, _graph_start_x + pipis * 16 * _graph_zoom, _graph_start_y + pivot_y * _graph_zoom - graph_cam_y * _graph_zoom, _graph_zoom, _graph_zoom, 0, c_white, 1);
		}
	}
	
	layer_sprite_change(layer_sprite_get_id("Assets_3", "sprites_play"), multiplexer(!img_timer_paused, spr_play, spr_pause))
	if mouse_in_rectangle(14, 554, 14 + 64, 554 + 64) {
		set_cursor(cr_handpoint);
		if !notouch and mouse_check_button_pressed(mb_left) {
			img_timer_paused = !img_timer_paused;
		}
	}
	
	if !(pivot_x == -1 or pivot_y = -1) {
		if mouse_in_rectangle(80, 554, 80 + 64, 554 + 64) {
			set_cursor(cr_handpoint);
			if !notouch and mouse_check_button_pressed(mb_left) {
				pivot_y = floor(graph_cam_y + (_graph_height / _graph_zoom) / 2);
			}
		}
		if mouse_in_rectangle(146, 554, 146 + 64, 554 + 64) {
			set_cursor(cr_handpoint);
			if !notouch and mouse_check_button_pressed(mb_left) {
				pivot_x = floor(graph_cam_x + (_graph_width / _graph_zoom) / 2);
			}
		}
	
		if mouse_in_rectangle(212, 554, 212 + 64, 554 + 64) {
			set_cursor(cr_handpoint);
			if !notouch and mouse_check_button_pressed(mb_left) {
				pivot_y = floor(graph_cam_y + (_graph_height / _graph_zoom) - 1);
			}
		}
		if mouse_in_rectangle(278, 554, 278 + 64, 554 + 64) {
			set_cursor(cr_handpoint);
			if !notouch and mouse_check_button_pressed(mb_left) {
				pivot_x = floor(graph_cam_x + (_graph_width / _graph_zoom) - 1);
			}
		}
		if mouse_in_rectangle(344, 554, 344 + 64, 554 + 64) {
			set_cursor(cr_handpoint);
			if !notouch and mouse_check_button_pressed(mb_left) {
				pivot_x = floor(graph_cam_x);
			}
		}
		if mouse_in_rectangle(410, 554, 410 + 64, 554 + 64) {
			set_cursor(cr_handpoint);
			if !notouch and mouse_check_button_pressed(mb_left) {
				pivot_y = floor(graph_cam_y);
			}
		}
		pivot_x = max(0, pivot_x);
		pivot_y = max(0, pivot_y);
	
	}

	
	// right side
	var _path = all_loaded_sprites[selected][3];
	var _name = all_loaded_sprites[selected][1];
	var _type = all_loaded_sprites[selected][2];
	var _title = multiplexer(_type, "Single Sprite", string("Sprite Strip [{0}]", sprite_get_number(_sprite)), string("Sprite Hurtbox [{0}]", sprite_get_number(_sprite)), "Custom Sprite");
	
	if renaming != 0 and !notouch and mouse_check_button_pressed(mb_left) {
		if renaming == 1 {
			if is_valid_filename(keyboard_string) and string_pos("_strip", keyboard_string) == 0 and string_pos("_hurt", keyboard_string) == 0 and !is_taken(keyboard_string) {
				var _extrastring = ".png";
				if string_pos("_strip", origname) != 0 {
					_extrastring = string_copy(origname, string_pos("_strip", origname), 9999);
				}
				all_loaded_sprites[selected][1] = keyboard_string + _extrastring;
			} else {
				show_message("Unable to rename: Selected file name is not valid or already exists\nTry not to include special characters, spaces, '_hurt' or '_strip' in the filename")
			}
		}
		
		if renaming == 2 {
			keyboard_string = string_filter_positive_integer(keyboard_string);
			if keyboard_string != "" {
				pivot_x = real(keyboard_string);
			}
		}
		if renaming == 3 {
			keyboard_string = string_filter_positive_integer(keyboard_string);
			if keyboard_string != "" {
				pivot_y = real(keyboard_string);
			}
		}
		renaming = 0;
	}
	if renaming == 0 {
		if mouse_in_rectangle(493, 75, 1158, 111) and _type != 0 and _type != 2 {
			set_cursor(cr_beam);
			if !notouch and mouse_check_button_pressed(mb_left) {
				renaming = 1;
				if string_pos("_strip", _name) != 0 {
					var fucker = string_pos("_strip", _name);
					keyboard_string = string_copy_alt(_name, 1, fucker);
					show_debug_message(keyboard_string);
				} else {
					keyboard_string = string_copy_alt(_name, 1, string_pos(".png", _name));
				}
				
			}
		}
		if mouse_in_rectangle(493, 258, 1158, 290) and _type != 0 and _type != 2 {
			set_cursor(cr_beam);
			if !notouch and mouse_check_button_pressed(mb_left) {
				renaming = 2;
				keyboard_string = string(pivot_x);
			}
		}
		if mouse_in_rectangle(493, 303, 1158, 333) and _type != 0 and _type != 2 {
			set_cursor(cr_beam);
			if !notouch and mouse_check_button_pressed(mb_left) {
				renaming = 3;
				keyboard_string = string(pivot_y);
			}
		}
		
		if mouse_in_rectangle(493, 340, 872, 376) and _type == 1 {
			set_cursor(cr_handpoint);
			if !notouch and mouse_check_button_pressed(mb_left) {
				show_hurtbox = !show_hurtbox;
			}
		}
	}
	
	if renaming == 1 {
		var _extrastring = ".png";
		if string_pos("_strip", origname) != 0 {
			_extrastring = string_copy(origname, string_pos("_strip", origname), 9999);
		}
		var _ulti = keyboard_string + multiplexer(global.tick mod 60 > 30, "  ", "_ ") + _extrastring;
		layer_text_text(layer_text_get_id("Assets_3", "sprites_name"), _ulti);
	} else {
		layer_text_text(layer_text_get_id("Assets_3", "sprites_name"), _name);
	}
	
	layer_text_text(layer_text_get_id("Assets_3", "sprites_type"), _title);
	layer_text_text(layer_text_get_id("Assets_3", "sprites_width"), string("WIDTH: {0}", sprite_get_width(_sprite)));
	layer_text_text(layer_text_get_id("Assets_3", "sprites_height"), string("HEIGHT: {0}", sprite_get_height(_sprite)));
	
	if renaming == 2 {
		keyboard_string = string_filter_positive_integer(keyboard_string);
		layer_text_text(layer_text_get_id("Assets_3", "sprites_pivot_x"), string("PIVOT X: {0}", keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_")));
	} else {
		layer_text_text(layer_text_get_id("Assets_3", "sprites_pivot_x"), string("PIVOT X: {0}", pivot_x));
	}
	if renaming == 3 {
		layer_text_text(layer_text_get_id("Assets_3", "sprites_pivot_y"), string("PIVOT Y: {0}", keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_")));
	} else {
		layer_text_text(layer_text_get_id("Assets_3", "sprites_pivot_y"), string("PIVOT Y: {0}", pivot_y));
	}
	
	layer_text_text(layer_text_get_id("Assets_3", "sprites_hurtbox"), string("SHOW HURTBOX: {0}", multiplexer(show_hurtbox, "FALSE", "TRUE")));
	
	layer_text_alpha(layer_text_get_id("Assets_3", "sprites_generate"), real(_type == 1));
	
	if _type == 1 and mouse_in_rectangle(493, 386, 956, 422) {
		set_cursor(cr_handpoint);
		if !notouch and mouse_check_button_pressed(mb_left) and show_question("By doing this, a green hurt sprite will be created (or replaced) AT THE BOTTOM OF THE SPRITE LIST and the sprites will be refreshed losing all unsaved changes SINCE THE SPRITE MENU WAS OPENED, do you wish to continue?") {
			if string_pos("_strip", origname) != 0 {
				origname = string_copy(origname, 1, string_pos("_strip", origname) - 1);
			}
			var _hurtpath = string("{0}/sprites/{1}_hurt_strip{2}.png", global.selected_path, origname, sprite_get_number(_sprite));
			archive_create(AP.SPRITES, _hurtpath, FT.SPRITE);
			archive_edit_sprite_existing(AP.SPRITES, _hurtpath, sprite_save_green_animated(_sprite), _hurtpath);
			room_restart();
		}
	}
	
	// buttons
	if mouse_in_rectangle(1167, 69, 1167 + 64*3, 69 + 64*0.73) {
		set_cursor(cr_handpoint);
		if !notouch and mouse_check_button_pressed(mb_left) {
			if all_loaded_sprites[selected][1] != origname {
				if _type == 1 {
					var _spr = archive_fetch_file(AP.SPRITES, _path);
					if _spr != undefined {
						archive_reposition(AP.SPRITES, _path, string("{0}/sprites/{1}", global.selected_path, all_loaded_sprites[selected][1]));
						
						var _numberframes = string_copy_alt(origname, string_pos("_strip", origname) + 6, string_pos(".png", origname));
						var _oriname = string_copy_alt(origname, 1, string_pos("_strip", origname));
						var _newname = string_copy_alt(all_loaded_sprites[selected][1], 1, string_pos("_strip", all_loaded_sprites[selected][1]));
						var _hurtpath = string("{0}/sprites/{1}_hurt_strip{2}.png", global.selected_path, _oriname, _numberframes);
						if archive_fetch_file(AP.SPRITES, _hurtpath) != undefined {
							archive_reposition(AP.SPRITES, _hurtpath, string("{0}/sprites/{1}_hurt_strip{2}.png", global.selected_path, _newname, sprite_get_number(_sprite)))
						}
						
					}
				} else {
					archive_reposition(AP.SPRITES, _path, string("{0}/sprites/{1}", global.selected_path, all_loaded_sprites[selected][1]))
				}
			}
			
			save_pivot(_name);
			room_restart();
		}
	}
	
	if mouse_in_rectangle(1167, 114, 1167 + 64*3, 114 + 64*0.73) {
		set_cursor(cr_handpoint);
		if !notouch and mouse_check_button_pressed(mb_left) and show_question("Warning: All unsaved sprite changes will be lost, continue anyways?") {
			all_loaded_sprites[selected][1] = origname;
			room_restart();
		}
	}
	
	if !mouse_check_button(mb_left) {
		notouch = false;
	}
}