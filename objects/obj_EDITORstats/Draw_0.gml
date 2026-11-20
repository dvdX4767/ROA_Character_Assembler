set_cursor(cr_default);

if mouse_in_rectangle(0, 0, 90, 60) {
	set_cursor(cr_handpoint);
}

if mouse_in_uibox("Stats", "graphic_5A472B51", cr_handpoint, true) {
	page = 1;
}
if mouse_in_uibox("Stats", "graphic_614BB1D0", cr_handpoint, true) {
	page = 2;
}
if mouse_in_uibox("Stats", "graphic_1EED59D5", cr_handpoint, true) {
	page = 3;
}
if mouse_in_uibox("Stats", "graphic_21052892", cr_handpoint, true) {
	page = 4;
}

render_stat_pages();

if global.stats_modified {
	global.stats_modified = false;
	save_all_stats();
}