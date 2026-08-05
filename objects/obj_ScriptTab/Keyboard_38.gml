if main_obj.tab != id exit;
if direction_buffer[1]{
	direction_buffer[@1]--;
	exit;
}else direction_buffer[@1] = cursor_hold_delay;
move_cursors(cursors, 1, data, self);