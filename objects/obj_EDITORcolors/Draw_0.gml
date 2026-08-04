layer_text_blend(layer_text_get_id("Assets_1", "BackArrow1"), c_white);
layer_text_blend(layer_text_get_id("Assets_1", "CloseButton1"), c_white);
set_cursor(cr_default);

if mouse_in_rectangle(1305, 0, 1365, 60) {
	layer_text_blend(layer_text_get_id("Assets_1", "CloseButton1"), c_red);
	if mouse_check_button_pressed(mb_left) {game_end()}
}

if mouse_in_rectangle(0, 0, 90, 60) {
	layer_text_blend(layer_text_get_id("Assets_1", "BackArrow1"), c_yellow);
	if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Main)}
	set_cursor(cr_handpoint);
}

// Draw Event Functions
def_sprite_preview();
def_zoom_scroller();
def_spr_color_labels();
def_palette_list();
def_alt_list();






















