// LISTEN UP FRIENDOS
// As the name implies, THIS FILE IS A MESS, random functions scattered (and lost) around at random i dont even know if all of these are used lmao
// So yeah i made some of these at the very start of making this project so i had half the ideas i have now. So uuh, dont expect this code (or any other in this program) to be clean and readable
// i WILL try my best to clean things up and add a sliver of commentary to amuse our collective family road trip to insanity :D

///@desc So basically retruns an array of paths to directories inside the given _base_path
function get_directories(_base_path) {
	// So this kinda takes the base path and uuuh adds a slash if it isnt there
	if (string_char_at(_base_path, string_length(_base_path)) != "/") {
		_base_path += "/";
	}

	var _dir_array = [];
	var _current_file = file_find_first(_base_path + "*", fa_directory);

	while (_current_file != "") {
		if (_current_file != ".") && (_current_file != "..") { // ignore windows' things
			if (directory_exists(_base_path + _current_file)) {
				array_push(_dir_array, _base_path + _current_file);
			}
		}
		
		_current_file = file_find_next();
	}

	file_find_close();

	return _dir_array;
}

/// @desc Nasty evil function that creates an empty PNG 64x64 file at the given path using surface black magic
function generate_empty_png(_path) {
	var _surf = surface_create(64, 64);
	surface_set_target(_surf);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
	surface_save(_surf, _path);
	surface_free(_surf);
}

/// @desc As the name suggests, takes an array and creates a file matching the elements of said array
function array_into_file(_path, _array) {
	var _file = file_text_open_write(_path);
	
	for (var i = 0; i < array_length(_array); i++) {
		file_text_write_string(_file, string(_array[i])); // string() ensures and outsures that the written file is a string
		file_text_writeln(_file);
	}
	
	file_text_close(_file);
}

/// @desc Verifies if the given string is a valid name for a file
function is_valid_filename(_str) {
	if (_str == "") return false;	// i have never seen an empty named file and i wont be the first to make one

	var _forbidden = "<>:\"/\\|?*. ";

	for (var i = 1; i <= string_length(_forbidden); i++) {
		if (string_pos(string_char_at(_forbidden, i), _str) > 0) {
			return false; // this so windows doesnt kick my ass
		}
	}
	
	return true;
}

/// @desc Uses good old recursion to find EVERYTHINGGGGGG (all the files in all folders inside the given path)
function get_files_recursive(_base_path) {
	var _file_list = [];
	var _folder_stack = [""];
	
	while (array_length(_folder_stack) > 0) {
		var _current_folder = array_pop(_folder_stack);
		var _file = file_find_first(string("{0}/{1}*", _base_path, _current_folder), fa_directory);
		
		while (_file != "") {
			if (_file != "." && _file != "..") {
				var _relative_path = string("{0}{1}", _current_folder, _file);
				// "BUSTER I HAVE FOUND A FOLDER SEND IT TO THE LIST"
				if (directory_exists(string("{0}/{1}", _base_path, _relative_path))) {
					array_push(_folder_stack, string("{0}/", _relative_path)); // "ON IT BOSS!"
				} else {
					array_push(_file_list, _relative_path);
				}
			}
			_file = file_find_next();
		}
		file_find_close();
	}
	return _file_list;
}

/// @desc Inside a given file, finds the line that starts with _target_string and replaces it with _new_line, this is used somewhere
function file_replace_line_starting_with(_file_path, _target_string, _new_line) {
	if (!file_exists(_file_path)) return false;

	var _contents = [];
	var _file = file_text_open_read(_file_path);
	var _found = false;

	while (!file_text_eof(_file)) {
		var _line = file_text_read_string(_file);

		if (string_pos(_target_string, string_trim(_line)) == 1) {
			if (_new_line != "") {
				array_push(_contents, _new_line);
			}
			_found = true;
		} else {
			array_push(_contents, _line);
		}
		
		file_text_readln(_file);
	}
	
	file_text_close(_file);

	if (!_found) return false; // didnt find the line lmao loser

	_file = file_text_open_write(_file_path);
	
	for (var i = 0; i < array_length(_contents); i++) {
		file_text_write_string(_file, _contents[i]);
		
		if (i < array_length(_contents) - 1) {
			file_text_writeln(_file);
		}
	}
	
	file_text_close(_file);
	
	return true;
}

/// @desc Inside a given file, finds the line that contains _target_string and replaces it with _new_line, this is used somewhere (haha i copy pasterino the previous comment in this one i'm evil)
function global_string_replace_in_directory(_path, _target_string, _new_string) {
	var _files = get_all_files(_path);
	
	for (var i = 0; i < array_length(_files); i++) {
		if (filename_ext(_files[i]) == ".gml") {
			var _filepath = _path + _files[i];
			var _file = file_text_open_read(_filepath);
			var _full_text = "";
			
			while (!file_text_eof(_file)) { // the big stringificitificatizacitization
				_full_text += file_text_read_string(_file);
				file_text_readln(_file);
				
				if (!file_text_eof(_file)) {
					_full_text += "\n"; // file is over
				}
			}
			
			file_text_close(_file);
			
			if (string_pos(_target_string, _full_text) > 0) { // string exists? idk u tell me
				_file = file_text_open_write(_filepath);
				file_text_write_string(_file, string_replace_all(_full_text, _target_string, _new_string));
				file_text_close(_file);
			}
		}
	}
}

/// @desc Inserts a new line at the bottom of the file, venom style
function file_append_line(_file_path, _new_line) {
	if (!file_exists(_file_path)) return false;
	var _file = file_text_open_append(_file_path);
	
	// so you know i can do all these unfunny jokes cuz no one is bored enough to read through all ts
	file_text_writeln(_file);
	file_text_write_string(_file, _new_line);
	file_text_close(_file);
	
	return true;
}

/// @desc Satan spawn of a function that given a file and a target string, if the file contains said string it returns the first string between quotes at the line of the found string
function file_extract_string_between_char(_file_path, _target_string, _char, _addbracket = false) {
	if (!file_exists(_file_path)) return ""; // why would you pass an empty file? do you want me to suffer?
	
	var _file = file_text_open_read(_file_path);
	
	while (!file_text_eof(_file)) {
		var _line = file_text_read_string(_file);
		
		if (string_pos(_target_string, _line) > 0) {
			var _first_quote;
			if _addbracket {
				_first_quote = string_pos(_target_string, _line) + string_length(_target_string) - 1;
			} else {
				_first_quote = string_pos(_char, _line);
			}
			if (_first_quote > 0) {
				var _second_quote = string_pos_ext(_char, _line, _first_quote + 1);
				if (_second_quote > _first_quote) {
					file_text_close(_file);
					return string_copy(_line, _first_quote + 1, _second_quote - _first_quote - 1);
				}
			}
		}
		
		file_text_readln(_file);
	}
	
	file_text_close(_file);
	
	return "";
}

/// @desc I love this function so much its my favourite jk multiplexer is my favourite but basically gets all files inside a given directory path and puts them in an array
function get_all_files(_path) {
	if (string_char_at(_path, string_length(_path)) != "/") { // add the slash if the slash had to be added
		_path += "/";
	}
	
	var _files = [];
	var _file = file_find_first(_path + "*.*", 0);
	
	while (_file != "") {
		array_push(_files, _file);
		_file = file_find_next();
	}
	
	file_find_close();
	
	return _files;
}

/// @desc Super sayan version of the function above this, gets all full path files inside a given directory path and puts them in an array
function get_all_files_full(_path) {
	if (string_char_at(_path, string_length(_path)) != "/") {
		_path += "/";
	}
	
	var _files = [];
	var _file = file_find_first(_path + "*.*", 0);
	
	while (_file != "") {
		array_push(_files, _path + _file);
		_file = file_find_next();
	}
	
	file_find_close();
	
	return _files; // "why dont you merge these two and add a boolean that controls wether the full path is returned?" "What do you think i am? Smart? hahaha"
}

/// @desc Returns all sound files found inside a given path, ignoring files that start with a "_" better than how my crush ignores my messages
function get_custom_sounds(_path) {
	var _sound_array = [];
	var _file_name = file_find_first(_path + "*.*", 0);
	
	while (_file_name != "") {
		if (string_char_at(_file_name, 1) != "_") { // what's underscore racism called? underscorism? idk
			array_push(_sound_array, filename_change_ext(_file_name, ""));
		}
		
		_file_name = file_find_next();
	}
	
	file_find_close();
	
	return _sound_array;
}

// COMMENTED FUNCTION WOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
//function save_normal_stats(_filepath) {
//	var _file = file_text_open_read(_filepath);
//	var _new_file_string = "";
//	var _capture = false;

//	while (!file_text_eof(_file)) {
//		var _line = file_text_read_string(_file);
//		file_text_readln(_file);

//		if (string_pos("// NORMAL READ", _line) > 0) {
//			_capture = true;
//		}

//		if (_capture && string_pos("=", _line) > 0 && string_pos("//", string_replace_all(_line, " ", "")) != 1) {
//			var _var_name = string_replace_all(string_copy(_line, 1, string_pos("=", _line) - 1), " ", "");

//			if (variable_struct_exists(all_settings, _var_name)) {
//				_line = _var_name + " = " + string(all_settings[$ _var_name]) + ";";
//			}
//		}

//		if (string_pos("// NORMAL READ END", _line) > 0) {
//			_capture = false;
//		}

//		_new_file_string += _line + "\n";
//	}
	
//	file_text_close(_file);

//	var _out_file = file_text_open_write(_filepath);
//	file_text_write_string(_out_file, _new_file_string);
//	file_text_close(_out_file);
//} // legacy code whats that?

/// @desc Reads a config.ini file and returns the struct of options inside it, it works dont touch it pls pls pls
function read_character_config(_path) {
	var _struct = {};
	var _file = file_text_open_read(_path);
	
	while (!file_text_eof(_file)) {
		var _line = file_text_read_string(_file);
		file_text_readln(_file);
		var _pos = string_pos("=", _line);
		if (_pos > 0) {
			_struct[$ string_copy(_line, 1, _pos - 1)] = string_replace_all(string_copy(_line, _pos + 1, string_length(_line) - _pos), "\"", "");
		}
	}
	
	file_text_close(_file);
	
	return _struct;
}

/// @desc Draws a debug rectange, it's big, it's ugly, but it gets the job done
function draw_debug_rectangle(_x, _y, _x2 = mouse_x_diff(true), _y2 = mouse_y_diff(true)) {
	draw_rectangle_colour(_x, _y, _x2, _y2, c_red, c_blue, c_green, c_yellow, false);
}

/// @desc If this function was a food it would be ice cream in a hot summer day. It asks the user to select a PNG file
function askfor_png_path() {
	var _path = get_open_filename("PNG Image|*.png", "");
	
	if (_path != "") {
		if (string_lower(filename_ext(_path)) == ".png") { // Watch yo tone mf
			return _path;
		}
	}
	
	return "";
}

/// @desc Ask for a zippty file
function askfor_zip_path() {
	var _path = get_open_filename("ZIP Folder|*.zip", "");
	
	if (_path != "") {
		if (string_lower(filename_ext(_path)) == ".zip") {
			return _path;
		}
	}
	
	return "";
}

/// @desc Asks you to select an .ogg file. I love ogg files. ogg is love, ogg is life
function import_custom_sound(_dest_folder) {
	var _source_file = get_open_filename("OGG Audio|*.ogg", "");
	
	if (_source_file != "") {
		if (string_lower(filename_ext(_source_file)) == ".ogg") { // but is it REEEEEEALLLLYYYY an ogg?
			var _dest_file = _dest_folder + filename_name(_source_file);
			
			if (file_exists(_dest_file)) { // send the old sound file to the gulag
				file_delete(_dest_file);
			}
			
			file_copy(_source_file, _dest_file);
			return true;
		}
	}
	return false;
}

// @desc The triple whammy: lowercases, swaps spaces for underscores, and strips invalid characters inside the given string.
function string_filter_format_name(_str) {
	var _result = "";
	var _lower_str = string_lower(_str);
	
	for (var i = 1; i <= string_length(_lower_str); i++) {
		var _char = string_char_at(_lower_str, i);
		
		if (_char == " ") {
			_result += "_";
		} else if ((ord(_char) >= 97 && ord(_char) <= 122) || _char == "_") { // very scary char checks, i had to look at the table for this (yes the myth that every programmer knows the ASCII table by heart is indeed false)
			_result += _char;
		}
	}
	
	return _result;
}

/// @desc Wait didn't i already see this one before? i'm going coo coo
function import_custom_sound_name(_full_dest_path) {
	var _source_file = get_open_filename("OGG Audio|*.ogg", "");
	
	if (_source_file != "") {
		if (string_lower(filename_ext(_source_file)) == ".ogg") {
			
			if (file_exists(_full_dest_path)) { // is this deja vu?
				file_delete(_full_dest_path);
			}
			
			file_copy(_source_file, _full_dest_path);
			return true;
		}
	}
	return false;
}

/// @desc Copies the palettes from the colors.gml archive and saves it to clipboard, also does things that musn't be spoken
function copy_palettes_to_clipboard(_filepath) {
	var _file = archive_fetch_file(AP.SCRIPTS, _filepath);
	if _file == undefined {
		show_message("Missing colors.gml, it will be created when importing colors"); // I'M NOT FALLING FOR THAT SHIT!!!!!!! OH WAIT IT'S REA-
		return;
	}
	var _capture = false;
	var _found_start = false;
	var _found_end = false;
	var _extracted_text = "";
	var _full_text = "";
	
	for (var i = 0; i < array_length(_file); i++) {
		var _line = _file[i];
		
		_full_text += _line + "\n";
		
		// I have reached the end, there is nothing more, nothing left, i am alone, it's dark, it's cold...
		if (string_pos("// PASTEAREA END", _line) > 0) {
			_capture = false;
			_found_end = true;
		}

		if (_capture) {
			_extracted_text += _line + "\n";
		}
		
		// Oh boy it's the start of the journey! I can't wait to see what's in store for me! i bet the ending will be awesome!
		if (string_pos("// PASTEAREA START", _line) > 0) {
			_capture = true;
			_found_start = true;
		}
	}

	if (_found_start && _found_end) { // So, do you have the stuff?
		clipboard_set_text(_extracted_text); // yes boss
	} else {
		clipboard_set_text(_full_text); // yes boss (disobeying the boss' orders is forbidden)
	}
	
	show_message("Pallettes copied to clipboard!");
}

/// @desc Sooooooooooooooooooo this does the inverse of the previous function, also sir this is a Wendy's
function import_palettes_from_clipboard(_filepath) {
	var _file = archive_fetch_file(AP.SCRIPTS, _filepath);
	if _file == undefined {
		//kinda going against the "no disc" stuff but you have to do what you have to do, save archive syncs everything anyweays
		file_copy("colors.gml", _filepath);
		archive_create(AP.SCRIPTS, _filepath, FT.GML);
		var _fstr = archive_fetch_filestruct(AP.SCRIPTS, _filepath);
		if _fstr == undefined {show_message("Failed to create colors.gml, unable to import pallettes"); exit;}
		_fstr.file = add_gml_array(_filepath);
		_fstr.modified = true;
		global.archive_modified = true;
	}
	_file = archive_fetch_file(AP.SCRIPTS, _filepath); // FILE HAS TO BE THERE NOW
	var _fstr = archive_fetch_filestruct(AP.SCRIPTS, _filepath);
	
	if (!clipboard_has_text()) {
		show_message("Error: Clipboard is empty!"); // dummy
		return;
	}

	var _clip_text = clipboard_get_text();
	
	if (string_pos("set_color_profile_slot", _clip_text) == 0 && string_pos("=== BEGIN JSON PALETTE ===", _clip_text) == 0) { 
		show_message("Error: Clipboard does not contain valid pallette data!"); // bruh y u givin me dataslop i want datagem
		return;
	}

	var _top_half = [];
	var _bottom_half = [];
	var _section = 0;
	var _found_start = false;
	var _found_end = false;
	
	for (var i = 0; i < array_length(_file); i++) {
		var _line = _file[i];
		
		if (_section == 0) {
			array_push(_top_half, _line);
			if (string_pos("// PASTEAREA START", _line) > 0) { // you know the drill by now
				_section = 1;
				_found_start = true;
			}
		} else if (_section == 1) {
			if (string_pos("// PASTEAREA END", _line) > 0) { // wah wah i reached the end
				array_push(_bottom_half, _line);
				_section = 2;
				_found_end = true;
			}
		} else if (_section == 2) {
			array_push(_bottom_half, _line);
		}
	}
	
	_clip_text = string_split(_clip_text, "\n")
	// If both markers exist build the sandwich text.
	// Otherwise overwrite the entire file with the clipboard text for compatibility with other sources.
	
	// Shut up Davi u nerdy ass
	if (_found_start && _found_end) {
		_fstr.file = array_concat(_top_half, _clip_text, _bottom_half);
	} else {
		_fstr.file = _clip_text;
	}
	_fstr.modified = true;
	global.archive_modified = true;
	
	show_message("Pallettes successfully imported!"); // Yes i have misspelled both texts its called a REOCURRING JOKE
}

///// @desc gaster told me to comment this function
//function get_normal_stats(_filepath) {
//	var _stats = {};
//	var _file = file_text_open_read(_filepath);
//	var _capture = false;
	
//	while (!file_text_eof(_file)) {
//		var _line = file_text_read_string(_file);
//		file_text_readln(_file);
		
//		if (string_pos("// NORMAL READ END", _line) > 0) {
//			break;
//		}
		
//		if (_capture && string_pos("=", _line) > 0) {
//			_stats[$ string_replace_all(string_copy(_line, 1, string_pos("=", _line) - 1), " ", "")] = real(string_replace_all(string_copy(_line, string_pos("=", _line) + 1, string_pos(";", _line) - string_pos("=", _line) - 1), " ", ""));
//		}
		
//		if (string_pos("// NORMAL READ", _line) > 0) {
//			_capture = true;
//		}
//	}
	
//	file_text_close(_file);
//	return _stats;
//}

/// @desc Takes text written like_this and converts into text looking Like This
function string_to_title_case(_input) {
	var _spaced = string_replace_all(_input, "_", " ");
	var _result = "";
	var _word_start = true;
	
	for (var i = 1; i <= string_length(_spaced); i++) {
		var _char = string_char_at(_spaced, i);
		
		if (_char == " ") {
			_result += " ";
			_word_start = true;
		} else if (_word_start) {
			_result += string_upper(_char);
			_word_start = false;
		} else {
			_result += string_lower(_char);
		}
	}
	
	return _result;
}

/// @desc Takes a string and forces it to be a float value (decimal with negatives allowed)
function string_filter_float(_input) {
	var _result = "";
	var _has_decimal = false;
	
	for (var i = 1; i <= string_length(_input); i++) {
		var _char = string_char_at(_input, i);
		
		if (_char == "-" && i == 1) { // negazio
			_result += _char;
		}

		else if (_char >= "0" && _char <= "9") { // numberation
			_result += _char;
		}

		else if (_char == "." && !_has_decimal) { // dottinator
			_result += _char;
			_has_decimal = true;
		}
	}
	
	return _result;
}

/// @desc Guess what this does
function string_filter_positive_integer(_input) {
	var _result = "";
	
	for (var i = 1; i <= string_length(_input); i++) { // why the hell is it called a for loop it doesnt loop four times
		var _char = string_char_at(_input, i);
		
		if (_char >= "0" && _char <= "9") {
			_result += _char;
		}
	}
	
	return _result;
}

/// @desc So for example if someone wrote a fucked up float (-.0, 5., .8) it corrects it
function string_format_float_strict(_input) {

	if (_input == "" || _input == "-" || _input == "." || _input == "-.") { // how many shots did you take before passing this?
		return "0";
	}

	if (string_char_at(_input, 1) == ".") { // broskichachotatinator you need to put a value before the dot
		_input = "0" + _input;
	} else if (string_copy(_input, 1, 2) == "-.") {
		_input = "-0." + string_copy(_input, 3, string_length(_input) - 2);
	}

	if (string_char_at(_input, string_length(_input)) == ".") { // i mean... come on now
		_input += "0";
	}

	return _input;
}

/// @desc This function hacks your PC and installs 1000000000 viruses (jk it just gives you the ROA appdata workshop location)
function get_workshop_path() {
	return string("{0}/RivalsofAether/workshop", environment_get_variable("LOCALAPPDATA"));
}

/// @desc Sets the cursor variable to a cursor. Cursor shapes are giving me more trouble than i wish they did.. i'm just a good boy... wait why the hell did i say that?????
function set_cursor(_cursor) {
	global.cursor = _cursor;
}

/// @desc Resets or initializes the drag variables for file dragging dragginator of draggington
function reset_drag () {
	file_dropper_set_allow(true);
	filedrag = false;
	draggedpath = "";
	numdragfiles = 0;
	numdragfilessuccess = 0;
}

/// @desc NEEDS reset_drag TO FUNCTION!! (function hehe get it?) - Shows or hides a certain layer based on the file drag state
function tick_dragging_layer(_asslayer) {
	if !variable_instance_exists(id, "filedrag") {
		show_debug_message("Tried to tick instance without initializing filedrag variables!"); // this will surely annoy me to the point of fixing it
		exit;
	}
	layer_set_visible(_asslayer, filedrag);
}

/// @desc Monster of a function i found somewhere that given a sprite it returns an array with all it's colors
function sprite_get_colors(_sprite, _subimg) {
	var _width = sprite_get_width(_sprite);
	var _height = sprite_get_height(_sprite);
	var _surf = surface_create(_width, _height);
	surface_set_target(_surf);
	draw_clear_alpha(c_black, 0);
	draw_sprite(_sprite, _subimg, 0, 0);
	surface_reset_target();
	var _buff = buffer_create(_width * _height * 4, buffer_fixed, 1);
	buffer_get_surface(_buff, _surf, 0);
	surface_free(_surf);
	var _unique_colors = {};
	var _color_array = [];
	for (var i = 0; i < buffer_get_size(_buff); i += 4) {
		if (buffer_peek(_buff, i + 3, buffer_u8) > 0) {
			var _col = (buffer_peek(_buff, i + 2, buffer_u8) << 16) | (buffer_peek(_buff, i + 1, buffer_u8) << 8) | buffer_peek(_buff, i, buffer_u8);
			if (!variable_struct_exists(_unique_colors, string(_col))) {
				variable_struct_set(_unique_colors, string(_col), true);
				array_push(_color_array, _col);
			}
		}
	}
	buffer_delete(_buff);
	return _color_array;
}

/// @desc Uses magic to convert a color number to a HEX string
function color_to_hex(_col) {
	var _hex_chars = "0123456789ABCDEF";
	return "#" + 
	string_char_at(_hex_chars, ((_col >> 4) & 15) + 1) + 
	string_char_at(_hex_chars, (_col & 15) + 1) + 
	string_char_at(_hex_chars, ((_col >> 12) & 15) + 1) + 
	string_char_at(_hex_chars, ((_col >> 8) & 15) + 1) + 
	string_char_at(_hex_chars, ((_col >> 20) & 15) + 1) + 
	string_char_at(_hex_chars, ((_col >> 16) & 15) + 1);
}

/// @desc takes a color and splits it into a struct with hue, sat, val (i have no joke for this one srry)
function color_to_hsv(_col) {
	return {
		hex: color_to_hex(_col),
		hue: color_get_hue(_col),
		sat: color_get_saturation(_col),
		val: color_get_value(_col)
	};
}

/// @desc Super specific function thst removes all comments from a gml file array
function clear_gml_comments(_arr) {
	var _array = variable_clone(_arr);
	var _in_block = false;
	var _in_string = false;
	var _string_char = "";
	
	for (var i = 0; i < array_length(_array); i++) {
		var _line = _array[i];
		var _new_line = "";
		var _len = string_length(_line);
		var j = 1;
		
		while (j <= _len) {
			var _char = string_char_at(_line, j);
			var _next_char = (j < _len) ? string_char_at(_line, j + 1) : "";
			
			if (_in_block) {
				if (_char == "*" && _next_char == "/") {
					_in_block = false;
					j += 2;
				} else {
					j++;
				}
			} else if (_in_string) {
				if (_char == "\\") {
					_new_line += _char;
					if (_next_char != "") {
						_new_line += _next_char;
						j++;
					}
					j++;
				} else if (_char == _string_char) {
					_in_string = false;
					_new_line += _char;
					j++;
				} else {
					_new_line += _char;
					j++;
				}
			} else {
				if (_char == "/" && _next_char == "/") {
					break;
				} else if (_char == "/" && _next_char == "*") {
					_in_block = true;
					j += 2;
				} else if (_char == "\"" || _char == "'") {
					_in_string = true;
					_string_char = _char;
					_new_line += _char;
					j++;
				} else {
					_new_line += _char;
					j++;
				}
			}
		}
		_array[i] = _new_line;
	}
	
	return _array;
}

/// @desc Ungodly specific function that removes all comments from a gml file array except the sigle ones on a new line
function clear_gml_comments_except_lonely_ones(_arr) {
	var _array = variable_clone(_arr);
	var _in_block = false;
	var _in_string = false;
	var _string_char = "";
	
	for (var i = 0; i < array_length(_array); i++) {
		var _line = _array[i];
		var _new_line = "";
		var _len = string_length(_line);
		var j = 1;
		var _has_code = false;
		
		while (j <= _len) {
			var _char = string_char_at(_line, j);
			var _next_char = (j < _len) ? string_char_at(_line, j + 1) : "";
			
			if (_in_block) {
				if (_char == "*" && _next_char == "/") {
					_in_block = false;
					j += 2;
				} else {
					j++;
				}
			} else if (_in_string) {
				if (_char == "\\") {
					_new_line += _char;
					if (_next_char != "") {
						_new_line += _next_char;
						j++;
					}
					j++;
				} else if (_char == _string_char) {
					_in_string = false;
					_new_line += _char;
					j++;
				} else {
					_new_line += _char;
					j++;
				}
				_has_code = true;
			} else {
				if (_char == "/" && _next_char == "/") {
					if (!_has_code) {
						_new_line += string_copy(_line, j, _len - j + 1);
					}
					break;
				} else if (_char == "/" && _next_char == "*") {
					_in_block = true;
					j += 2;
				} else if (_char == "\"" || _char == "'") {
					_in_string = true;
					_string_char = _char;
					_new_line += _char;
					j++;
					_has_code = true;
				} else {
					_new_line += _char;
					j++;
					if (ord(_char) > 32) {
						_has_code = true;
					}
				}
			}
		}
		_array[i] = _new_line;
	}
	
	return _array;
}

/// @desc same as gpu_set_scissor but takes two coords. I HATE HATE HATE HATE functions that take width and height and not second position!!!!!!!!!!
function gpu_set_scissor_alt(_x, _y, _x2, _y2) {
	gpu_set_scissor(_x, _y, _x2 - _x, _y2 - _y);
}

function colorswap_shader(_original_cols, _new_cols) {
	var _len = array_length(_original_cols);
	
	if (_len > 2048) {
		_len = 2048;
	}
	
	var _surf_orig = surface_create(_len, 1);
	surface_set_target(_surf_orig);
	draw_clear_alpha(c_black, 0);
	for (var _i = 0; _i < _len; _i++) {
		draw_point_color(_i, 0, _original_cols[_i]);
	}
	surface_reset_target();
	
	var _surf_new = surface_create(_len, 1);
	surface_set_target(_surf_new);
	draw_clear_alpha(c_black, 0);
	for (var _i = 0; _i < _len; _i++) {
		draw_point_color(_i, 0, _new_cols[_i]);
	}
	surface_reset_target();
	
	shader_set(shd_replacer);
	
	texture_set_stage(shader_get_sampler_index(shd_replacer, "tex_original"), surface_get_texture(_surf_orig));
	texture_set_stage(shader_get_sampler_index(shd_replacer, "tex_replacement"), surface_get_texture(_surf_new));
	shader_set_uniform_f(shader_get_uniform(shd_replacer, "u_color_count"), _len);
	
	return [_surf_orig, _surf_new];
}

// P.S: Yes i had fun writing the comments