if main_obj.tab != id exit;
if direction_buffer[6]{
	direction_buffer[@6]--;
	exit;
}else direction_buffer[@6] = cursor_hold_delay;

if keyboard_check(vk_shift){
	if cursor_remove_tabs(cursors, data) trigger_modifications(filestruct, self);
}else if cursor_write_tabs(cursors, data) trigger_modifications(filestruct, self);
cursor_reset_qolpos(cursors)
cursor_check(cursors, data, self);