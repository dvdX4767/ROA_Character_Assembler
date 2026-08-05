if main_obj.tab != id exit;
if parsetabs{
	parsetabs = 0;
	var _g = 0;
	draw_set_font(fnt_maplemono_SDF);
	var _mod = false;
	repeat array_length(data){
		var _new = string_replace_all(data[_g], "	", "    ");
		_mod |= (_new != data[@_g]);
		data[@_g] = _new;
		txtwidt = max(txtwidt, string_width(data[@_g]));
		_g++;
	}
	if array_length(data) == 0 array_push(data, "");
	parse_syntax(self);
	if _mod trigger_modifications(filestruct, self);
	parsed = 1;
}
showcursors++;

if parse_timer+1 parse_timer++;
if parse_timer == parse_timer_elapsed{
	parse_syntax(self);
	parse_timer = -1;
}

textscroll_speed = [lerp(textscroll_speed[0], 0, .1), lerp(textscroll_speed[1], 0, .1)];
if mouse_in_rectangle(314, 64, 314 + 1052, 64 + 703){
	textview = [clamp(textview[0], -txtwidt - 200 + 1052, 0), clamp(textview[1], -array_length(data)*20 - 200 + 703, 0)];
	if keyboard_check(vk_shift) textscroll_speed[@0] += 10*(mouse_wheel_up()-mouse_wheel_down());
	else textscroll_speed[@1] += 10*(mouse_wheel_up()-mouse_wheel_down());
	textview[@0] += textscroll_speed[0];
	textview[@1] += textscroll_speed[1];
	draw_set_font(fnt_maplemono_SDF);
	var _cwdt = string_width(" ");
	if mouse_check_button_pressed(mb_left){
		var _line = max(0, floor((mouse_y-64 - textview[1])/20));
		var _lns = array_length(data);
		var _pos = (_line >= _lns? string_length(data[max(0, _lns-1)]): clamp(floor((mouse_x-358 - textview[0])/_cwdt), 0, string_length(data[_line])));
		if _line >= _lns _line = _lns-1;
		if !keyboard_check(vk_control) cursors = [];
		create_cursor(_line, _pos);
	}
}

//keyboard string control
var _am = array_length(cursors);
if _am{
	if string_length(keyboard_string) != 2{
		var _g = 0;
		if string_length(keyboard_string) == 1{ //delete (backspace)
			repeat _am{
				if cursor_delete_selection(cursors[_g], cursors, data) trigger_modifications(filestruct, self);
				else if cursor_delete_char(cursors[_g], cursors, data, false) trigger_modifications(filestruct, self);
				_g++;
			}
		}else{ //write char
			cursors_write_char(cursors, data, string_char_at(keyboard_string, 3));
			trigger_modifications(filestruct, self);
		}
		cursor_reset_qolpos(cursors)
		cursor_check(cursors, data, self);
	}
	keyboard_string = "GG";
}

function create_cursor(_line, _pos){
	var _g = 0;
	repeat array_length(cursors){
		if cursors[_g].line == _line && cursors[_g].pos == _pos{
			if keyboard_check(vk_control) array_delete(cursors, _g, 1);
			return;
		}
		_g++;
	}
	var _latest = {line: _line, pos: _pos, qolpos: _pos, selection: -1};
	array_push(cursors, _latest);
	_g = 0;
	repeat array_length(cursors){
		if cursor_in_selection(_latest, cursors[_g]){
			if keyboard_check(vk_control) array_delete(cursors, _g, 1);
			return;
		}
		_g++;
	}
	keyboard_string = "GG";
	/*
	cursor = {
		line: int,
		pos: int,
		qolpos: int,
		selection: [pos, line] (-1 if not selecting)
	}
	*/
	cursor_check(cursors, data, self);
	array_sort(cursors, sort_cursors);
	trigger_change_buf_nosave(self);
	last_cursor = _latest;
}