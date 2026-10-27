      // AI Slop? Nah mate, this is man made slop
// Jokes aside i'm pretty proud of this
enum FT {
	SPRITE,
	GML,
	INI
}

enum AP {
	SPRITES,
	SCRIPTS,
	MAIN,
	ATTACKS
}

function INITIALIZE_ARCHIVE(_path) {
	global.archive_modified = false;
	global.ARCHIVE = {
		scripts: {attacks: [], others: []},
		sprites: [],
		others: []
	};
	
	// FILES INSIDE BASE FOLDER
	var _files = get_all_files(_path);
	
	for (var i = 0; i < array_length(_files); i++) {
		structify_type(_path, _files[i], global.ARCHIVE.others);
	}
	
	// FILES INSIDE SCRIPTS
	var _pathex = string("{0}/scripts", _path);
	_files = get_all_files(_pathex);
	
	for (var i = 0; i < array_length(_files); i++) {
		structify_type(_pathex, _files[i], global.ARCHIVE.scripts.others);
	}
	
	// FILES INSIDE ATTACKS
	_pathex = string("{0}/scripts/attacks", _path);
	_files = get_all_files(_pathex);
	
	for (var i = 0; i < array_length(_files); i++) {
		structify_type(_pathex, _files[i], global.ARCHIVE.scripts.attacks);
	}
	
	// FILES INSIDE SPRITES
	_pathex = string("{0}/sprites", _path);
	_files = get_all_files(_pathex);
	
	for (var i = 0; i < array_length(_files); i++) {
		structify_type(_pathex, _files[i], global.ARCHIVE.sprites);
	}
}

function structify_type(_path, _filename, _array) {
	if string_ends_with(_filename, ".png") {
		array_push(_array, structify(FT.SPRITE, string("{0}/{1}", _path, _filename)));
	} else if string_ends_with(_filename, ".ini") {
		array_push(_array, structify(FT.INI, string("{0}/{1}", _path, _filename)));
	} else if string_ends_with(_filename, ".gml") {
		array_push(_array, structify(FT.GML, string("{0}/{1}", _path, _filename)));
	}
}

function structify(_type, _pathfull) {
	switch _type {
		case FT.SPRITE:
			return {
				type: _type,
				path: _pathfull,
				file: add_sprite_strip(_pathfull),
				modified: false
			}
			
		case FT.INI:
			return {
				type: _type,
				path: _pathfull,
				file: add_ini_struct(_pathfull),
				modified: false
			}
			
		case FT.GML:
			return {
				type: _type,
				path: _pathfull,
				file: add_gml_array(_pathfull),
				modified: false
			}
	}
}

function add_sprite_strip(_path) {
	var _fname = filename_name(_path);
	_fname = string_copy_alt(_fname, 1, string_pos(".png", _fname));
	
	var _frames = 1;
	if string_pos("_strip", _fname) != 0 {
		_frames = real(string_copy(_fname, string_pos("_strip", _fname) + 6, 9999));
	}
	
	return sprite_add(_path, _frames, false, false, 0, 0);
}

function add_ini_struct(_pathfull) {
	ini_open(_pathfull);
	
	var _struct = {
		finished: ini_read_string("general", "finished", "0"),
		info3: ini_read_string("general", "info3", ""),
		info2: ini_read_string("general", "info2", ""),
		info1: ini_read_string("general", "info1", ""),
		author: ini_read_string("general", "author", "Unknown"),
		url: ini_read_string("general", "url", ""),
		minor_version: ini_read_string("general", "minor version", "0"),
		major_version: ini_read_string("general", "major version", "1"),
		type: ini_read_string("general", "type", "0"),
		description: ini_read_string("general", "description", ""),
		name: ini_read_string("general", "name", "Template Character")
	};
	
	ini_close();
	
	return _struct;
}

function add_gml_array(_path) {
	var _arr = [];
	
	var _file = file_text_open_read(_path);
	
	while !file_text_eof(_file) {
		var _line = file_text_read_string(_file);
		array_push(_arr, _line);
		file_text_readln(_file);
	}
	
	file_text_close(_file);
	return _arr;
}

/// @desc 0- having the path, returns the filestruct
function archive_fetch_filestruct(_archpos, _fullpath) {
	if string_pos(global.selected_path, _fullpath) == 0 {show_error("YOU FORGOT THE FULL PATH IDIOT", true)}
	var _arch_array = archive_fetch(_archpos);
	if _arch_array != undefined {
		for (var i = 0; i < array_length(_arch_array); i++) {
			if _arch_array[i].path == _fullpath {
				return _arch_array[i];
			}
		}
	}
	return undefined;
}

/// @desc 1- having the path, fetches the file array/sprite/sound
function archive_fetch_file(_archpos, _fullpath) {
	var _filestruct = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestruct != undefined {
		return _filestruct.file;
	}
	return undefined;
}

/// @desc 2- having the path, returns the position in the array
function archive_fetch_position(_archpos, _fullpath) {
	if string_pos(global.selected_path, _fullpath) == 0 {show_error("YOU FORGOT THE FULL PATH IDIOT", true)}
	var _arch_array = archive_fetch(_archpos);
	if _arch_array != undefined {
		for (var i = 0; i < array_length(_arch_array); i++) {
			if _arch_array[i].path == _fullpath {
				return i;
			}
		}
	}
	return undefined;
}

/// @desc 3- having the general position, return the array of structs of files
function archive_fetch(_archive_pos) {
	switch _archive_pos {
		case AP.ATTACKS:
			return global.ARCHIVE.scripts.attacks;
		case AP.SCRIPTS:
			return global.ARCHIVE.scripts.others;
		case AP.SPRITES:
			return global.ARCHIVE.sprites;
		case AP.MAIN:
			return global.ARCHIVE.others;
		default:
			return undefined;
	}
}

/// @desc 4- having the path and line index and a string, edits the old line to the new
function archive_edit_gml_line(_archpos, _fullpath, _lineindex, _newline) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestr == undefined or _filestr.type != FT.GML {return false}
	var _file = _filestr.file;
	if array_length(_file) > _lineindex and _lineindex >= 0 {
		_file[_lineindex] = _newline;
		_filestr.modified = true;
		global.archive_modified = true;
		return true;
	} else {return false}
}

/// @desc 4.5- having the path and a string, adds a new line to the file
function archive_edit_gml_newline(_archpos, _fullpath, _newline) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestr == undefined or _filestr.type != FT.GML {return false}
	var _file = _filestr.file;
	array_push(_file, _newline);
	_filestr.modified = true;
	global.archive_modified = true;
	return true;
}

/// @desc 4.55- having the path and an index, removes the line at the index
function archive_edit_gml_remove(_archpos, _fullpath, _lineindex) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestr == undefined or _filestr.type != FT.GML {return false}
	var _file = _filestr.file;
	if array_length(_file) > _lineindex and _lineindex >= 0 {
		array_delete(_file, _lineindex, 1);
		_filestr.modified = true;
		global.archive_modified = true;
		return true;
	} else {return false}
}

/// @desc 4.555- having the path and an index, finds the FIRST line that has the given string in it (by toggling format off you can remove all spaces and tabs from the string and stripping comments)
function archive_fetch_gml_string_pos(_archpos, _fullpath, _substring, _format = true) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestr == undefined or _filestr.type != FT.GML {return -2}
	var _file = _filestr.file;
	for (var i = 0; i < array_length(_file); i++) {
		var _line = _file[i];
		if !_format {
			_line = string_replace_all(_line, " ", "");
			_line = string_replace_all(_line, "\t", "");
			if string_pos("/// @desc ", _line) != 0 {_line = string_copy(_line, 1, string_pos("/// @desc ", _line) - 1)}
		}
		
		if string_pos(_substring, _line) != 0 {
			return i;
		}
		
	}
	return -1;
}

/// @desc 4.5555- having the path and an index, finds the FIRST line that starts with the given string in it (by toggling format off you can remove all spaces and tabs from the string and stripping comments)
function archive_fetch_gml_string_startswith(_archpos, _fullpath, _substring, _format = true) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestr == undefined or _filestr.type != FT.GML {return -2}
	var _file = _filestr.file;
	for (var i = 0; i < array_length(_file); i++) {
		var _line = _file[i];
		if !_format {
			_line = string_replace_all(_line, " ", "");
			_line = string_replace_all(_line, "\t", "");
			if string_pos("/// @desc ", _line) != 0 {_line = string_copy(_line, 1, string_pos("/// @desc ", _line) - 1)}
		}
		
		if string_starts_with(_line, _substring) {
			return i;
		}
		
	}
	return -1;
}

/// @desc 5- having the path and a new sprite path, deletes the old and replaces it, pass undefined as new sprite to create a new one
function archive_edit_sprite(_archpos, _fullpath, _newspritepath, _renamedfullpath) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _newspritepath != undefined {
		if _filestr == undefined or _filestr.type != FT.SPRITE or !file_exists(_newspritepath) {return false}
		if sprite_exists(_filestr.file) {
			sprite_delete(_filestr.file);
		} else {
			show_debug_message("Error: Sprite failed to load: " + string(_filestr.path));
		}
		_filestr.path = _renamedfullpath;
		_filestr.file = add_sprite_strip(_newspritepath);
		_filestr.modified = true;
		global.archive_modified = true;
		return true;
	} else {
		if _filestr == undefined or _filestr.type != FT.SPRITE {return false}
		if sprite_exists(_filestr.file) {
			sprite_delete(_filestr.file);
		} else {
			show_debug_message("Error: Sprite failed to load: " + string(_filestr.path));
		}
		_filestr.path = _renamedfullpath;
		_filestr.file = sprite_add("empty.png", 1, false, false, 0, 0);
		_filestr.modified = true;
		global.archive_modified = true;
		return true;
	}
}

/// @desc 5.5- having the path and a new sprite path, deletes the old and replaces it, pass undefined as new sprite to create a new one
function archive_edit_sprite_existing(_archpos, _fullpath, _newsprite, _renamedfullpath) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _newsprite != undefined {
		if _filestr == undefined or _filestr.type != FT.SPRITE or !sprite_exists(_newsprite) {return false}
		if sprite_exists(_filestr.file) {
			sprite_delete(_filestr.file);
		} else {
			show_debug_message("Error: Sprite failed to load: " + string(_filestr.path));
		}
		_filestr.path = _renamedfullpath;
		_filestr.file = _newsprite;
		_filestr.modified = true;
		global.archive_modified = true;
		return true;
	} else {
		if _filestr == undefined or _filestr.type != FT.SPRITE {return false}
		if sprite_exists(_filestr.file) {
			sprite_delete(_filestr.file);
		} else {
			show_debug_message("Error: Sprite failed to load: " + string(_filestr.path));
		}
		_filestr.path = _renamedfullpath;
		_filestr.file = sprite_add("empty.png", 1, false, false, 0, 0);
		_filestr.modified = true;
		global.archive_modified = true;
		return true;
	}
}

/// @desc 7- having path and a key, edits the ini file
function archive_edit_ini(_archpos, _fullpath, _key, _newvalue) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestr == undefined or _filestr.type != FT.INI {return false}
	
	if struct_exists(_filestr.file, _key) {
		_filestr.file[$ _key] = _newvalue;
		_filestr.modified = true;
		global.archive_modified = true;
		return true;
	} else {return false}
}

/// @desc 8- having a path, erase that filestruct
function archive_delete(_archpos, _fullpath) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestr == undefined or _filestr.type == FT.INI {return false}
	var _pos = archive_fetch_position(_archpos, _fullpath);
	var _archarr = archive_fetch(_archpos);
	switch _filestr.type {
		case FT.SPRITE:
			if sprite_exists(_filestr.file) {
				sprite_delete(_filestr.file);
			} else {
				show_debug_message("Error: Sprite failed to load: " + string(_filestr.path));
			}
			break;
	}
	array_delete(_archarr, _pos, 1);
	global.archive_modified = true;
	return true;
}

/// @desc 9- given a NEW path, create an empty filestruct of type X
function archive_create(_archpos, _newfullpath, _ftype) {
	var _archarr = archive_fetch(_archpos);
	if _archarr == undefined {return false}
	if archive_fetch_filestruct(_archpos, _newfullpath) == undefined {
		switch _ftype {
			case FT.GML:
				array_push(_archarr, {
					type: _ftype,
					path: _newfullpath,
					file: [""],
					modified: true
				});
				break;
			case FT.SPRITE:
				array_push(_archarr, {
					type: _ftype,
					path: _newfullpath,
					file: sprite_add("empty.png", 1, false, false, 0, 0),
					modified: true
				});
				break;
			default:
				return false;
		}
		global.archive_modified = true;
		return true;
	} else {
		return false;
	}
}

/// @desc 10- given an existing path and a NEW path, moves the old to the new
function archive_reposition(_archpos, _fullpath, _fullpathnew) {
	var _struct = archive_fetch_filestruct(_archpos, _fullpath);
	if _struct == undefined or archive_fetch_filestruct(_archpos, _fullpathnew) != undefined {return false}
	_struct.path = _fullpathnew;
	_struct.modified = true;
	return true;
}

/// @desc 10.5- given an existing path replaces the old file with the new one (file must match struct's filetype)
function archive_replace(_archpos, _fullpath, _newFile) {
	var _filestr = archive_fetch_filestruct(_archpos, _fullpath);
	if _filestr == undefined {return false}
	switch _filestr.type {
		case FT.SPRITE:
			if filename_ext(_newFile) == ".png" {
				archive_edit_sprite(_archpos, _fullpath, _newFile, _fullpath);
			} else {return false}
			break;
		case FT.INI:
			if filename_ext(_newFile) == ".ini" {
				_filestr.file = add_ini_struct(_newFile);
				_filestr.modified = true;
				global.archive_modified = true;
			} else {return false}
			break;
		case FT.GML:
			if filename_ext(_newFile) == ".gml" {
				_filestr.file = add_gml_array(_newFile);
				_filestr.modified = true;
				global.archive_modified = true;
			} else {return false}
			break;
	}
	return true;
}

/// @desc 11- save everything function that saves every file in the disc, deletes files that have no filestruct associated and create new ones
function ARCHIVE_SAVE() {
	global.archive_modified = false;
	var _EVERYpath = array_concat(get_all_files_full(global.selected_path), get_all_files_full(global.selected_path+"/sprites"), get_all_files_full(global.selected_path+"/scripts"), get_all_files_full(global.selected_path+"/scripts/attacks"));
	var _EVERYregister = array_concat(global.ARCHIVE.others, global.ARCHIVE.sprites, global.ARCHIVE.scripts.others, global.ARCHIVE.scripts.attacks);
	var _EVERYexisting = [];
	for (var i = 0; i < array_length(_EVERYregister); i++) {
		array_push(_EVERYexisting, _EVERYregister[i].path);
	}
	
	for (var i = 0; i < array_length(_EVERYpath); i++) {
		if !array_contains(_EVERYexisting, _EVERYpath[i]) and file_exists(_EVERYpath[i]) {
			var _p = string("{0}/{1}", global.selected_path, filename_name(_EVERYpath[i]));
			if _p != _EVERYpath[i] {
				file_delete(_EVERYpath[i]);
			}
		}
	}
	
	for (var i = 0; i < array_length(_EVERYregister); i++) {
		if !_EVERYregister[i].modified {
			array_delete(_EVERYregister, i, 1);
			i--;
		}
	}
	
	if array_length(_EVERYregister) == 0 {return}
	
	for (var i = 0; i < array_length(_EVERYregister); i++) {
		switch _EVERYregister[i].type {
			case FT.SPRITE:
				sprite_save_strip(_EVERYregister[i].file, _EVERYregister[i].path);
				break;
			case FT.INI:
				var _keys = struct_get_names(_EVERYregister[i].file);
				ini_open(_EVERYregister[i].path);
				for (var j = 0; j < array_length(_keys); j++) {
					ini_write_string("general", _keys[j], _EVERYregister[i].file[$ _keys[j]]); // the numbers are apparently saved as a string in config.ini too i guess makes my job easier
				}
				ini_close();
				break;
			case FT.GML:
				array_into_file(_EVERYregister[i].path, _EVERYregister[i].file);
				break;
		}
	}
}

/// @desc 12- completely erases the archive, destroying sprites, then setting it to {}
function ARCHIVE_DESTROY() {
	if array_length(struct_get_names(global.ARCHIVE)) == 0 {global.ARCHIVE = {}; exit}
	var _EVERYregister = array_concat(global.ARCHIVE.others, global.ARCHIVE.sprites, global.ARCHIVE.scripts.others, global.ARCHIVE.scripts.attacks);
	
	for (var i = 0; i < array_length(_EVERYregister); i++) {
		if _EVERYregister[i].type == FT.SPRITE {
			sprite_delete(_EVERYregister[i].file);
		}
	}
	
	global.ARCHIVE = {};
}

/// @desc Automatically puts the / after global.selected!
function get_full_path(_pathafterselected) {
	return string("{0}/{1}", global.selected_path, _pathafterselected);
}

/// @desc Strips all the spaces, tabs and after comment from a string
function string_unformat(_formattedstring) {
	_formattedstring = string_replace_all(_formattedstring, " ", "");
	_formattedstring = string_replace_all(_formattedstring, "\t", "");
	if string_pos("/// @desc ", _formattedstring) != 0 {_formattedstring = string_copy(_formattedstring, 1, string_pos("/// @desc ", _formattedstring) - 1)}
	return _formattedstring;
}