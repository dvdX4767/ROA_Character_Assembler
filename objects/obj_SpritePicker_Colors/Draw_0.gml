set_cursor(cr_default);
var _o = real(allow_empty);
scroll_y = clamp(scroll_y, -70 * (array_length(atarray) - 1), 0);
if allow_empty {
	var _ypos = 129 + scroll_y;
	var _col = multiplexer(mouse_in_rectangle(15, _ypos, 15 + 64 * 20.8, _ypos + 64), c_white, c_yellow);
	draw_sprite_ext(spr_UIbox, 0, 15, _ypos, 20.8, 1, 0, _col, 1);
	draw_sprite_ext(spr_no, 0, 23, _ypos + 9, 2.86, 2.86, 0, c_white, 1);
	draw_set_halign(fa_left);
	draw_text_ext_transformed(74, _ypos + 17, "CANCEL", 999, 99999, 0.35, 0.35, 0);
	if _col == c_yellow and !firstframe {
		set_cursor(cr_handpoint);
		if mouse_check_button_pressed(mb_left) {
			click_event(undefined);
		}
	}
}

for (var i = 0; i < array_length(atarray); i++) {
	var j = i + _o;
	var _ypos = 129 + 70 * j + scroll_y;
	var _col = multiplexer(mouse_in_rectangle(15, _ypos, 15 + 64 * 20.8, _ypos + 64), c_white, c_yellow);
	draw_sprite_ext(spr_UIbox, 0, 15, _ypos, 20.8, 1, 0, _col, 1);
	draw_sprite_ext(multiplexer(string_pos("_hurt", atarray[i]) == 0, spr_sprites_hurt, spr_sprites), 0, 23, _ypos + 9, 2.86, 2.86, 0, c_white, 1);
	draw_set_halign(fa_left);
	draw_text_ext_transformed(74, _ypos + 17, string_upper(atarray[i]), 999, 99999, 0.35, 0.35, 0);
	if _col == c_yellow and !firstframe {
		set_cursor(cr_handpoint);
		if mouse_check_button_pressed(mb_left) {
			click_event(atarray[i]);
		}
	}
}

firstframe = false;