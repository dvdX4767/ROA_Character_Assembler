if main_obj.tab != id exit;
if direction_buffer[4]{
	direction_buffer[@4]--;
	exit;
}else direction_buffer[@4] = cursor_hold_delay;

if cursors_write_newline(cursors, data) trigger_modifications(filestruct, self);