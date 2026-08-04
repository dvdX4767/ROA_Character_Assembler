function draw_color_label(_x, _y, _color, _xscale, _yscale, _outlinecolor) {
	draw_sprite_ext(spr_white, 0, _x, _y, _xscale, _yscale, 0, _color, 1);
	draw_sprite_ext(spr_UIbox_clear, 0, _x, _y, _xscale, _yscale, 0, _outlinecolor, 1);
}

function draw_color_label_interactive(_x, _y, _color, _xscale, _yscale, _outlinecolor, _cursortype, _detectclick, _debug = false) {
	draw_sprite_ext(spr_white, 0, _x, _y, _xscale, _yscale, 0, _color, 1);
	draw_sprite_ext(spr_UIbox_clear, 0, _x, _y, _xscale, _yscale, 0, _outlinecolor, 1);
	if mouse_in_rectangle(_x, _y, _x + 64 * _xscale, _y + 64 * _yscale, _debug) {
		set_cursor(_cursortype);
		if _detectclick {
			return mouse_check_button_pressed(mb_left);
		} else {
			return true;
		}
	} else {
		return false;
	}
}