if main_obj.tab != id exit;
if direction_buffer[2]{
	direction_buffer[@2]--;
	exit;
}else direction_buffer[@2] = cursor_hold_delay;
move_cursors(cursors, 2, data, self);