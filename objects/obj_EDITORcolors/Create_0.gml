// and i thought the attack editor was bad, lord have mercy
reset_drag();

instance_deactivate_object(obj_SpritePicker_Colors);
layer_set_visible(layer_get_id("SelectSprite"), false);
layer_set_visible(layer_get_id("Exploit"), false);


preview_surface = -1;
needs_update = true; 
scrollers = {
	pals: 0,
	alts: 0,
	cols: 0,
	pcol: [],
}
scroll_speed = 20;
zoom = 1;
zoom_max = 10;
selected_palette = 0;
selected_alt = 0;
selected = archive_fetch_file(AP.MAIN, get_full_path("portrait.png"));
can_interact = true;
selected_path = "portrait.png";
selection_return = "";
focus_secondary = ""; 
layer_set_visible("DELETE_THIS", false);
load_spriteref();
load_sprite_colors();
load_data();
check_alts();

function update_sprite_preview() {
	if (needs_update) {
		if (!surface_exists(preview_surface)) {
			preview_surface = surface_create(366, 345);
		}
		
		var _colors = sprite_colors;
		var _replace_colors = load_alt_colors(selected_alt);
		
		surface_set_target(preview_surface);
		draw_clear_alpha(c_black, 0);
		
		var _ret = colorswap_shader(_colors, _replace_colors);
		
		var _xbackoff = (sprite_get_width(selected) / 2) * zoom;
		var _ybackoff = (sprite_get_height(selected) / 2) * zoom;
		
		draw_sprite_ext(selected, (global.tick / 30), 183 - _xbackoff, 172 - _ybackoff, zoom, zoom, 0, c_white, 1);
		
		surface_free(_ret[0]);
		surface_free(_ret[1]);
		shader_reset();
		
		surface_reset_target();
		
		needs_update = false;
	}
}

function load_alt_colors(_selected) {
	if _selected == 0 {
		return sprite_colors;
	} else {
		var _new_cols = [];
		for (var i = 0; i < array_length(sprite_colors); i++) {
			var _color = sprite_colors[i];
			var _found = false;
			var _foundPalPos = -1;
			for (var j = 0; j < array_length(palettes); j++) {
				if array_contains(palettes[j].colors, _color) {
					_found = true;
					_foundPalPos = j;
					break;
				}
			}
			
			if _found {
				var _mainid = palettes[_foundPalPos].main_id;
				if _mainid != -1 {
					var _maincol = palettes[_foundPalPos].colors[_mainid];
					if _maincol == _color {
						array_push(_new_cols, alts[_selected].colors[_foundPalPos]);
					} else {
					var _newcol = alts[_selected].colors[_foundPalPos];
					var _diff_h = color_get_hue(_maincol) - color_get_hue(_color);
					var _target_hue = color_get_hue(_newcol) - _diff_h;
					
					array_push(_new_cols, make_colour_hsv(
						((_target_hue mod 256) + 256) mod 256,
						clamp(color_get_saturation(_newcol) - (color_get_saturation(_maincol) - color_get_saturation(_color)), 0, 255),
						clamp(color_get_value(_newcol) - (color_get_value(_maincol) - color_get_value(_color)), 0, 255)
					));
					}
				} else {
					array_push(_new_cols, make_colour_rgb(255, 0, 255));
				}
			} else {
				array_push(_new_cols, sprite_colors[i]);
			}
		}
		return _new_cols;
	}
}

function selection_end(_seltype) {
	switch _seltype {
		case "sprite":
			if focus_secondary == "SelectSpriteSpr" {
				if selection_return != "" {
					selected = selection_return[0];
					selected_path = selection_return[1];
					save_spriteref();
					load_sprite_colors();
					load_data();
				}
			}
			break;
	}
}

function save_spriteref() {
	var _fullp = get_full_path("scripts/colors.gml");
	var _line = archive_fetch_gml_string_startswith(AP.SCRIPTS, _fullp, "/*ASSEMBLER_SPRITEREF=", false);
	if _line == -2 {
		if !archive_create(AP.SCRIPTS, _fullp, FT.GML) {
			show_message("Unable to create colors.gml, the editor cannot be used until it's present");
			room_goto(CharEdit_Main);
			exit;
		}
		archive_edit_gml_newline(AP.SCRIPTS, _fullp, string("/*ASSEMBLER_SPRITEREF = {0};*/", (selected_path)));
	} elif _line == -1 {
		archive_edit_gml_newline(AP.SCRIPTS, _fullp, string("/*ASSEMBLER_SPRITEREF = {0};*/", (selected_path)));
	} else {
		archive_edit_gml_line(AP.SCRIPTS, _fullp, _line, string("/*ASSEMBLER_SPRITEREF = {0};*/", (selected_path)))
	}
}

function load_spriteref() {
	var _fullp = get_full_path("scripts/colors.gml");
	var _line = archive_fetch_gml_string_startswith(AP.SCRIPTS, _fullp, "/*ASSEMBLER_SPRITEREF=", false);
	var _file = archive_fetch_file(AP.SCRIPTS, _fullp);
	
	if _line == -2 {
		if !archive_create(AP.SCRIPTS, _fullp, FT.GML) {
			show_message("Unable to create colors.gml, the editor cannot be used until it's present");
			room_goto(CharEdit_Main);
			exit;
		}
		archive_edit_gml_newline(AP.SCRIPTS, _fullp, string("/*ASSEMBLER_SPRITEREF = {0};*/", (selected_path)));
	} elif _line == -1 {
		archive_edit_gml_newline(AP.SCRIPTS, _fullp, string("/*ASSEMBLER_SPRITEREF = {0};*/", (selected_path)));
	} else {
		var _rawline = string_unformat(_file[_line]);
		var _newspr = string_copy_alt(_rawline, 23, string_pos(";", _rawline));
		selected_path = _newspr;
		selected = archive_fetch_file(multiplexer(string_pos("sprites/", _newspr), AP.MAIN, AP.SPRITES), get_full_path(_newspr));
	}
}

function load_sprite_colors() {
	sprite_colors = [];
	for (var i = 0; i < sprite_get_number(selected); i++) {
		sprite_colors = array_union(sprite_colors, sprite_get_colors(selected, i));
	}
	
	colors_data = [];
	for (var i = 0; i < array_length(sprite_colors); i++) {
		var _cstruct = color_to_hsv(sprite_colors[i])
		array_push(colors_data, _cstruct);
		if _cstruct.val < 26 {
			array_delete(sprite_colors, i, 1);
			array_delete(colors_data, i, 1);
			i--;
		}
	}
}

function colorstatus(_colpos) {
	var _found = false;
	var _col = sprite_colors[_colpos];
	var i;
	for (i = 0; i < array_length(palettes); i++) {
		if array_contains(palettes[i].colors, _col) {
			_found = true;
			break;
		}
	}
	
	if _found {
		return 2;
	} else {
		return 0;
	}
}

function load_data() {
	var _file = archive_fetch_file(AP.SCRIPTS, get_full_path("scripts/colors.gml"));
	if _file == undefined {
		show_message("Missing colors.gml, a substitute has been created.")
		if !archive_create(AP.SCRIPTS, get_full_path("scripts/colors.gml"), FT.GML) {
			show_message("Something went wrong while creating colors.gml, this editor cannot be used until a colors.gml file is present");
			room_goto(CharEdit_Main);
			exit;
		}
		_file = archive_fetch_file(AP.SCRIPTS, get_full_path("scripts/colors.gml"));
	}
	
	_file = clear_gml_comments_except_lonely_ones(_file);
	palettes = [];
	alts = [undefined];
	
	var _count = 0;
	var _count2 = 5;
	for (var i = 0; i < array_length(_file); i++) {

		// Load palettes and alts
		palette_loader_step(_count, _file, i);
		alt_loader_step(_count2, _file, i)
		
	}
	
	// finalize palette data
	palette_finalizer();
}

function alt_loader_step(_count, _file, i) {
	var _line = _file[i];
	var _rawline = string_unformat(_line);
	
	if string_contains("set_color_profile_slot(", _rawline) {
		var _found = string_pos_alt("set_color_profile_slot(", _rawline);
		var _posA = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posA) + 1;
		var _posP = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posP) + 1;
		var _posR = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posR) + 1;
		var _posG = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posG) + 1;
		var _posB = string_copy_alt(_rawline, _found, string_pos_ext(")", _rawline, _found));
		
		if string_digits(_posA) == _posA and string_digits(_posP) == _posP and string_digits(_posR) == _posR and string_digits(_posG) == _posG and string_digits(_posB) == _posB
		   and real(_posA) != 0
		   and max(real(_posR), real(_posG), real(_posB)) > 25 and real(_posR) <= 255 and real(_posG) <= 255 and real(_posB) <= 255 {
			
			var _name = "UNNAMED " + string(_count);
			if i != 0 and string_starts_with(_file[i - 1], "//") {
				if string_starts_with(_file[i - 1], "// ") {
					_name = string_copy(_file[i - 1], 4, 22 + 4);
				} else {
					_name = string_copy(_file[i - 1], 0, 22);
				}
			}
			
			if real(_posA) >= array_length(alts) or alts[real(_posA)] == 0 or alts[real(_posA)] == undefined {
				alts[real(_posA)] = alt_create(_name);
				_count++;
			}
			
			alts[real(_posA)].colors[_posP] = make_colour_rgb(_posR, _posG, _posB);
		}
	}
}

function palette_loader_step(_count, _file, i) {
	var _line = _file[i];
	var _rawline = string_unformat(_line);
	if string_contains("set_color_profile_slot(0,", _rawline) {
		var _found = string_pos_alt("set_color_profile_slot(0,", _rawline);
		var _pos = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_pos) + 1;
		var _posR = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posR) + 1;
		var _posG = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posG) + 1;
		var _posB = string_copy_alt(_rawline, _found, string_pos_ext(")", _rawline, _found));
			
		if string_digits(_pos) == _pos and string_digits(_posR) == _posR and string_digits(_posG) == _posG and string_digits(_posB) == _posB and max(real(_posR), real(_posG), real(_posB)) > 25 and real(_posR) <= 255 and real(_posG) <= 255 and real(_posB) <= 255 {
			var _name = "UNNAMED " + string(_count);
			if i != 0 and string_starts_with(_file[i - 1], "//") {
				if string_starts_with(_file[i - 1], "// ") {
					_name = string_copy(_file[i - 1], 4, 22 + 4);
				} else {
					_name = string_copy(_file[i - 1], 0, 22);
				}
			}
			if real(_pos) >= array_length(palettes) or palettes[real(_pos)] == 0 or palettes[real(_pos)] == undefined {
				palettes[real(_pos)] = palette_create(_name);
				scrollers.pcol[real(_pos)] = 0;
				_count++;
			}
			palettes[real(_pos)].colors[0] = make_colour_rgb(_posR, _posG, _posB);
		}
	}
	if string_contains("set_color_profile_slot_range(", _rawline) {
		var _found = string_pos_alt("set_color_profile_slot_range(", _rawline);
		var _posP = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posP) + 1;
		var _posH = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posH) + 1;
		var _posS = string_copy_alt(_rawline, _found, string_pos_ext(",", _rawline, _found));
		_found = _found + string_length(_posS) + 1;
		var _posV = string_copy_alt(_rawline, _found, string_pos_ext(")", _rawline, _found));
		if string_digits(_posP) == _posP and string_digits(_posH) == _posH and string_digits(_posS) == _posS and string_digits(_posV) == _posV {
			if real(_posP) >= array_length(palettes) or palettes[real(_posP)] == 0 or palettes[real(_posP)] == undefined {
				palettes[real(_posP)] = palette_create("UNNAMED " + string(_count));
				_count++;
			}
			palettes[real(_posP)].max_diff_hsv = [_posH, _posS, _posV];
		}
	}
}

function palette_finalizer() {
	var _used = [];
	for (var i = 0; i < array_length(palettes); i++) {
		var _pal = palettes[i];
		if array_length(_pal.colors) == 0 {
			array_delete(palettes, i, 1);
			i--;
			continue;
		}
		if array_length(_pal.max_diff_hsv) == 0 {_pal.max_diff_hsv = [0, 0, 0]}
		var _col = _pal.colors[0];
		_pal.colors = [];
		_pal.main_id = -1;
		
		var _hue_diff = round(real(_pal.max_diff_hsv[0]) * 2.55);  
		var _sat_diff = round(real(_pal.max_diff_hsv[1]) * 2.55);
		var _val_diff = round(real(_pal.max_diff_hsv[2]) * 2.55);
		var _main_hue = color_get_hue(_col);  
		var _main_sat = color_get_saturation(_col);
		var _main_val = color_get_value(_col);


		for (var j = 0; j < array_length(colors_data); j++) {
			if !array_contains(_used, colors_data[j].hex) {
				var _colH = colors_data[j].hue;
				var _colS = colors_data[j].sat;
				var _colV = colors_data[j].val;
			
				if check_color_in_range(_colH, _colS, _colV, _main_hue, _main_sat, _main_val, _hue_diff, _sat_diff, _val_diff) {
					array_push(_used, colors_data[j].hex);
					array_push(_pal.colors, make_colour_hsv(_colH, _colS, _colV));
					if _colH == color_get_hue(_col) and _colS == color_get_saturation(_col) and _colV == color_get_value(_col) {
						_pal.main_id = array_length(_pal.colors) - 1;
					}
				}
			}
		}
	}
}

function check_color_in_range(_colH, _colS, _colV, _main_hue, _main_sat, _main_val, _hue_range, _sat_range, _val_range) {
	var _hue_diff = abs(_colH - _main_hue);
	
	return (min(_hue_diff, 255 - _hue_diff) <= _hue_range) and
	       (abs(_colS - _main_sat) <= _sat_range) and
	       (abs(_colV - _main_val) <= _val_range);
}

/// @desc Creates an empty color palette
function palette_create(_name) {
	return {
		name: _name,
		colors: [],
		main_id: 0,
		max_diff_hsv: []
	}
}

/// @desc Creates an empty alt palette
function alt_create(_name) {
	return {
		name: _name,
		colors: []
	}
}

function check_alts() {
	if array_length(alts) < 6 {
		while array_length(alts) < 6 {
			array_push(alts, alt_create(string("UNNAMED {0}", array_length(alts))));
		}
	}
}

function tick_scrollers() {
	var _scrDir = mouse_wheel_up() - mouse_wheel_down();
	if mouse_in_rectangle(337, 62, 729, 767) {
		scrollers.alts += _scrDir * scroll_speed;
	}
	if mouse_in_rectangle(729, 62, 982, 481) {
		scrollers.cols += _scrDir * scroll_speed;
	}
	var _scrollerst = false;
	for (var _i = 0; _i < array_length(palettes); _i++) {
		var _nowY = 99 + _i * 98 + scrollers.pals;
		if mouse_in_rectangle(99, clamp(55 + _nowY, 98, 755), 323, clamp(86 + _nowY, 98, 755)) {
			var _bef = scrollers.pcol[_i];
			scrollers.pcol[_i] += _scrDir * scroll_speed;
			scrollers.pcol[_i] = clamp(scrollers.pcol[_i], max(array_length(palettes[_i].colors) - 6, 0) * -35, 0);
			if scrollers.pcol[_i] != _bef {
				_scrollerst = true;
			}
		}
	}
	
	if mouse_in_rectangle(0, 62, 337, 767) and !_scrollerst {
		scrollers.pals += _scrDir * scroll_speed;
	}
	
	
	scrollers.alts = clamp(scrollers.alts, max(array_length(alts) - 6, 0) * -98, 0);
	scrollers.pals = clamp(scrollers.pals, max(array_length(palettes) - 6, 0) * -98, 0);
	scrollers.cols = clamp(scrollers.cols, max(array_length(colors_data) - 11, 0) * -35, 0);
}

// DRAW EVENT FUNCTIONS

function def_sprite_preview() {
	gpu_set_scissor(990, 70, 366, 345);
	
	if (surface_exists(preview_surface)) {
		draw_surface(preview_surface, 990, 70);
	}
	
	gpu_set_scissor_alt(0, 0, 9999, 9999);
}

function def_zoom_scroller() {
	if mouse_in_rectangle(984, 415, 1363, 444) {
		set_cursor(cr_size_we);
		if mouse_check_button(mb_left) {
			zoom = clamp(((mouse_x - 1002) / 334) * zoom_max, 0.5, zoom_max);
			needs_update = true;
		}
	}
	layer_sprite_x(get_ui_id("Assets_2", "graphic_41275CE3", true), 1002 + (334 * ((zoom) / (zoom_max))));

	if mouse_in_uibox("Assets_2", "graphic_5C1C3B17", cr_handpoint, true) {
		initialize_sprite_selector_colors(true, [archive_fetch_file(AP.MAIN, get_full_path("portrait.png")), ("portrait.png")], "Spr");
	}
}

function def_spr_color_labels() {
	gpu_set_scissor_alt(734, 84, 980, 477);
	for (var i = 0; i < array_length(sprite_colors); i++) {
		var _nowY = 86 + i * 35 + scrollers.cols;
	
		draw_color_label(738, _nowY, sprite_colors[i], 0.48, 0.48, c_white);
		draw_set_font(fnt_maplemono_SDF);
		draw_text_ext_transformed(772, 6 + _nowY, string(colors_data[i].hex), 999, 9999, 1, 1, 0);
		draw_sprite_ext(multiplexer(colorstatus(i), spr_cross, spr_warn, spr_check), 0, 961, 7 + _nowY, 2, 2, 0, c_white, 1);
		draw_set_font(fnt_jersey20_SDF);
	}
	gpu_set_scissor_alt(0, 0, 9999, 9999);
}

function def_palette_list() {
	gpu_set_scissor_alt(5, 98, 333, 755);
	var i;
	for (i = 0; i < array_length(palettes); i++) {
		var _nowY = 99 + i * 98 + scrollers.pals;
		var _pal = palettes[i];
		
		draw_sprite_ext(spr_UIbox, 0, 7, _nowY, 5, 1.46, 0, multiplexer(selected_palette == i, c_white, c_lime), 1);
		if _pal.main_id == -1 {
			draw_color_label(15, 9 + _nowY, c_black, 1.21, 1.21, c_red);
		} else {
			draw_color_label(15, 9 + _nowY, _pal.colors[_pal.main_id], 1.21, 1.21, c_yellow);
		}
		draw_text_ext_transformed(104, 9 + _nowY, _pal.name, 999, 9999, 0.24, 0.24, 0);
		draw_text_transformed_colour(103, 28 + _nowY, "[Left Click] Edit Color\n[Right Click] Set Main Color", 0.16, 0.16, 0, c_gray, c_gray, c_gray, c_gray, 1);
		def_pal_color_labels(_pal, _nowY, i);
		
		if mouse_in_rectangle(7, _nowY, 7 + (64 * 5), _nowY + (64 * 1.46)) and mouse_check_button_pressed(mb_left) {
			selected_palette = i;
		}
	}
	//294
	if array_length(palettes) < 8 {
		var _nowY = 99 + i * 98 + scrollers.pals;
		var _hovering = mouse_in_rectangle(7, _nowY, 328, 40 + _nowY);
		draw_sprite_ext(spr_UIbox, 0, 7, _nowY, 5, 0.64, 0, multiplexer(_hovering, c_white, c_yellow), 1);
		draw_sprite_ext(spr_plus, 0, 27, 21 + _nowY, 0.46, 0.46, 0, c_white, 1);
		draw_text_ext_transformed(44, 4 + _nowY, "ADD NEW", 999, 9999, 0.39, 0.39, 0);
		draw_text_ext_transformed_color(280, 4 + _nowY, string("{0}/8", array_length(palettes)), 999, 9999, 0.39, 0.39, 0, c_gray, c_gray, c_gray, c_gray, 1);
	
		if _hovering {
			set_cursor(cr_handpoint);
			if mouse_check_button_pressed(mb_left) {
				array_push(palettes, palette_create(string("UNNAMED {0}", array_length(palettes))));
				palettes[array_length(palettes) - 1].main_id = -1;
				array_push(scrollers.pcol, 0);
				for (var j = 1; j < array_length(alts); j++) {
					archive_edit_gml_newline(AP.SCRIPTS, get_full_path("scripts/colors.gml"), string("set_color_profile_slot({0}, {1}, 255, 0, 255)", j, array_length(palettes) - 1));
				}
			}
		}
	}
	
	gpu_set_scissor_alt(0, 0, 9999, 9999);
}

function def_pal_color_labels(_pal, _yoff, _i) {
	gpu_set_scissor_alt(99, clamp(55 + _yoff, 98, 755), 323, clamp(86 + _yoff, 98, 755));
	
	for (var i = 0; i < array_length(_pal.colors); i++) {
		var _nowX = 102 + i * 35 + scrollers.pcol[_i];
		var _col = multiplexer(_pal.main_id == i, c_white, c_yellow);
		if draw_color_label_interactive(_nowX, 55 + _yoff, _pal.colors[i], 0.5, 0.5, _col, cr_handpoint, false) {
			if mouse_check_button_pressed(mb_left) {
				//edit color
			} elif mouse_check_button_pressed(mb_right) {
				_pal.main_id = i;
				// edit the file with the new main
			}
		}
	}
	gpu_set_scissor_alt(5, 98, 333, 755);
}

function def_alt_list() {
	gpu_set_scissor_alt(339, 97, 723, 755);
	
	draw_sprite_ext(spr_UIbox, 0, 342, 99 + scrollers.alts, 5.9, 1.46, 0, multiplexer(selected_alt == 0, c_white, c_orange), 1);
	draw_text_ext_transformed(348, 1 + 99 + scrollers.alts, "DEFAULT", 999, 9999, 0.24, 0.24, 0);
	def_alt_color_labels(undefined, 99 + scrollers.alts, true);
	if mouse_in_rectangle(342, 99 + scrollers.alts, 342 + (64 * 5.9), 99 + scrollers.alts + (64 * 1.46)) and mouse_check_button_pressed(mb_left) {
		selected_alt = 0;
		needs_update = true;
	}
	var i;
	for (i = 1; i < array_length(alts); i++) {
		var _nowY = 99 + i * 98 + scrollers.alts;
		var _pal = alts[i];
		
		if _pal != undefined and _pal != 0 {
			draw_sprite_ext(spr_UIbox, 0, 342, _nowY, 5.9, 1.46, 0, multiplexer(selected_alt == i, c_white, c_orange), 1);
			draw_text_ext_transformed(348, 1 + _nowY, _pal.name, 999, 9999, 0.24, 0.24, 0);
			draw_text_transformed_colour(350, 28 + _nowY, "[Left Click] Edit Color", 0.16, 0.16, 0, c_gray, c_gray, c_gray, c_gray, 1);
			def_alt_color_labels(_pal, _nowY, false);
		}
		
		if mouse_in_rectangle(342, _nowY, 342 + (64 * 5.9), _nowY + (64 * 1.46)) and mouse_check_button_pressed(mb_left) {
			selected_alt = i;
			needs_update = true;
		}
	}
	
		//294
	var _nowY = 99 + i * 98 + scrollers.alts;
	var _hovering = mouse_in_rectangle(342, _nowY, 719, 40 + _nowY);
	draw_sprite_ext(spr_UIbox, 0, 343, _nowY, 5.89, 0.64, 0, multiplexer(_hovering, c_white, c_yellow), 1);
	draw_sprite_ext(spr_plus, 0, 363, 21 + _nowY, 0.46, 0.46, 0, c_white, 1);
	draw_text_ext_transformed(381, 4 + _nowY, "ADD NEW ALT", 999, 9999, 0.39, 0.39, 0);
	draw_set_halign(fa_right);
	draw_text_ext_transformed_color(712, 4 + _nowY, string("{0}/32", array_length(alts)), 999, 9999, 0.39, 0.39, 0, c_gray, c_gray, c_gray, c_gray, 1);
	draw_set_halign(fa_left);
	
	if _hovering {
		set_cursor(cr_handpoint);
		if mouse_check_button_pressed(mb_left) {
			array_push(palettes, palette_create(string("UNNAMED {0}", array_length(palettes))));
			palettes[array_length(palettes) - 1].main_id = -1;
			for (var j = 1; j < array_length(alts); j++) {
				archive_edit_gml_newline(AP.SCRIPTS, get_full_path("scripts/colors.gml"), string("set_color_profile_slot({0}, {1}, 255, 0, 255)", j, array_length(palettes) - 1));
			}
		}
	}
	
	gpu_set_scissor_alt(0, 0, 9999, 9999);
}

function def_alt_color_labels(_pal, _yoff, _isdef) {
	gpu_set_scissor_alt(347, clamp(43 + _yoff, 97, 755), 714, clamp(86 + _yoff, 97, 755));
	if !_isdef {
		for (var i = 0; i < array_length(_pal.colors); i++) {
			var _nowX = 350 + i * 45;
			if draw_color_label_interactive(_nowX, 45 + _yoff, _pal.colors[i], 0.63, 0.63, c_yellow, cr_handpoint, false) {
				if mouse_check_button_pressed(mb_left) {
					// edit
				}
			}
		}
	} else {
		for (var i = 0; i < array_length(palettes); i++) {
			var _nowX = 350 + i * 45;
			if palettes[i].main_id != -1 {
				draw_color_label(_nowX, 45 + _yoff, palettes[i].colors[palettes[i].main_id], 0.63, 0.63, c_yellow);
			}
		}
	}
	gpu_set_scissor_alt(339, 97, 723, 755);
}