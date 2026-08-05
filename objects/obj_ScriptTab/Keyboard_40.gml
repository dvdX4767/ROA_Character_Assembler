if main_obj.tab != id exit;
if direction_buffer[3]{
	direction_buffer[@3]--;
	exit;
}else direction_buffer[@3] = cursor_hold_delay;
move_cursors(cursors, 3, data, self);