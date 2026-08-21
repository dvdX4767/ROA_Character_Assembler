if freeze {exit;}

set_cursor(cr_default);

layer_text_blend(layer_text_get_id("Assets_1", "BackArrow"), c_white);
layer_text_blend(layer_text_get_id("Assets_1", "CloseButton"), c_white);
layer_text_blend(layer_text_get_id("Assets_1", "ExportButton"), c_white);


layer_text_blend(layer_text_get_id("Assets_2", "TxtStats"), c_white);
layer_text_blend(layer_text_get_id("Assets_2", "TxtSprites"), c_white);
layer_text_blend(layer_text_get_id("Assets_2", "TxtSounds"), c_white);
layer_text_blend(layer_text_get_id("Assets_2", "TxtAi"), c_white);
layer_text_blend(layer_text_get_id("Assets_2", "TxtAttacks"), c_white);
layer_text_blend(layer_text_get_id("Assets_2", "TxtColors"), c_white);
layer_text_blend(layer_text_get_id("Assets_2", "text_B07DCB7"), c_white);



if mouse_in_rectangle(1305, 0, 1365, 60) {
	layer_text_blend(layer_text_get_id("Assets_1", "CloseButton"), c_red);
	if mouse_check_button_pressed(mb_left) {game_end()}
}

if focus == "nothing" {
	// the back arrow button
	if mouse_in_rectangle(0, 0, 90, 60) {
		layer_text_blend(layer_text_get_id("Assets_1", "BackArrow"), c_yellow);
		if mouse_check_button_pressed(mb_left) {
			if global.archive_modified and show_question("Do you wish to save all changes to disc before closing?") {
				ARCHIVE_SAVE();
			}
			room_goto(START);
			exit;
		}
		set_cursor(cr_handpoint);
	}


	if mouse_in_uibox("Assets_1", "graphic_6F0E5330", cr_handpoint, false) {
		layer_text_blend(layer_text_get_id("Assets_1", "ExportButton"), c_lime);
		if mouse_check_button_pressed(mb_left) and global.selected_dest == 0 {freeze = true; my_popup_id = get_string_async("Insert export filename (this will override any folder with this filename already existing inside the worshop folder!)", global.selected_filename)}
	}
	
	if mouse_in_rectangle(370, 70, 1240, 135) {
		if mouse_check_button_pressed(mb_left) {focus = "name"; keyboard_string = global.config_data.name}
		set_cursor(cr_beam);
	}
	
	if mouse_in_rectangle(370, 142, 835, 180) {
		if mouse_check_button_pressed(mb_left) {focus = "author"; keyboard_string = global.config_data.author}
		set_cursor(cr_beam);
	}
	
	if mouse_in_rectangle(372, 184, 405, 223) {
		if mouse_check_button_pressed(mb_left) {focus = "majorver"; keyboard_string = global.config_data[$ "major version"]}
		set_cursor(cr_beam);
	}
	
	if mouse_in_rectangle(420 + 30, 184, 455 + 40, 223) {
		if mouse_check_button_pressed(mb_left) {focus = "minorver"; keyboard_string = global.config_data[$ "minor version"]}
		set_cursor(cr_beam);
	}
	
	if mouse_in_rectangle(377, 257, 819, 405) {
		if mouse_check_button_pressed(mb_left) {focus = "description"; keyboard_string = global.config_data.description}
		set_cursor(cr_beam);
	}
	
	if mouse_in_rectangle(866, 163, 1340, 220) {
		if mouse_check_button_pressed(mb_left) {focus = "info1"; keyboard_string = global.config_data.info1}
		set_cursor(cr_beam);
	}
	
	if mouse_in_rectangle(866, 163 + 98, 1340, 220 + 98) {
		if mouse_check_button_pressed(mb_left) {focus = "info2"; keyboard_string = global.config_data.info2}
		set_cursor(cr_beam);
	}
	
	if mouse_in_rectangle(866, 163 + 95 * 2, 1340, 220 + 95 * 2) {
		if mouse_check_button_pressed(mb_left) {focus = "info3"; keyboard_string = global.config_data.info3}
		set_cursor(cr_beam);
	}
	
	if mouse_in_rectangle(2, 64, 351, 413) {
		if mouse_check_button_pressed(mb_left) {focus = "portrait";}
		set_cursor(cr_handpoint);
	}
	
	if mouse_in_uibox("Assets_2", "graphic_295F16BF", cr_handpoint, false) {
		if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Stats)}
		layer_text_blend(layer_text_get_id("Assets_2", "TxtStats"), c_orange);
	}
	
	if mouse_in_uibox("Assets_2", "graphic_3D256733", cr_handpoint, false) {
		if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Sounds)}
		layer_text_blend(layer_text_get_id("Assets_2", "TxtSounds"), c_yellow);
	}
	
	if mouse_in_uibox("Assets_2", "graphic_62617488", cr_handpoint, false) {
		if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Ai)}
		layer_text_blend(layer_text_get_id("Assets_2", "TxtAi"), c_fuchsia);
	}
	
	if mouse_in_uibox("Assets_2", "graphic_37808813", cr_handpoint, false) {
		if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Sprites)}
		layer_text_blend(layer_text_get_id("Assets_2", "TxtSprites"), c_lime);
	}
	
	if mouse_in_uibox("Assets_2", "graphic_2D17E9D9", cr_handpoint, false) {
		if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Attacks)}
		layer_text_blend(layer_text_get_id("Assets_2", "TxtAttacks"), c_aqua);
	}
	
	if debug_mode and mouse_in_uibox("Assets_2", "graphic_3582C489", cr_handpoint, false) {
		if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Colors)}
		layer_text_blend(layer_text_get_id("Assets_2", "TxtColors"), make_color_hsv((global.tick * 2) mod 256, 255, 255));
	}
	
	if mouse_in_uibox("Assets_2", "graphic_4A5FF3F2", cr_handpoint, false) {
		if mouse_check_button_pressed(mb_left) {room_goto(CharEdit_Scripts)}
		layer_text_blend(layer_text_get_id("Assets_2", "text_B07DCB7"), c_purple);
	}
	
	
} 



else if focus == "name" {
	layer_text_text(layer_text_get_id("Assets_2", "CharName"), keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_"));
	if mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) {
		archive_edit_ini(AP.MAIN, get_full_path("config.ini"), "name", keyboard_string);
		layer_text_text(layer_text_get_id("Assets_2", "CharName"), keyboard_string);
		focus = "nothing";
	}
}


else if focus == "author" {
	layer_text_text(layer_text_get_id("Assets_2", "CharAuthor"), "BY " + keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_"));
	if mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) {
		archive_edit_ini(AP.MAIN, get_full_path("config.ini"), "author", keyboard_string);
		layer_text_text(layer_text_get_id("Assets_2", "CharAuthor"), "BY " + keyboard_string);
		focus = "nothing";
	}
}

else if focus == "majorver" {
	keyboard_string = string_digits(keyboard_string);
	layer_text_text(layer_text_get_id("Assets_2", "CharVersion"), string("v{0}.{1}", keyboard_string + multiplexer(global.tick mod 60 > 30, "  ", "_"), global.config_data[$ "minor_version"]));
	if mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) {
		if keyboard_string == "" {keyboard_string = "0"}
		archive_edit_ini(AP.MAIN, get_full_path("config.ini"), "major version", keyboard_string);
		layer_text_text(layer_text_get_id("Assets_2", "CharVersion"), string("v{0}.{1}", keyboard_string, global.config_data[$ "minor_version"]));
		focus = "nothing";
	}
}


else if focus == "minorver" {
	keyboard_string = string_digits(keyboard_string);
	layer_text_text(layer_text_get_id("Assets_2", "CharVersion"), string("v{0}.{1}", global.config_data[$ "major_version"], keyboard_string + multiplexer(global.tick mod 60 > 30, "  ", "_")));
	if mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) {
		if keyboard_string == "" {keyboard_string = "0"}
		archive_edit_ini(AP.MAIN, get_full_path("config.ini"), "minor version", keyboard_string);
		layer_text_text(layer_text_get_id("Assets_2", "CharVersion"), string("v{0}.{1}", global.config_data[$ "major_version"], keyboard_string));
		focus = "nothing";
	}
}



else if focus == "description" {
	layer_text_text(layer_text_get_id("Assets_2", "CharDesc"), keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_"));
	if mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) {
		archive_edit_ini(AP.MAIN, get_full_path("config.ini"), "description", keyboard_string);
		layer_text_text(layer_text_get_id("Assets_2", "CharDesc"), keyboard_string);
		focus = "nothing";
	}
}

else if focus == "info1" {
	layer_text_text(layer_text_get_id("Assets_2", "CharInfo1"), keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_"));
	if mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) {
		archive_edit_ini(AP.MAIN, get_full_path("config.ini"), "info1", keyboard_string);
		layer_text_text(layer_text_get_id("Assets_2", "CharInfo1"), keyboard_string);
		focus = "nothing";
	}
}


else if focus == "info2" {
	layer_text_text(layer_text_get_id("Assets_2", "CharInfo2"), keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_"));
	if mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) {
		archive_edit_ini(AP.MAIN, get_full_path("config.ini"), "info2", keyboard_string);
		layer_text_text(layer_text_get_id("Assets_2", "CharInfo2"), keyboard_string);
		focus = "nothing";
	}
}


else if focus == "info3" {
	layer_text_text(layer_text_get_id("Assets_2", "CharInfo3"), keyboard_string + multiplexer(global.tick mod 60 > 30, "", "_"));
	if mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) {
		archive_edit_ini(AP.MAIN, get_full_path("config.ini"), "info3", keyboard_string);
		layer_text_text(layer_text_get_id("Assets_2", "CharInfo3"), keyboard_string);
		focus = "nothing";
	}
}


else if focus == "portrait" {
	var _new_image = askfor_png_path();
	if _new_image == "" {
		show_message("Invalid file type detected or action has been cancelled");
		focus = "nothing";
		exit;
	} else {
		archive_edit_sprite(AP.MAIN, get_full_path("portrait.png"), _new_image, get_full_path("portrait.png"));
		var _spr = archive_fetch_file(AP.MAIN, get_full_path("portrait.png"));
		layer_sprite_change(layer_sprite_get_id("Assets_1", "graphic_156F9130"), _spr);
		focus = "nothing";
	}
}

if keyboard_check_pressed(vk_tab) {
	if string_pos("\\users\\", string_lower(global.selected_path)) == 0 {
		clipboard_set_text(game_save_id + global.selected_path);
	} else {
		clipboard_set_text(global.selected_path);
	}
	show_message("Copied path to clipboard!");
}