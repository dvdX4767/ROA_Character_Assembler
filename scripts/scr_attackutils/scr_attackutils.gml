function mouse_in_uibox(_asslayer, _assname, _cursortype, _detectclick) {
	var _layer = layer_sprite_get_id(_asslayer, _assname);
	var _startx = layer_sprite_get_x(_layer);
	var _starty = layer_sprite_get_y(_layer);
	var _endx = _startx + 64 * layer_sprite_get_xscale(_layer);
	var _endy = _starty + 64 * layer_sprite_get_yscale(_layer);
	if mouse_in_rectangle(_startx, _starty, _endx, _endy) {
		set_cursor(_cursortype);
		return !_detectclick or mouse_check_button_pressed(mb_left);
	}
	return false;
}

function INITIALIZE() {
	MEGARAMORIG = {};
	
	var _all = archive_fetch(AP.ATTACKS);
	
	for (var i = 0; i < array_length(_all); i++) {
		if !string_starts_with(filename_name(_all[i].path), "_") {
			var _name = string_copy(filename_name(_all[i].path), 1, string_pos(".", filename_name(_all[i].path)) - 1);
			MEGARAMORIG[$ _name] = dissect_file(_all[i].file, _name);
			if MEGARAMORIG[$ _name] == undefined {
				return false;
			}
		}
	}
	//var _path = string("{0}/scripts/attacks/", global.selected_path);
	//var _all = get_all_files(_path);
	
	//for (var i = 0; i < array_length(_all); i++) {
	//	if !string_starts_with(_all[i], "_") {
	//		var _name = string_copy(_all[i], 1, string_pos(".", _all[i]) - 1);
	//		MEGARAMORIG[$ _name] = dissect_file(_path, _name);
	//		if MEGARAMORIG[$ _name] == undefined {
	//			return false;
	//		}
	//	}
	//}
	return true;
}

function dissect_file(_file, _name) {
	
	var _dissected = {
		name: _name,
		display_name: string_upper(_name),
		mandatory: is_mandatory(_name),
		data: {},
		windows: [],
		hitboxes: [],
	};
	
	var _unsortedwin = [];
	var _unsortedhbs = [];
	
	for (var i = 0; i < array_length(_file); i++) {
		try {
			var _line = _file[i];						// the whole shabang	 Ex: set_attack_value(AT_DTILT, AG_NUM_WINDOWS, 3); // comment yay
			var _rawline = string_replace_all(_line, " ", "");				// the raw string		 Ex: set_attack_value(AT_DTILT,AG_NUM_WINDOWS,3);
			var _linecomment = undefined;									// the eventual comment	 Ex: comment yay
			if string_pos("//", _line) != 0 {
				_rawline = string_copy(_line, 1, string_pos("//", _line) - 1);
				_rawline = string_replace_all(_rawline, " ", "");
				_linecomment = string_copy(_line, string_pos("//", _line) + 2, 9999);
			}
		
			// if it is a set_attack_value()
			var _strtocheck = string("set_attack_value(AT_{0},", string_upper(_name));
			if string_pos(_strtocheck, _rawline) != 0 {
				var _len = string_length(_strtocheck) + 1;
				var _len2 = string_pos_ext(",", _rawline, string_length(_strtocheck) + 1);
				var _key = string_copy(_rawline, _len, _len2 - _len); //		 			Ex: AG_NUM_WINDOWS
				_len = string_length(_strtocheck + _key) + 2;
				_len2 = string_pos_ext(");", _rawline, string_length(_strtocheck + _key) + 2);
				var _value = string_copy(_rawline, _len, _len2 - _len); // Ex: 3
				_dissected.data[$ _key] = _value;
			}
		
			// if it is a set_window_value()
			_strtocheck = string("set_window_value(AT_{0},", string_upper(_name));
			if string_pos(_strtocheck, _rawline) != 0 {
				var _len = string_length(_strtocheck) + 1;
				var _len2 = string_pos_ext(",", _rawline, string_length(_strtocheck) + 1);
				var _arrnum = real(string_copy(_rawline, _len, _len2 - _len)); //		 			Ex: 1
				_len = string_length(_strtocheck + string(_arrnum)) + 2;
				_len2 = string_pos_ext(",", _rawline, string_length(_strtocheck + string(_arrnum)) + 2);
				var _key = string_copy(_rawline, _len, _len2 - _len); // Ex: AG_WINDOW_LENGTH
			
				_len = string_length(_strtocheck + string(_arrnum) + _key) + 3;
				_len2 = string_pos_ext(");", _rawline, _len);
				var _value = string_copy(_rawline, _len, _len2 - _len); // Ex: 3
				if _key == "AG_WINDOW_LENGTH" { // has to be there for sure
					if _linecomment == undefined {
						_dissected.windows[_arrnum - 1] = { // indexes start at 1, arrays start at 0
							name: string("WINDOW {0}", _arrnum)
						};
					} else {
						_dissected.windows[_arrnum - 1] = {
							name: _linecomment
						};
					}
				}
				array_push(_unsortedwin, [_arrnum, _key, _value]);
			}
			// if it is a set_hitbox_value()
			_strtocheck = string("set_hitbox_value(AT_{0},", string_upper(_name));
			if string_pos(_strtocheck, _rawline) != 0 {
				var _len = string_length(_strtocheck) + 1;
				var _len2 = string_pos_ext(",", _rawline, string_length(_strtocheck) + 1);
			
				var _arrnum;
				_arrnum = real(string_copy(_rawline, _len, _len2 - _len));
			
				_len = string_length(_strtocheck + string(_arrnum)) + 2;
				_len2 = string_pos_ext(",", _rawline, string_length(_strtocheck + string(_arrnum)) + 2);
				var _key = string_copy(_rawline, _len, _len2 - _len); // Ex: HG_HITBOX_TYPE
			
				_len = string_length(_strtocheck + string(_arrnum) + _key) + 3;
				_len2 = string_pos_ext(");", _rawline, _len);
				var _value = string_copy(_rawline, _len, _len2 - _len); // Ex: 3
				if _key == "HG_HITBOX_TYPE" { // HAS to be there for sure
					if _linecomment == undefined {
						_dissected.hitboxes[_arrnum - 1] = {
							name: string("HITBOX {0}", _arrnum)
						};
					} else {
						_dissected.hitboxes[_arrnum - 1] = {
							name: _linecomment
						};
					}
				}
				array_push(_unsortedhbs, [_arrnum, _key, _value]);
			}
		
		}  catch (_err) {
			show_debug_message(_err.message);
			problems = true;
			continue;
		}
	}
	
	// kinda not needed tbf
	//array_sort(_unsortedwin, function(_a, _b) { 
	//	return real(_a[0]) - real(_b[0]);
	//});
	//array_sort(_unsortedhbs, function(_a, _b) {
	//	return real(_a[0]) - real(_b[0]);
	//});
	try {
		for (var i = 0; i < array_length(_unsortedwin); i++) {
			var _position = real(_unsortedwin[i][0]) - 1;
			var _structkey = _unsortedwin[i][1];
			var _valueto = _unsortedwin[i][2];
			if !(_structkey == undefined or _structkey == "") {
				_dissected.windows[_position][$ _structkey] = _valueto;
				show_debug_message(string("Inserted {0} into WINDOW {1} with value {2}", _structkey, _position, _valueto));
			} else {
				show_debug_message(string("SOMETHING HAPPENED FOR {0} TO BE EMPTY, AT WD {1} AND VALUE {2}, FOR MOVE {3}", _structkey, _position, _valueto, _name));
			}
		
		}
	
		for (var i = 0; i < array_length(_unsortedhbs); i++) {
			var _idiot1 = _unsortedhbs[i][1];
			var _idiot2 = _unsortedhbs[i][0];
			var _idiot3 = _unsortedhbs[i][2];
			_dissected.hitboxes[real(_idiot2) - 1][$ _idiot1] = _idiot3;
			show_debug_message(string("Inserted {0} into HITBOX {1} with value {2}", _unsortedhbs[i][1], _unsortedhbs[i][0], _unsortedhbs[i][2]));
		}
	} catch (_err) {
		show_message("A file failed to load, probably due to an invalid custom format used. \nThe attack editor cannot be used for this character.");
		show_debug_message("\nBUM ASS PARSE ERROR: " + string(_err.message));
		room_goto(CharEdit_Main);
		exit;
	}
	
	return _dissected;
}

function get_fresh_attack_struct(_name) {
	var _dissected = {
		name: _name,
		display_name: string_upper(_name),
		mandatory: is_mandatory(_name),
		data: {},
		windows: [],
		hitboxes: [],
	};
	return _dissected;
}

function is_mandatory(_name) {
	switch _name {
		case "bair":
		case "dair":
		case "dattack":
		case "dspecial":
		case "dstrong":
		case "dtilt":
		case "fair":
		case "fspecial":
		case "fstrong":
		case "ftilt":
		case "jab":
		case "nair":
		case "nspecial":
		case "taunt":
		case "uair":
		case "uspecial":
		case "ustrong":
		case "utilt":
			return true;
		default:
			return false;
	}
}

function draw_attack_list() {
	var _allattacks = struct_get_names(MEGARAM);
	array_sort(_allattacks, true);
	global.scroll_y = clamp(global.scroll_y, -105 * (array_length(_allattacks) - 1), 0);
	var i = 0;
	for (i = 0; i < array_length(_allattacks); i++) {
		var _ypos = 78 + 105 * i + global.scroll_y;
		var _atkref = MEGARAM[$ _allattacks[i]];
		var _col = multiplexer(_atkref.mandatory, c_lime, c_orange);
		var _col2 = multiplexer(selected_attack == _atkref.name, c_white, c_aqua)
		draw_sprite_ext(spr_UIbox, 0, 12, _ypos, 3.5, 1.5, 0, _col2, 1);
		draw_sprite_ext(spr_attacks, 0, 21, _ypos + 11, 4.5, 4.5, 0, c_white, 1);
		draw_set_halign(fa_left);
		draw_text_ext_transformed(104, _ypos + 15, _atkref.display_name, 99, 9999, 0.33, 0.33, 0);
		draw_text_ext_transformed_color(104, _ypos + 38, multiplexer(_atkref.mandatory, "EXTRA", "MANDATORY"), 99, 9999, 0.28, 0.28, 0, _col, _col, _col, _col, 1);
		if is_focused("nothing", "") and mouse_in_rectangle(12, _ypos, 12 + 64 * 3.5, _ypos + 64 * 1.5) {
			set_cursor(cr_handpoint);
			if  mouse_check_button_pressed(mb_left) {
				selected_attack = _atkref.name;
			}
		}
	}
	layer_sprite_y(get_ui_id("Main", "atks_newatk", true), 78 + 105 * i + global.scroll_y);
	layer_sprite_y(get_ui_id("Main", "atks_plus1", true), 78 + 46 + 105 * i + global.scroll_y);
}

function add_attack_click() {
	if is_focused("nothing", "") and mouse_in_uibox("Main", "atks_newatk", cr_handpoint, true) {
		initialize_attack_selector(true, "");
	}
}

function get_ui_id(_asslayer, _assname, _isspriteortext) {
	if _isspriteortext {
		return layer_sprite_get_id(_asslayer, _assname);
	} else {
		return layer_text_get_id(_asslayer, _assname);
	}
}

function initialize_attack_selector(_allowEmptySelection, _defaultValue) {
	focus_secondary = "SelectAttack";
	layer_set_visible(layer_get_id("SelectAttack"), true);
	layer_text_text(get_ui_id("Exploit", "atk_addnew", false), "ADD NEW ATTACK")
	layer_set_visible(layer_get_id("Exploit"), true);
	instance_activate_object(obj_AttackPicker);
	obj_AttackPicker.allow_empty = _allowEmptySelection;
	obj_AttackPicker.default_value = _defaultValue;
	obj_AttackPicker.trigger();
}

function initialize_sprite_selector(_allowEmptySelection, _defaultValue, _actionID, _ass = id) {
	_ass.focus_secondary = "SelectSprite" + _actionID;
	layer_set_visible(layer_get_id("SelectSprite"), true);
	layer_text_text(get_ui_id("Exploit", "atk_addnew", false), "SELECT SPRITE")
	layer_set_visible(layer_get_id("Exploit"), true);
	instance_activate_object(obj_SpritePicker);
	obj_SpritePicker.allow_empty = _allowEmptySelection;
	obj_SpritePicker.default_value = _defaultValue;
	obj_SpritePicker.trigger();
}

function initialize_sprite_selector_colors(_allowEmptySelection, _defaultValue, _actionID, _ass = id) {
	_ass.focus_secondary = "SelectSprite" + _actionID;
	layer_set_visible(layer_get_id("SelectSprite"), true);
	layer_text_text(get_ui_id("Exploit", "atk_addnewC", false), "SELECT SPRITE")
	layer_set_visible(layer_get_id("Exploit"), true);
	instance_activate_object(obj_SpritePicker_Colors);
	obj_SpritePicker_Colors.allow_empty = _allowEmptySelection;
	obj_SpritePicker_Colors.default_value = _defaultValue;
	obj_SpritePicker_Colors.trigger();
}

function initialize_window_selector(_allowEmptySelection, _defaultValue, _actionID, _ass = id) {
	_ass.focus_secondary = "SelectWindow" + _actionID;
	layer_set_visible(layer_get_id("SelectWindow"), true);
	layer_text_text(get_ui_id("Exploit", "atk_addnew", false), "SELECT WINDOW")
	layer_set_visible(layer_get_id("Exploit"), true);
	instance_activate_object(obj_WindowPicker);
	obj_WindowPicker.allow_empty = _allowEmptySelection;
	obj_WindowPicker.default_value = _defaultValue;
	obj_WindowPicker.trigger();
}

function initialize_sound_selector(_allowEmptySelection, _defaultValue, _actionID, _ass = id) {
	_ass.focus_secondary = "SelectSound" + _actionID;
	layer_set_visible(layer_get_id("SelectSound"), true);
	layer_text_text(get_ui_id("Exploit", "atk_addnew", false), "SELECT SOUND EFFECT")
	layer_set_visible(layer_get_id("Exploit"), true);
	instance_activate_object(obj_SoundPicker);
	obj_SoundPicker.allow_empty = _allowEmptySelection;
	obj_SoundPicker.default_value = _defaultValue;
	obj_SoundPicker.trigger();
}

function initialize_vfx_selector(_allowEmptySelection, _defaultValue, _actionID, _ass = id) {
	_ass.focus_secondary = "SelectVFX" + _actionID;
	layer_set_visible(layer_get_id("SelectVFX"), true);
	layer_text_text(get_ui_id("Exploit", "atk_addnew", false), "SELECT VISUAL EFFECT")
	layer_set_visible(layer_get_id("Exploit"), true);
	instance_activate_object(obj_VFXPicker);
	obj_VFXPicker.allow_empty = _allowEmptySelection;
	obj_VFXPicker.default_value = _defaultValue;
	obj_VFXPicker.trigger();
}

function is_focused( _focus, _secondary = -1, _instance = id) {
	return (_instance.focus == _focus) and (_secondary == -1 or _secondary == _instance.focus_secondary);
}

function text_button_color(_asslayer, _assname, _condition, _colfalse, _coltrue) {
	layer_text_blend(get_ui_id(_asslayer, _assname, false), multiplexer(_condition, _colfalse, _coltrue));
}

function sprite_button_color(_asslayer, _assname, _condition, _colfalse, _coltrue) {
	layer_sprite_blend(get_ui_id(_asslayer, _assname, true), multiplexer(_condition, _colfalse, _coltrue));
}

function initialize_struct_key(_struct, _key, _value) {
	if !struct_exists(_struct, _key) {
		_struct[$ _key] = _value;
	}
}

function button_change_var(_struct, _key, _value, _asslayer, _assname) {
	if mouse_in_uibox(_asslayer, _assname, cr_handpoint, true) {
		_struct[$ _key] = _value;
	}
}

function get_quoted_text(_str) {
	var _pos1 = string_pos("\"", _str);
	if (_pos1 == 0) return "";
	
	var _pos2 = string_pos_ext("\"", _str, _pos1 + 1);
	if (_pos2 == 0) return "";
	
	return string_copy(_str, _pos1 + 1, _pos2 - _pos1 - 1);
}

function button_boolean(_asslayer, _assname, _asstext, _assstruct, _asskey) {
	if mouse_in_uibox(_asslayer, _assname, cr_handpoint, true) {
		_assstruct[$ _asskey] = !_assstruct[$ _asskey];
	}
	layer_text_blend(get_ui_id(_asslayer, _asstext, false), multiplexer(_assstruct[$ _asskey], c_red, c_lime));
	layer_text_text(get_ui_id(_asslayer, _asstext, false), multiplexer(_assstruct[$ _asskey], "FALSE", "TRUE"));
}

function button_boolean_reverse(_asslayer, _assname, _asstext, _assstruct, _asskey) {
	if mouse_in_uibox(_asslayer, _assname, cr_handpoint, true) {
		_assstruct[$ _asskey] = !_assstruct[$ _asskey];
	}
	layer_text_blend(get_ui_id(_asslayer, _asstext, false), multiplexer(_assstruct[$ _asskey], c_lime, c_red));
	layer_text_text(get_ui_id(_asslayer, _asstext, false), multiplexer(_assstruct[$ _asskey], "TRUE", "FALSE"));
}

function rename_int_button(_asslayer, _assname, _asstext, _asstruct, _asskey, _assrenameid, _inst = id, _mainfocus = "nothing") {
	//show_debug_message(_inst.focus_secondary)
	if mouse_in_uibox(_asslayer, _assname, cr_beam, true) {
		//show_debug_message("evhe");
		_inst.focus_secondary = string("RENAME_{0}", _assrenameid);
		keyboard_string = string(_asstruct[$ _asskey]);
	} else if is_focused(_mainfocus, string("RENAME_{0}", _assrenameid), _inst) {
		//show_debug_message("ddddd");
		keyboard_string = string_filter_positive_integer(keyboard_string);
		layer_text_text(get_ui_id(_asslayer, _asstext, false), keyboard_string + multiplexer(global.tick mod 60 > 30, "  ", "_"));
		if keyboard_check_pressed(vk_enter) or mouse_check_button_pressed(mb_left) {
			keyboard_string = string_filter_positive_integer(keyboard_string);
			if keyboard_string != "" {
				_asstruct[$ _asskey] = real(keyboard_string);
			}
			_inst.focus_secondary = "";
		}
	} else {
		layer_text_text(get_ui_id(_asslayer, _asstext, false), _asstruct[$ _asskey]);
	}
}

function rename_float_button(_asslayer, _assname, _asstext, _asstruct, _asskey, _assrenameid, _inst = id, _mainfocus = "nothing") {
	//show_debug_message(_inst.focus_secondary)
	if mouse_in_uibox(_asslayer, _assname, cr_beam, true) {
		//show_debug_message("evhe");
		_inst.focus_secondary = string("RENAME_{0}", _assrenameid);
		keyboard_string = string(_asstruct[$ _asskey]);
	} else if is_focused(_mainfocus, string("RENAME_{0}", _assrenameid), _inst) {
		//show_debug_message("ddddd");
		keyboard_string = string_filter_float(keyboard_string);
		layer_text_text(get_ui_id(_asslayer, _asstext, false), keyboard_string + multiplexer(global.tick mod 60 > 30, "  ", "_"));
		if keyboard_check_pressed(vk_enter) or mouse_check_button_pressed(mb_left) {
			keyboard_string = string_filter_float(keyboard_string);
			if keyboard_string != "" {
				_asstruct[$ _asskey] = real(keyboard_string);
			}
			_inst.focus_secondary = "";
		}
	} else {
		layer_text_text(get_ui_id(_asslayer, _asstext, false), _asstruct[$ _asskey]);
	}
}

function rename_string_button(_asslayer, _assname, _asstext, _asstruct, _asskey, _assrenameid, _inst = id, _mainfocus = "nothing") {
	//show_debug_message(_inst.focus_secondary)
	if mouse_in_uibox(_asslayer, _assname, cr_beam, true) {
		//show_debug_message("evhe");
		_inst.focus_secondary = string("RENAME_{0}", _assrenameid);
		keyboard_string = string(_asstruct[$ _asskey]);
	} else if is_focused(_mainfocus, string("RENAME_{0}", _assrenameid), _inst) {
		//show_debug_message("ddddd");
		layer_text_text(get_ui_id(_asslayer, _asstext, false), keyboard_string + multiplexer(global.tick mod 60 > 30, "  ", "_"));
		if keyboard_check_pressed(vk_enter) or mouse_check_button_pressed(mb_left) {
			if keyboard_string != "" {
				_asstruct[$ _asskey] = keyboard_string;
			}
			_inst.focus_secondary = "";
		}
	} else {
		layer_text_text(get_ui_id(_asslayer, _asstext, false), _asstruct[$ _asskey]);
	}
}

function correct_value_between(_struct, _key, _min, _max) {
	initialize_struct_key(_struct, _key, _min);
	var _val = _struct[$ _key];
	if (is_string(_val)) {
		try {
			_val = real(_val);
		} catch (_err) {
			_val = _min;
		}
	}
	if (is_real(_val)) {
		_struct[$ _key] = clamp(_val, _min, _max);
	} else {
		_struct[$ _key] = _min;
	}
}

function correct_value_bool(_struct, _key) {
	initialize_struct_key(_struct, _key, false);
	var _val = _struct[$ _key];
	if (is_string(_val)) {
		try {
			_val = bool(_val);
		} catch (_err) {
			_val = false;
		}
	}
	if !is_bool(_val) {
		_struct[$ _key] = false;
	}
}

function text_obscure(_asslayer, _assname, _asscondition) {
	layer_text_blend(get_ui_id(_asslayer, _assname, false), multiplexer(_asscondition, c_gray, c_white));
}

function get_window_name(_winID, _inst = id) {
	if _winID == -1 {
		return "NO WINDOW";
	}
	var _movestruct = _inst.MEGARAM[$ _inst.selected_attack];
	return _movestruct.windows[_winID].name;
}