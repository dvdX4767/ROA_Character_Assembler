file_dropper_init();

if !variable_global_exists("superpath") {
	global.superpath = "saved/";
	global.selected_dest = 0;
} else {
	if global.superpath != "saved/" {
		global.selected_dest = 1;
	} else {
		global.selected_dest = 0;
	}
}
global.saved_paths = get_directories(global.superpath);
global.selected_path = "";
global.selected_filename = "";
if !variable_global_exists("scroll_y") {global.scroll_y = 0;}
if !variable_global_exists("scroll_y2") {global.scroll_y2 = 0;}
eraseconfirm = 0;
eraseid = -1;
reset_drag();

for (var i = 0; i < array_length(global.previews); i++) {sprite_delete(global.previews[i])}
global.previews = [];
global.charconfs = [];
global.filenames = [];
global.templates = [];
load_templates();
draw_set_halign(fa_center);

for (var i = 0; i < array_length(global.saved_paths); i++) {
	var _char_path = string("{0}/charselect.png", global.saved_paths[i]);
	
	if file_exists(_char_path) {
		array_push(global.previews, sprite_add(_char_path, 1, false, false, 0, 0));
	} else {
		if global.selected_dest = 0 {
			show_message("Missing Asset:\n" + string(".../AppData/Local/ROA_Character_Assembler/{0}\nThis character was not loaded in", _char_path));
		}
		array_delete(global.saved_paths, i, 1);
		i--;
	}
}

for (var i = 0; i < array_length(global.saved_paths); i++) {
	var _char_path = string("{0}/config.ini", global.saved_paths[i]);
	
	if file_exists(_char_path) {
		var _confstr = read_character_config(_char_path);
		if variable_instance_exists(_confstr, "type") && _confstr.type == 0 {
			array_push(global.charconfs, _confstr);
		} else {
			array_delete(global.saved_paths, i, 1);
			sprite_delete(global.previews[i]);
			array_delete(global.previews, i, 1);
			i--;
		}
	} else {
		if global.selected_dest = 0 {
			show_message("Missing config.ini:\n" + string(".../AppData/Local/ROA_Character_Assembler/{0}\nThis character was not loaded in", _char_path));
		} else {
			show_message("Missing config.ini:\n" + string("{1}{0}\nThis character was not loaded in", _char_path, global.superpath));
		}
		array_delete(global.saved_paths, i, 1);
		sprite_delete(global.previews[i]);
		array_delete(global.previews, i, 1);
		i--;
	}
}

for (var i = 0; i < array_length(global.saved_paths); i++) {
	if (global.selected_dest == 0) {
		array_push(global.filenames, string_copy(global.saved_paths[i], 7, 999));
	} else {
		var _str = global.saved_paths[i];
		var _pos = string_pos("workshop", _str);
		array_push(global.filenames, string_copy(_str, _pos + 9, 999));
	}
}

load_dialect();

function load_templates() {
	if !variable_global_exists("selected_template") {global.selected_template = 0;}
	if !directory_exists("templates") {
		directory_create("templates");
		if !file_exists("template.zip") {
			show_message("Couldn't find template.zip, for this reason creating a new character is disabled until you import a template zip file");
		}
		file_copy("template.zip", "templates/template.zip");
	}
	
	var _temps = get_all_files("templates/");
	
	for (var i = 0; i < array_length(_temps); i++) {
		if filename_ext(_temps[i]) == ".zip" {
			array_push(global.templates, _temps[i]);
		}
	}
}

































