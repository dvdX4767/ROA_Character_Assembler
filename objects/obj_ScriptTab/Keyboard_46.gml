if main_obj.tab != id exit;
if direction_buffer[5]{
	direction_buffer[@5]--;
	exit;
}else direction_buffer[@5] = cursor_hold_delay;

var _am = array_length(cursors);
var _g = 0;
repeat _am{
	if cursor_delete_selection(cursors[_g], cursors, data) trigger_modifications(filestruct, self);
	else if cursor_delete_char(cursors[_g], cursors, data, true) trigger_modifications(filestruct, self);
	_g++;
}
cursor_reset_qolpos(cursors)
cursor_check(cursors, data, self);