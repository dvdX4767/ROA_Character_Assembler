/// @desc							moves the given cursors in a direction (cardinal)
/// @param {Array} cursors_array	array of cursors
/// @param {Real} direction			direction to move the cursors in (E, N, W, S)
/// @param {Array} File				file to move the cursors in
/// @param {obj_ScriptTab} Tab		Tab object
function move_cursors(_cur, _dir, _data, _tab){
	var _am = array_length(_cur);
	if !_am return;
	var _g = 0;
	if _dir%2{
		if keyboard_check(vk_alt) && false{ //never gonna be finished
			array_sort(_cur, sort_cursors);
			if _dir == 3 _g = _am-1;
			if keyboard_check(vk_shift){
				
			}else{
				repeat _am{
					
					_g += 1 - 2*(_dir == 3);
				}
			}
		}else repeat _am{
			var c = _cur[_g];
			var _oldp = [c.pos, c.line];
			c.line += _dir-2;
			if _dir < 2 && c.line < 0{
				c.line = 0;
				c.pos = 0;
			}else if _dir > 2 && c.line > array_length(_data)-1{
				c.line = array_length(_data)-1;
				c.pos = string_length(_data[c.line]);
			}
			c.pos = min(c.qolpos, string_length(_data[c.line]));
			if keyboard_check(vk_shift){
				if c.selection == -1 c.selection = _oldp;
				else if array_equals([c.pos, c.line], c.selection) c.selection = -1;
			}else c.selection = -1;
			_g++;
		}
	}else{
		repeat _am{
			var c = _cur[_g];
			var _oldp = [c.pos, c.line];
			if keyboard_check(vk_alt) c.pos = (_dir? 0: string_length(_data[c.line]));
			else{
				do{
					c.pos += 1 - _dir;
					if _dir && c.pos < 0{
						c.line--;
						c.pos = (c.line < 0? 0: string_length(_data[c.line]));
						c.line = max(0, c.line);
					}else if !_dir && c.pos > string_length(_data[c.line]){
						c.line++;
						c.pos = 0;
						if c.line > array_length(_data)-1{
							c.line = array_length(_data)-1;
							c.pos = string_length(_data[c.line]);
						}
					}
				}until !(keyboard_check(vk_control) && char_is_nameable(string_char_at(_data[c.line], c.pos + (_dir>0))) && char_is_nameable(string_char_at(_data[c.line], c.pos + 1 - (_dir>0))));
			}
			c.qolpos = c.pos;
			if keyboard_check(vk_shift){
				if c.selection == -1 c.selection = _oldp;
				else if c.pos == c.selection[0] && c.line == c.selection[1] c.selection = -1;
			}else c.selection = -1;
			_g++;
		}
	}
	
	cursor_check(_cur, _data, _tab);
}

/// @desc							checks cursor status and removes overlaps as well as fix view
/// @param {Array} cursors_array	array of cursors
/// @param {Array} File				file to move the cursors in
/// @param {obj_ScriptTab} Tab		Tab object
function cursor_check(_cur, _data, _tab){
	var _am = array_length(_cur);
	if !_am return;
	var _g = 0; //check for overlap
	if _am > 1 repeat _am{
		var _i = 0;
		repeat _am{
			var c1 = _cur[_g];
			var c2 = _cur[_i];
			if _g != _i && c1.line == c2.line && c1.pos == c2.pos{
				array_delete(_cur, _i, 1);
				_am--;
			}else if cursor_in_selection(c2, c1){
				if c2.selection != -1 switch cursor_position_to_anchor(c1){
					case 1:
					if c2.selection[1] < c1.selection[1] c1.selection = [c2.selection[0], c2.selection[1]];
					else c1.selection[0] = min(c1.selection[0], c2.selection[0]);
					break;
					
					case 0:
					c1.selection[0] = (c1.pos > c1.selection[0]? min(c1.selection[0], c2.selection[0]): max(c1.selection[0], c2.selection[0]));
					break;
					
					case -1:
					if c2.selection[1] > c1.selection[1] c1.selection = [c2.selection[0], c2.selection[1]];
					else c1.selection[0] = max(c1.selection[0], c2.selection[0]);
					break;
				}
				array_delete(_cur, _i, 1);
				_am--;
			}
			_i++;
			if _i > _am-1 break;
		}
		_g++;
		if _g > _am-1 break;
	}
	
	//shift view
	var _linemin = _cur[0].line;
	var _linemax = _cur[0].line;
	var _posmin = _cur[0].pos;
	var _posmax = _cur[0].pos;
	_g = 1;
	repeat _am-1{
		_linemin = min(_linemin, _cur[_g].line);
		_linemax = max(_linemax, _cur[_g].line);
		_posmin = min(_posmin, _cur[_g].pos);
		_posmax = max(_posmax, _cur[_g].pos);
		_g++;
	}
	draw_set_font(fnt_maplemono_SDF);
	var wdt = string_width(" ");
	_linemin *= 20;
	_linemax *= 20;
	_posmin *= wdt;
	_posmax *= wdt;
	if _linemin < -_tab.textview[1]{
		_tab.textview[1] = max(_tab.textview[1], -_linemin);
		_tab.textscroll_speed = [0, 0];
	}
	if _linemax > -_tab.textview[1] + 683{
		_tab.textview[1] = min(_tab.textview[1], -_linemax + 683);
		_tab.textscroll_speed = [0, 0];
	}
	if _posmin < -_tab.textview[0]{
		_tab.textview[0] = max(_tab.textview[0], -_posmin);
		_tab.textscroll_speed = [0, 0];
	}
	if _posmax > -_tab.textview[0] + 1052 - wdt*7{
		_tab.textview[0] = min(_tab.textview[0], -_posmax + 1052 - wdt*7);
		_tab.textscroll_speed = [0, 0];
	}
	_tab.showcursors = 0;
	
	array_sort(_tab.cursors, sort_cursors);
}

/// @desc							enable the modified flag for given file, also adds to the changes buffer
/// @param {Struct} file_struct		file struct
/// @param {obj_ScriptTab} Tab		Tab that owns the file
function trigger_modifications(_filestruct, _tab){
	_filestruct.modified = true;
	global.archive_modified = true;
	if array_length(_tab.all_buffers) >= _tab.changes_buffer_max array_delete(_tab.all_buffers, 0, 1);
	if _tab.undos{
		array_delete(_tab.all_buffers, array_length(_tab.all_buffers)-_tab.undos, _tab.undos);
		_tab.undos = 0;
	}
	var _omni = [];
	var _g = 0;
	repeat array_length(all_container){
		array_push(_omni, variable_instance_get(_tab, all_container[_g]));
		_g++;
	}
	array_push(_tab.all_buffers, array_clone(_omni));
	parse_timer = 0;
}

/// @desc							enable the modified flag for given file
/// @param {Struct} file_struct		file struct
/// @param {obj_ScriptTab} Tab		Tab that owns the file
function trigger_modifications_nobuf(_filestruct, _tab){
	_filestruct.modified = true;
	global.archive_modified = true;
	parse_timer = 0;
}

/// @desc							adds an action to the undo/redo buffer
/// @param {obj_ScriptTab} Tab		Tab that owns the file
function trigger_change_buf_nosave(_tab){
	if array_length(_tab.all_buffers) >= _tab.changes_buffer_max array_delete(_tab.all_buffers, 0, 1);
	if _tab.undos{
		array_delete(_tab.all_buffers, array_length(_tab.all_buffers)-_tab.undos, _tab.undos);
		_tab.undos = 0;
	}
	var _omni = [];
	var _g = 0;
	repeat array_length(all_container){
		array_push(_omni, variable_instance_get(_tab, all_container[_g]));
		_g++;
	}
	array_push(_tab.all_buffers, array_clone(_omni));
}

/// @desc							pushes the data from a source array to a destination array
/// @param {Array} source
/// @param {Array} destination
function array_move(_src, _dest){
	var _g = 0, _am = array_length(_src);
	repeat _am{
		array_push(_dest, variable_clone(_src[_g]));
		_g++;
	}
}

/// @desc							creates a copy of an array
/// @param {Array} source
function array_clone(_arr){
	var _i = 0;
	var _ret = [];
	repeat array_length(_arr){
		array_push(_ret, variable_clone(_arr[_i]));
		_i++;
	}
	return _ret;
}

/// @desc							used to compare 2 cursors for sorting
function sort_cursors(_a, _b){
	return (_a.line == _b.line? _a.pos - _b.pos: _a.line - _b.pos);
}

/// @desc							returns whether a cursor is inside the selection of another cursor
/// @param {Struct} cursor1			the cursor to check
/// @param {Struct} cursor2			the cursor with the selection
function cursor_in_selection(c1, c2){
	return c1 != c2 && c2.selection != -1 && c1.line == clamp(c1.line, min(c2.line, c2.selection[1]), max(c2.line, c2.selection[1])) && (c2.line == c2.selection[1]? c1.pos == clamp(c1.pos, min(c2.pos, c2.selection[0]), max(c2.pos, c2.selection[0])): (c1.line == max(c2.line, c2.selection[1])? c1.pos < (c2.line > c2.selection[1]? c2.pos: c2.selection[0]): (c1.line == min(c2.line, c2.selection[1])? c1.pos > (c2.line < c2.selection[1]? c2.pos: c2.selection[0]): false)));
}

/// @desc							returns the position relative to selection anchor (1 = anchor is above, -1 = anchor is below, 0 = same line, noone = no anchor)
/// @param {Struct} cursor1			the cursor to check
function cursor_position_to_anchor(_c){
	return (_c.selection != -1? sign(_c.line - _c.selection[1]): noone);
}

/// @desc							writes to a given file, given an array of cursors on that file, also takes care of offsetting the cursors and whatnot, returns true if successful
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
/// @param {String} char			the single character to write
function cursors_write_char(_cursors, _file, _char){
	_char = string_char_at(_char, 1);
	if _char == "" || ord(_char) == 127 return;
	var _am = array_length(_cursors)
	var _i = 0, _g = 0;
	repeat _am{
		var _c = _cursors[_g];
		cursor_write_char(_c, _cursors, _file, _char);
		_g++;
	}
}

/// @desc							writes to a given file, given an array of cursors on that file, also takes care of offsetting the cursors and whatnot, returns true if successful
/// @param {Struct} cursor			the cursor that writes
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
/// @param {String} char			the single character to write
function cursor_write_char(_c, _cursors, _file, _char){
	_char = string_char_at(_char, 1);
	if _char == "" || ord(_char) == 127 return;
	var _am = array_length(_cursors)
	var _i = 0
	if _c.selection != -1 cursor_delete_selection(_c, _cursors, _file);
	_file[@_c.line] = string_insert(_char, _file[_c.line], _c.pos+1);
	var _tab = obj_EDITORscripts.tab, _f = 0;
	repeat array_length(_tab.highlight_banks){
		var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
		_dat[@_c.line] = string_insert(" ", _dat[_c.line], _c.pos+1);
		_f++;
	}
	repeat _am{
		var _c2 = _cursors[_i];
		if _c2.line == _c.line && _c2.pos >= _c.pos _c2.pos++;
		if _c2.selection != -1 && _c2.selection[1] == _c.line && _c2.selection[0] >= _c.pos _c2.selection[0]++;
		_i++;
	}
}

/// @desc							writes to a given file, given an array of cursors on that file, also takes care of offsetting the cursors and whatnot, returns true if successful
/// @param {Struct} cursor			the cursor that writes
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
/// @param {String} string			the string to write
function cursor_write_string(_c, _cursors, _file, _str){
	if _str == "" return false;
	var _len = string_length(_str);
	var _am = array_length(_cursors)
	var _i = 0
	if _c.selection != -1 cursor_delete_selection(_c, _cursors, _file);
	_file[@_c.line] = string_insert(_str, _file[_c.line], _c.pos+1);
	var _tab = obj_EDITORscripts.tab, _f = 0;
	var _spc = string_spaces(_len)
	repeat array_length(_tab.highlight_banks){
		var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
		_dat[@_c.line] = string_insert(_spc, _dat[_c.line], _c.pos+1);
		_f++;
	}
	repeat _am{
		var _c2 = _cursors[_i];
		if _c2.line == _c.line && _c2.pos >= _c.pos _c2.pos += _len;
		if _c2.selection != -1 && _c2.selection[1] == _c.line && _c2.selection[0] >= _c.pos _c2.selection[0] += _len;
		_i++;
	}
	return true;
}

/// @desc							given a set of cursors and a file, it writes a newline for each
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
function cursors_write_newline(_cursors, _file){
	var _am = array_length(_cursors);
	if !_am return false;
	var _g = 0;
	var _succ = false;
	repeat _am{
		var _c = _cursors[_g];
		_succ |= cursor_write_newline(_c, _cursors, _file);
		_g++;
	}
	return _succ;
}

/// @desc							given a cursor and a file, it writes a newline at that cursor
/// @param {Struct} cursor			the cursor that writes
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
function cursor_write_newline(_c, _cursors, _file){
	var _am = array_length(_cursors);
	if !_am return false;
	if _c.selection != -1 cursor_delete_selection(_c, _cursors, _file);
	var _str = _file[_c.line];
	var _len = string_length(_str);
	var _i = 0;
	repeat _am{
		var _c2 = _cursors[_i];
		if _c2 != _c{
			if _c2.line > _c.line _c2.line++;
			if _c2.pos > _c.pos && _c.line == _c2.line{
				_c2.line++;
				_c2.pos = _c2.pos-_c.pos;
				_c2.qolpos = _c2.pos;
			}
			if _c2.selection != -1{
				if _c2.selection[1] > _c.line _c2.selection[1]++;
				if _c2.selection[0] > _c.pos && _c.line == _c2.selection[1]{
					_c2.selection[1]++;
					_c2.selection[0] = _c2.selection[0]-_c.pos;
				}
			}
		}
		_i++
	}
	var nlstring = string_delete(_str, 0, _c.pos);
	_file[@_c.line] = string_delete(_str, _c.pos+1, _len-_c.pos+1);
	array_insert(_file, _c.line+1, nlstring);
	var _tab = obj_EDITORscripts.tab, _f = 0;
	repeat array_length(_tab.highlight_banks){
		var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
		_str = _dat[_c.line];
		nlstring = string_delete(_str, 0, _c.pos);
		_dat[@_c.line] = string_delete(_str, _c.pos+1, _len-_c.pos+1);
		array_insert(_dat, _c.line+1, nlstring);
		_f++;
	}
	_c.line++;
	_c.pos = 0;
	_c.qolpos = 0;
	return true;
}

/// @desc							if a given cursor has a selection, then it deletes that selection
/// @param {Struct} cursor			the cursor with the selection
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
/// @return {Real}
function cursor_delete_selection(_c, _curs, _data){
	if _c.selection == -1 return false;
	var _i = 0, _am = array_length(_curs)
	if abs(cursor_position_to_anchor(_c)){
		var _lcut = abs(_c.line - _c.selection[1])
		var _toppos = (_c.line > _c.selection[1]? _c.selection[0]: _c.pos);
		var _botpos = (_c.line < _c.selection[1]? _c.selection[0]: _c.pos);
		var _topline = (_c.line > _c.selection[1]? _c.selection[1]: _c.line);
		var _botline = (_c.line < _c.selection[1]? _c.selection[1]: _c.line);
		var _pdif = _botpos-_toppos;
		_c.selection = -1;
		repeat _am{
			var _c2 = _curs[_i];
			if _c2.line >= _botline _c2.line -= _lcut;
			if _c2.selection != -1 && _c2.selection[1] >= _botline _c2.selection[1] -= _lcut;
			if _c2.line == _botline _c2.pos -= _pdif;
			if _c2.selection != -1 && _c2.selection[1] == _botline _c2.selection[0] -= _pdif;
			_i++;
		}
		_c.pos = _toppos;
		_c.line = _topline;
		_data[_topline] = string_delete(_data[_topline], _toppos+1, string_length(_data[_topline])-_toppos);
		_data[_topline] += string_delete(_data[_botline], 1, _botpos);
		if _lcut array_delete(_data, _topline+1, _lcut);
		
		var _tab = obj_EDITORscripts.tab, _f = 0;
		repeat array_length(_tab.highlight_banks){
			var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
			
			_dat[_topline] = string_delete(_dat[_topline], _toppos+1, string_length(_dat[_topline])-_toppos);
			_dat[_topline] += string_delete(_dat[_botline], 1, _botpos);
			if _lcut array_delete(_dat, _topline+1, _lcut);
			
			_f++;
		}
	}else{
		var _cut = abs(_c.pos - _c.selection[0]);
		_data[_c.line] = string_delete(_data[_c.line], min(_c.pos, _c.selection[0])+1, _cut);
		
		var _tab = obj_EDITORscripts.tab, _f = 0;
		repeat array_length(_tab.highlight_banks){
			var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
			
			_dat[_c.line] = string_delete(_dat[_c.line], min(_c.pos, _c.selection[0])+1, _cut);
			
			_f++;
		}
		repeat _am{
			var _c2 = _curs[_i];
			if _c2.line == _c.line && _c2.pos > _c.pos _c2.pos -= _cut;
			if _c != _c2 && _c2.selection != -1 && _c2.selection[1] == _c.line && _c2.selection[0] > _c.pos _c2.selection[0] -= _cut;
			_i++;
		}
		_c.pos = min(_c.pos, _c.selection[0]);
		_c.selection = -1;
	}
	return true;
}

/// @desc							deletes a char on a given cursor
/// @param {Struct} cursor			the cursor with the selection
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
/// @param {Real} del_pressed		if the deletion was done by pressing delete instead of backspace
function cursor_delete_char(_c, _cursors, _data, _canc){
	var _i = 0, _am = array_length(_cursors);
	var _modif = false;
	if _canc{
		if _c.pos == string_length(_data[_c.line]) && array_length(_data)-1 > _c.line{
			repeat _am{
				var _c2 = _cursors[_i];
				if _c2.line > _c.line{
					_c2.line--;
					if _c2.line == _c.line _c2.pos += string_length(_data[_c.line]);
				}
				if _c2.selection != -1 && _c2.selection[1]> _c.line{
					_c2.selection[1]--;
					if _c2.selection[1] == _c.line _c2.selection[0] += string_length(_data[_c.line]);
				}
				_i++;
			}
			_data[_c.line] += _data[_c.line+1];
			array_delete(_data, _c.line+1, 1);
			
			var _tab = obj_EDITORscripts.tab, _f = 0;
			repeat array_length(_tab.highlight_banks){
				var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
			
				_dat[_c.line] += _dat[_c.line+1];
				array_delete(_dat, _c.line+1, 1);
			
				_f++;
			}
			_modif = true;
		}else{
			_data[@_c.line] = string_delete(_data[_c.line], _c.pos+1, 1);
			
			var _tab = obj_EDITORscripts.tab, _f = 0;
			repeat array_length(_tab.highlight_banks){
				var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
			
				_dat[@_c.line] = string_delete(_dat[_c.line], _c.pos+1, 1);
			
				_f++;
			}
			repeat _am{
				var _c2 = _cursors[_i];
				if _c2.line == _c.line && _c2.pos > _c.pos _c2.pos = max(0, _c2.pos-1);
				if _c2.selection != -1 && _c2.selection[1] == _c.line && _c2.selection[0] > _c.pos _c2.selection[0] = max(0, _c2.selection[0]-1);
				_i++;
			}
			_modif = true;
		}
	}else{
		if _c.pos == 0{
			var _ol = _c.line;
			_c.line = max(0, _c.line-1);
			var _nl = _c.line;
			if _nl != _ol{
				_c.pos = string_length(_data[_nl]);
				repeat _am{
					var _c2 = _cursors[_i];
					if _c2.line == _ol{
						_c2.line = _nl;
						_c2.pos += string_length(_data[_nl]);
					}else if _c2.line > _ol _c2.line--;
					if _c2.selection != -1{
						if _c2.selection[1] == _ol{
							_c2.selection[1] = _nl;
							_c2.selection[0] += string_length(_data[_nl]);
						}else if _c2.selection[1] > _ol _c2.selection[1]--;
					}
					_i++;
				}
				_data[@_nl] = string_concat(_data[_nl], _data[_ol]);
				array_delete(_data, _ol, 1);
				
				var _tab = obj_EDITORscripts.tab, _f = 0;
				repeat array_length(_tab.highlight_banks){
					var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
			
					_dat[@_nl] = string_concat(_dat[_nl], _dat[_ol]);
					array_delete(_dat, _ol, 1);
			
					_f++;
				}
				_modif = true;
			}
		}else{
			_data[@_c.line] = string_delete(_data[_c.line], _c.pos, 1);
			
			var _tab = obj_EDITORscripts.tab, _f = 0;
			repeat array_length(_tab.highlight_banks){
				var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
			
				_dat[@_c.line] = string_delete(_dat[_c.line], _c.pos, 1);
			
				_f++;
			}
			repeat _am{
				var _c2 = _cursors[_i];
				if _c2.line == _c.line && _c2.pos >= _c.pos _c2.pos = max(0, _c2.pos-1);
				if _c2.selection != -1 && _c2.selection[1] == _c.line && _c2.selection[0] >= _c.pos _c2.selection[0] = max(0, _c2.selection[0]-1);
				_i++;
			}
			_modif = true;
		}
	}
	return _modif;
}

/// @desc							deletes all alphabetical an _ chars in a row
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
/// @param {Real} del_pressed		if the deletion was done by pressing delete instead of backspace
function cursor_delete_char_cont(_cursors, _data, _canc){
	var _succ = false;
	var _am = array_length(_cursors);
	var _g = 0;
	repeat _am{
		var _c = _cursors[_g];
		var _del = "";
		if _c.selection != -1{
			cursor_delete_selection(_c, _cursors, _data);
			_succ = true;
		}else do{
			_del = string_char_at(_data[_c.line], _c.pos);
			if cursor_delete_char(_c, _cursors, _data, _canc) _succ = true;
		}until !(char_is_nameable(_del) && char_is_nameable(string_char_at(_data[_c.line], _c.pos)))
		_g++;
	}
	return _succ;
}

/// @desc							checks if a given character can be part of a variable name (a-zA-z_)
/// @param {String} char
function char_is_nameable(_ch, _numbers = true){
	var _asc = ord(_ch);
	return _asc == clamp(_asc, 65, 90) || _asc == clamp(_asc, 97, 122) || (_numbers && _asc == clamp(_asc, 48, 57)) || _asc == 95;
}

/// @desc							resets the QOL positions of cursors, used to make them reposition when moving between lines
/// @param {Array} cursors			the cursor array
function cursor_reset_qolpos(_cursors){
	var _g = 0;
	repeat array_length(_cursors){
		_cursors[_g].qolpos = _cursors[_g].pos;
		_g++;
	}
}

/// @desc							writes a tab at the cursor positons, adds a tab at the start of line if selection is present
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
function cursor_write_tabs(_cursors, _file){
	var _g = 0, _succ = false;
	repeat array_length(_cursors){
		var _c = _cursors[_g];
		if _c.selection != -1{
			var _os = _c.selection;
			var _op = [_c.pos, _c.line];
			_c.selection = -1;
			_c.pos = 0;
			_c.line = min(_os[1], _op[1]);
			repeat abs(_op[1]-_os[1])+1{
				_succ |= cursor_write_string(_c, _cursors, _file, "    ");
				_c.pos = 0;
				_c.line++;
			}
			_c.selection = _os;
			_c.pos = _op[0];
			_c.line = _op[1];
		}else _succ |= cursor_write_string(_c, _cursors, _file, string_delete("    ", 1, _c.pos%4));
		_g++;
	}
	return _succ;
}

/// @desc							removes a tab if the cursor is in front of x amount of spaces, triggered with shift tab
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
function cursor_remove_tabs(_cursors, _file){
	var _g = 0, _succ = false;
	repeat array_length(_cursors){
		var _c = _cursors[_g];
		if _c.selection != -1{
			var _os = _c.selection;
			var _op = [_c.pos, _c.line];
			_c.selection = -1;
			_c.pos = 0;
			_c.line = min(_os[1], _op[1]);
			repeat abs(_op[1]-_os[1])+1{
				repeat 4{
					if string_char_at(_file[_c.line], 1) == " " _succ |= cursor_delete_char(_c, _cursors, _file, true);
					else break;
				}
				_c.pos = 0;
				_c.line++;
			}
			_c.selection = _os;
			_c.pos = _op[0];
			_c.line = _op[1];
		}else if string_replace_all(string_copy(_file[_c.line], 1, _c.pos-1), " ", "") == "" && _c.pos repeat min((_c.pos%4 == 0? 4: _c.pos%4), _c.pos) _succ |= cursor_delete_char(_c, _cursors, _file, false);
		_g++;
	}
	return _succ;
}

/// @desc							given a cursor and its file, it retuns an array of all the lines that are part of the selection, ordered and cut accordingly
/// @param {Struct} cursor			the cursor array
/// @param {Array} file				array of strings
function cursor_grab_selection(_c, _file){
	if _c.selection == -1 return [];
	var _res = [];
	if abs(cursor_position_to_anchor(_c)){
		var _toppos = (_c.line > _c.selection[1]? _c.selection[0]: _c.pos);
		var _botpos = (_c.line < _c.selection[1]? _c.selection[0]: _c.pos);
		var _topline = min(_c.selection[1], _c.line);
		var _botline = max(_c.selection[1], _c.line);
		array_push(_res, string_copy(_file[_topline], _toppos+1, string_length(_file[_topline])-_toppos));
		var _g = 1;
		repeat _botline-_topline-1{
			array_push(_res, _file[_topline+_g]);
			_g++;
		}
		array_push(_res, string_copy(_file[_botline], 1, _botpos));
	}else{
		var _p1 = min(_c.pos, _c.selection[0]), _p2 = max(_c.pos, _c.selection[0]);
		array_push(_res, string_copy(_file[_c.line], _p1+1, _p2-_p1));
	}
	return _res;
}

/// @desc							copies all selection data to the clipboard in a specific format
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
/// @param {Real} delete			boolean to check if the selection should be deleted
function cursors_copy_selection(_cursors, _file, _delete){
	array_sort(_cursors, sort_cursors);
	var _am = array_length(_cursors), _g = 0, _copies = [], _succ = false;
	repeat _am{
		var _c = _cursors[_g];
		if _c.selection != -1{
			array_move(cursor_grab_selection(_c, _file), _copies);
			if _delete && cursor_delete_selection(_c, _cursors, _file) _succ = true;
		}
		_g++;
	}
	var _cop = array_length(_copies);
	//format and copy to clipboard
	if _cop{
		_g = 0;
		var _final = "";
		repeat _cop{
			_final += _copies[_g] + (_g<_cop-1? "\n": "");
			_g++;
		}
		clipboard_set_text(_final);
	}
	return _succ;
}

/// @desc							parses the clipboard and pastes the data on the cursors
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
function cursors_paste_selection(_cursors, _file){
	var _succ = false;
	if !clipboard_has_text() return _succ;
	array_sort(_cursors, sort_cursors);
	var _data = string_split(clipboard_get_text(), "\n", 0);
	var _ls = array_length(_data), _am = array_length(_cursors), _g = 0;
	if _am == _ls repeat _am{
		_succ |= cursor_write_string(_cursors[_g], _cursors, _file, _data[_g]);
		_g++;
	}else repeat _am{
		var _i = 0, _c = _cursors[_g];
		repeat _ls{
			_succ |= cursor_write_string(_c, _cursors, _file, _data[_i]);
			if _i < _ls-1 cursor_write_newline(_c, _cursors, _file)
			_i++;
		}
		_g++;
	}
	return _succ;
}
/// @desc							parses the clipboard and pastes the data on the cursors
/// @param {Array} text				the text to write as an array of lines
/// @param {Struct} cursor			the cursor that writes
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
/// @param {Real} Erase_selection	if it should erase any selection the cursor had
function cursor_write_multiline(_data, _c, _cursors, _file, _erase_sel){
	var _succ = false;
	var _ls = array_length(_data);
	var _i = 0
	var _sel = array_clone(_c.selection);
	var _opos = [_c.pos, _c.line];
	if !_erase_sel _c.selection = -1;
	repeat _ls{
		_succ |= cursor_write_string(_c, _cursors, _file, _data[_i]);
		if _i < _ls-1 cursor_write_newline(_c, _cursors, _file)
		_i++;
	}
	if !_erase_sel{
		_c.selection = _sel;
		_c.pos = _opos[0];
		_c.line = _opos[1];
	}
	return _succ;
}

/// @desc							duplicates a selection or line
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
function cursors_duplicate_string(_cursors, _file){
	var _succ = false, _am = array_length(_cursors);
	if !_am return _succ;
	var _g = 0;
	var _tab = obj_EDITORscripts.tab, _f = 0;
	repeat _am{
		var _i = 0, _c = _cursors[_g];
		var _sel = _c.selection != -1;
		if _sel _succ |= cursor_write_multiline(cursor_grab_selection(_c, _file), _c, _cursors, _file, false);
		else{
			array_insert(_file, _c.line, _file[_c.line]);
			_f = 0;
			repeat array_length(_tab.highlight_banks){
				var _dat = variable_instance_get(_tab, _tab.highlight_banks[_f]);
				array_insert(_dat, _c.line, _dat[_c.line]);
				_f++;
			}
			repeat _am{
				var _c2 = _cursors[_i];
				if _c2.line > _c.line _c2.line++;
				if _c2.selection != -1 && _c2.selection[1] > _c.line _c2.selection[1]++;
				_i++;
			}
			_succ = true;
		}
		_g++;
	}
	return _succ;
}

/// @desc							comments lines with cursors or selection on them in a given file
/// @param {Array} cursors			the cursor array
/// @param {Array} file				array of strings
function cursors_toggle_comment(_cursors, _file){
	var _succ = false, _am = array_length(_cursors);
	if !_am return _succ;
	var _g = 0;
	repeat _am{
		var _c = _cursors[_g];
		var _opos = _c.pos;
		if _c.selection != -1{
			var _oline = _c.line, _i = 0;
			var _sel = array_clone(_c.selection);
			var _add = 0;
			_c.selection = -1;
			repeat abs(_oline-_sel[1])+1{
				var _ln = min(_oline, _sel[1])+_i;
				if string_copy(_file[_ln], 1, 2) == "//"{
					if _ln == _oline _add = -1;
					_c.line = _ln;
					_c.pos = 0;
					repeat 2 _succ |= cursor_delete_char(_c, _cursors, _file, true);
				}else if string_length(_file[_ln]){
					if _ln == _oline _add = -1;
					_c.line = _ln;
					_c.pos = 0;
					_succ |= cursor_write_string(_c, _cursors, _file, "//");
				}
				_i++;
			}
			_c.pos = _opos;
			_c.line = _oline;
			_c.selection = _sel;
			if string_length(_file[_oline]) _c.pos += 2*_add;
		}else if string_length(_file[_c.line]){
			_c.pos = 0;
			var _add = 0;
			if string_copy(_file[_c.line], 1, 2) == "//"{
				repeat 2 _succ |= cursor_delete_char(_c, _cursors, _file, true);
				_add = -1;
			}else{
				_succ |= cursor_write_string(_c, _cursors, _file, "//");
				_add = 1;
			}
			_c.pos = _opos + 2*_add;
		}
		_g++;
	}
	return _succ;
}