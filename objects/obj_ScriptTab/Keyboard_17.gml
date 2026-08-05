if main_obj.tab != id exit;

var _num = 0;
if keyboard_check(ord("Z")) && !keyboard_check(vk_shift){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		var _idx = array_length(all_buffers)-2-undos;
		if _idx<0 return;
		var _g = 0;
		repeat array_length(all_container){
			variable_instance_set(self, all_container[_g], array_clone(all_buffers[_idx][_g]))
			_g++;
		}
		trigger_modifications_nobuf(filestruct, self);
		undos++;
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(ord("Y")) || (keyboard_check(ord("Z")) && keyboard_check(vk_shift)){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		if !undos return;
		var _idx = array_length(all_buffers)-undos;
		var _g = 0;
		repeat array_length(all_container){
			variable_instance_set(self, all_container[_g], array_clone(all_buffers[_idx][_g]))
			_g++;
		}
		trigger_modifications_nobuf(filestruct, self);
		undos--;
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(ord("A")){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		var _ln = array_length(data)-1;
		var _ps = string_length(data[array_length(data)-1]);
		cursors = [{line: _ln, pos: _ps, qolpos: _ps, selection: [0, 0]}];
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		cursor_check(cursors, data, self);
		trigger_change_buf_nosave(self);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(vk_backspace){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		if cursor_delete_char_cont(cursors, data, false) trigger_modifications(filestruct, self);
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		cursor_check(cursors, data, self);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(vk_delete){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		if cursor_delete_char_cont(cursors, data, true) trigger_modifications(filestruct, self);
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		cursor_check(cursors, data, self);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(ord("C")){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		cursors_copy_selection(cursors, data, false);
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(ord("X")){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		if cursors_copy_selection(cursors, data, true) trigger_modifications(filestruct, self);
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		cursor_check(cursors, data, self);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(ord("V")){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		if cursors_paste_selection(cursors, data) trigger_modifications(filestruct, self);
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		cursor_check(cursors, data, self);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(ord("D")){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		if cursors_duplicate_string(cursors, data) trigger_modifications(filestruct, self);
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		cursor_check(cursors, data, self);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;

_num++;
if keyboard_check(ord("K")){
	ctrl_cooldown[_num]--;
	if ctrl_cooldown[_num] == ctrl_cd_max-1 || !ctrl_cooldown[_num]{
		if cursors_toggle_comment(cursors, data) trigger_modifications(filestruct, self);
		ctrl_cooldown[_num] = max(ctrl_cooldown[_num], 2);
		cursor_check(cursors, data, self);
		exit;
	}
}else ctrl_cooldown[_num] = ctrl_cd_max;