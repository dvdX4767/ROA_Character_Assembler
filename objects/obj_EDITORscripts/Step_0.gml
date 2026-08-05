layer_text_blend(layer_text_get_id("MenuBar", "BackArrow1_4"), c_white);
layer_text_blend(layer_text_get_id("MenuBar", "CloseButton1_4"), c_white);

if mouse_in_rectangle(1305, 0, 1365, 60) {
	layer_text_blend(layer_text_get_id("MenuBar", "CloseButton1_4"), c_red);
	if mouse_check_button_pressed(mb_left) {game_end()}
}

if mouse_in_rectangle(0, 0, 90, 60) {
	layer_text_blend(layer_text_get_id("MenuBar", "BackArrow1_4"), c_yellow);
	if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Main)}
}

//handle scripts area
scripts_size[@1] = 20*(1 + array_length(script_pickers) + expanded_attacks*array_length(attack_pickers));
scriptscroll_speed = [lerp(scriptscroll_speed[0], 0, .1), lerp(scriptscroll_speed[1], 0, .1)];
if mouse_in_rectangle(0, 62, 294, 768){
	scriptview = [clamp(scriptview[0], -scripts_size[0] + 274, 0), clamp(scriptview[1], -scripts_size[1] + 690, 0)];
	if keyboard_check(vk_shift) scriptscroll_speed[@0] += 10*(mouse_wheel_up()-mouse_wheel_down());
	else scriptscroll_speed[@1] += 10*(mouse_wheel_up()-mouse_wheel_down());
	scriptview[@0] += scriptscroll_speed[0];
	scriptview[@1] += scriptscroll_speed[1];
	if mouse_check_button_pressed(mb_left){ //pick and open scripts
		draw_set_font(fnt_maplemono_SDF);
		var c_id = floor((mouse_y-70 - scriptview[1])/20)
		if c_id == clamp(c_id, 0, scripts_size[1]/20 - 1){
			var but = (c_id == 0? -1: (expanded_attacks? (c_id-1 < array_length(attack_pickers)? attack_pickers[c_id-1]: script_pickers[c_id-1-array_length(attack_pickers)]): script_pickers[c_id-1]));
			if mouse_x == clamp(mouse_x, 0, (but == -1? string_width("|- attacks/"): string_width(but.full_string))){
				if select_id == c_id{
					if c_id == 0 expanded_attacks = !expanded_attacks;
					else create_tab(but);
				}else select_id = c_id;
			}else select_id = -1;
		}else select_id = -1;
		draw_set_font(fnt_jersey20_SDF);
	}
}else if mouse_check_button_pressed(mb_left) select_id = -1;

//handle tab area
tab_view_speed = lerp(tab_view_speed, 0, .1);
if mouse_in_rectangle(312, 0, 986+312, 60){
	tab_view = clamp(tab_view, -array_length(tabs)*200 + 986, 0)
	tab_view_speed += 10*(mouse_wheel_up()-mouse_wheel_down());
	tab_view += tab_view_speed;
	hovered_x = -1;
	
	var _g = 0;
	repeat array_length(tabs){
		var tb = tabs[_g];
		if mouse_in_rectangle(tab_view + 314 + 200*_g + 5, 10, tab_view + 314 + 200*_g + 190, 62){
			if mouse_in_rectangle(tab_view + 314 + 200*_g + 165, 30, tab_view + 314 + 200*_g + 185, 48) hovered_x = _g;
			if mouse_check_button_pressed(mb_left){
				if hovered_x == _g{
					instance_destroy(tb);
					array_delete_value(tabs, tb);
					if tab == tb{
						if array_length(tabs) tab = tabs[array_length(tabs)-1]
						else tab = noone;
					}
					break;
				}else{
					tab = tb;
					tab.showcursors = 0;
				}
			}
		}
		_g++;
	}
}

function create_tab(scrpt){
	var _g = 0;
	repeat array_length(tabs){ //find if tab already exists
		if tabs[_g].filepath == scrpt.fullpath{
			tab = tabs[_g];
			return;
		}
		_g++;
	}
	//make one otherwise
	tab = instance_create_layer(0, 0, layer_get_id("layer_tabs"), obj_ScriptTab);
	tab.name = scrpt.name;
	tab.filepath = scrpt.fullpath;
	tab.attack = scrpt.attack;
	tab.data = archive_fetch_file((scrpt.attack? AP.ATTACKS: AP.SCRIPTS), scrpt.fullpath);
	tab.filestruct = archive_fetch_filestruct((scrpt.attack? AP.ATTACKS: AP.SCRIPTS), scrpt.fullpath);
	tab.main_obj = self;
	array_push(tabs, tab)
}



function reload_scripts(){
	expanded_attacks = 0;
	scriptview = [0, 0];
	scriptscroll_speed = [0, 0]
	script_pickers = [];
	attack_pickers = [];
	scripts_size = [0, 0];
	select_id = -1;

	var _i = 0;
	var _scrps = archive_fetch(AP.SCRIPTS);
	draw_set_font(fnt_maplemono_SDF);
	repeat array_length(_scrps){
		var _path = _scrps[_i].path;
		var _split = string_split(_path, "/");
		var _name = _split[array_length(_split)-1];
		array_push(script_pickers, {
			name : _name,
			width : string_width(_name),
			fullpath : _path
		});
		_i++;
	}
	_i = 0;
	_scrps = archive_fetch(AP.ATTACKS);
	repeat array_length(_scrps){
		var _path = _scrps[_i].path;
		var _split = string_split(_path, "/");
		var _name = _split[array_length(_split)-1];
		array_push(attack_pickers, {
			name : _name,
			width : string_width(_name),
			fullpath : _path
		});
		_i++;
	}
}
