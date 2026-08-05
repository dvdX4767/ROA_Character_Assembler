/// @desc							loads the dialect arrays used for parsing
function load_dialect(){
	variable_global_set("loaded_dialect", false);
	if !directory_exists("dialect"){
		show_message("couldn't find the dialect folder, syntax highlighting will not be available");
		return;
	}
	var _api = file_text_open_read("dialect/api.gml");
	if _api == -1{
		show_message("couldn't find the api.gml file, syntax highlighting will not be available");
		file_text_close(_api);
		return;
	}
	var _const = file_text_open_read("dialect/const.gml");
	if _const == -1{
		show_message("couldn't find the const.gml file, syntax highlighting will not be available");
		file_text_close(_api);
		file_text_close(_const);
		return;
	}
	var _default = file_text_open_read("dialect/default.gml");
	if _default == -1{
		show_message("couldn't find the default.gml file, syntax highlighting will not be available");
		file_text_close(_api);
		file_text_close(_const);
		file_text_close(_default);
		return;
	}
	variable_global_set("parse_statements", ["wait", "in", "try", "catch", "throw", "{", "}", "var", "for", "if", "else", "repeat", "while", "do", "until", "switch", "break", "continue", "exit", "with", "return", "then", "begin", "end", "try", "catch", "finally", "throw", "new", "case", "noone"]);
	variable_global_set("parse_hash", ["#macro", "#define"]);
	variable_global_set("parse_numbers", ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "-"]);
	
	variable_global_set("parse_functions", []);
	variable_global_set("parse_const", []);
	variable_global_set("parse_default", []);
	
	do{
		var _ln = string_trim(string_replace(file_text_readln(_api), ":", ""));
		if !string_length(_ln) || string_char_at(_ln, 1) == "/" continue
		array_push(global.parse_functions, string_copy(_ln, 1, string_pos("(", _ln)-1));
	}until (file_text_eof(_api));
	
	do{
		var _ln = string_trim(file_text_readln(_const));
		if !string_length(_ln) || string_char_at(_ln, 1) == "/" continue
		array_push(global.parse_const, string_copy(_ln, 1, string_pos(" ", _ln)-1));
	}until (file_text_eof(_const));
	array_push(global.parse_const, "null", "undefined");
	
	do{
		var _ln = string_trim(file_text_readln(_default));
		if !string_length(_ln) || string_char_at(_ln, 1) == "/" || string_char_at(_ln, string_length(_ln)) == "#" continue
		array_push(global.parse_default, (string_char_at(_ln, string_length(_ln)-1) == "*"? string_delete(_ln, string_length(_ln)-1, 1): _ln));
	}until (file_text_eof(_default));

	global.loaded_dialect = true;
}


/// @desc							parses the data of the tab and does syntax highlighting
/// @param {obj_ScriptTab} Tab		Tab that owns the file
function parse_syntax(_tab){
	if !global.loaded_dialect return;
	_tab.parse_localvars = [];
	_tab.parse_localconst = [];
	_tab.parse_localfuncs = [];
	
	var _data = array_clone(_tab.data);
	var _am = array_length(_data);
	var _g = 0;
	repeat _am{ //find local stuff
		var _ln = _data[_g];
		var _len = string_length(_ln);
		if string_pos("#define ", _ln) == 1 && char_is_nameable(string_char_at(_ln, 9)){
			var _fnd = string_filter_find_name(string_copy(_ln, 9, _len-8), true);
			if _fnd != "" array_push(_tab.parse_localfuncs, _fnd)
		}
		if string_pos("#macro ", _ln) == 1 && char_is_nameable(string_char_at(_ln, 8)){
			var _fnd = string_filter_find_name(string_copy(_ln, 8, _len-7), true);
			if _fnd != "" array_push(_tab.parse_localconst, _fnd)
		}
		var _pos = string_pos("var ", _ln);
		while (_pos != 0 && _pos <= _len-5 && char_is_nameable(string_char_at(_ln, _pos+4))){
			array_push(_tab.parse_localvars, string_filter_find_name(string_copy(_ln, _pos+4, _len-_pos-3), true));
			_pos++;
			_pos = string_pos_ext("var ", _ln, _pos);
		}
		_g++;
	}
	
	//compute the highlight arrays
	_tab.data_statements = array_create(_am, "");
	_tab.data_functions = array_create(_am, "");
	_tab.data_const = array_create(_am, "");
	_tab.data_default = array_create(_am, "");
	_tab.data_temp_var = array_create(_am, "");
	_tab.data_hash = array_create(_am, "");
	//_tab.data_strings = array_create(_am, "");
	_tab.data_comment = array_create(_am, "");
	//_tab.data_numbers = array_create(_am, "");
	
	var _stat_am = array_length(global.parse_statements); 
	var _funcs = array_concat(global.parse_functions, _tab.parse_localfuncs); 
	var _fun_am = array_length(_funcs); 
	var _consts = array_concat(global.parse_const, _tab.parse_localconst); 
	var _con_am = array_length(_consts);
	var _def_am = array_length(global.parse_default);
	var _loc_am = array_length(_tab.parse_localvars);
	var _hash_am = array_length(global.parse_hash);
	_g = 0;
	var _cmnt_block = 0;
	var _string_block = 0;
	var _string_blockchar = "";
	
	repeat _am{ //find local stuff
		var _ln = _data[_g];
		var _wln = _ln;
		var _len = string_length(_ln);
		
		//comments
		var _cmnt = extract_comment(_wln, _cmnt_block);
		_cmnt_block = _cmnt[1];
		_tab.data_comment[_g] = _cmnt[0];
		_wln = string_xor_spaces(_wln, _cmnt[0]);
		
		//strings _string_block
		if string_trim(_wln) == "" _tab.data_temp_var[_g] = _wln;
		else{
			var _strng = extract_string(_wln, _string_block, _string_blockchar);
			_string_block = _strng[1];
			_string_blockchar = _strng[2];
			_tab.data_temp_var[_g] = _strng[0];
			print(_strng[0])
			_wln = string_xor_spaces(_wln, _strng[0]);
		}
		
		//data numbers
		if string_trim(_wln) == "" _tab.data_const[_g] = _wln;
		else _tab.data_const[_g] = extract_numbers(_wln);
		
		//statements
		if string_trim(_wln) == "" _tab.data_statements[_g] = _wln;
		else{
			var _i = 0;
			var _wln2 = _wln;
			repeat _stat_am{
				var _ck = global.parse_statements[_i];
				if string_pos(_ck, _wln) _wln = string_remove_bounded(_wln, _ck);
				_i++;
			};
			_tab.data_statements[_g] = (_stat_am? string_xor_spaces(_wln2, _wln): string_spaces(string_length(_wln2)));
		}
		
		//functions
		if string_trim(_wln) == "" _tab.data_functions[_g] = _wln;
		else{
			var _i = 0;
			var _wln2 = _wln;
			repeat _fun_am{
				var _ck = _funcs[_i];
				if string_pos(_ck, _wln) _wln = string_remove_bounded(_wln, _ck);
				_i++;
			}
			_tab.data_functions[_g] = (_fun_am? string_xor_spaces(_wln2, _wln): string_spaces(string_length(_wln2)));
		}
		
		//consts
		if string_trim(_wln) == "" _tab.data_const[_g] = _wln;
		else{
			var _i = 0;
			var _wln2 = _wln;
			repeat _con_am{
				var _ck = _consts[_i];
				if string_pos(_ck, _wln) _wln = string_remove_bounded(_wln, _ck);
				_i++;
			}
			if _con_am _tab.data_const[_g] = string_mix_spaces(_tab.data_const[_g], string_xor_spaces(_wln2, _wln));
			else _tab.data_const[_g] = string_mix_spaces(_tab.data_const[_g], string_spaces(string_length(_wln2)));
		}
		
		//defaults
		if string_trim(_wln) == "" _tab.data_default[_g] = _wln;
		else{
			var _i = 0;
			var _wln2 = _wln;
			repeat _def_am{
				var _ck = global.parse_default[_i];
				if string_pos(_ck, _wln) _wln = string_remove_bounded(_wln, _ck);
				_i++;
			}
			_tab.data_default[_g] = (_def_am? string_xor_spaces(_wln2, _wln): string_spaces(string_length(_wln2)));
		}
		
		//temp vars
		if string_trim(_wln) == "" _tab.data_temp_var[_g] = _wln;
		else{
			var _i = 0;
			var _wln2 = _wln;
			repeat _loc_am{
				var _ck = _tab.parse_localvars[_i];
				if string_pos(_ck, _wln) _wln = string_remove_bounded(_wln, _ck);
				_i++;
			}
			if _loc_am _tab.data_temp_var[_g] = string_mix_spaces(_tab.data_temp_var[_g], string_xor_spaces(_wln2, _wln));
			else _tab.data_temp_var[_g] = string_mix_spaces(_tab.data_temp_var[_g], string_spaces(string_length(_wln2)));
		}
		
		//hash commands
		if string_trim(_wln) == "" _tab.data_hash[_g] = _wln;
		else{
			var _i = 0;
			var _wln2 = _wln;
			repeat _hash_am{
				var _ck = global.parse_hash[_i];
				if string_pos(_ck, _wln) _wln = string_remove_bounded(_wln, _ck);
				_i++;
			}
			_tab.data_hash[_g] = (_hash_am? string_xor_spaces(_wln2, _wln): string_spaces(string_length(_wln2)));
			
		}
		
		_g++;
	}
}

//functional stuff

function string_filter_find_name(_str, _num = false) {
	var _result = "";
	var _len = string_length(_str);
	var _i = 0;
	var _char = string_char_at(_str, _i+1);
	while (_i < _len && char_is_nameable(_char, _num)){
		_result += _char;
		_i++;
		_char = string_char_at(_str, _i+1);
	}
	return _result;
}

function string_remove_bounded(_str, _substr){
	var _len = string_length(_str);
	var _len2 = string_length(_substr);
	var _pos = string_pos(_substr, _str);
	while (_pos!=0 && _pos<=_len){
		var _eos = _pos + _len2;
		if (_pos == 1 || !char_is_nameable(string_char_at(_str, _pos-1))) && (_eos > _len || !char_is_nameable(string_char_at(_str, _eos))){
			_str = string_delete(_str, _pos, _len2);
			_str = string_insert(string_spaces(_len2), _str, _pos);
		}
		_pos = string_pos_ext(_substr, _str, _pos+1);
	}
	
	return _str;
}

function string_spaces(_num){
	var _re = "";
	repeat _num _re += " ";
	return _re;
}

function string_xor_spaces(_str, _xor){
	var _i = 1;
	var _len = string_length(_str);
	var _lenx = string_length(_xor);
	var _res = "";
	repeat _len{
		_res += (_i <= _lenx? (string_char_at(_xor, _i) == " "? string_char_at(_str, _i): " "): string_char_at(_str, _i));
		_i++;
	}
	return _res;
}

function extract_comment(_str, _block){
	var _i = 1;
	var _len = string_length(_str);
	var _res = "";
	var _skip = 0;
	repeat _len{
		var _c = string_char_at(_str, _i);
		var _nc = (_i+1 > _len? "": string_char_at(_str, _i+1));
		if _skip _res += _c;
		else if _block{
			if _c == "*" && _nc == "/"{
				_res += "*/";
				_block = 0;
				_i++;
			}else _res += _c;
		}else{
			if _c == "/"{
				if _nc == "*"{
					_res += "/*";
					_block = 1;
					_i++;
				}else if _nc == "/"{
					_res += "//";
					_skip = 1;
					_i++;
				}else _res += " ";
			}else _res += " ";
		}
		_i++;
	}
	return [_res, _block];
}

function extract_string(_str, _block, _blockchar){
	var _i = 1;
	var _len = string_length(_str);
	var _res = "";
	repeat _len{
		var _c = string_char_at(_str, _i);
		if _block{
			if _c == _blockchar _block = 0;
			_res += _c;
		}else if _c == chr(34) || _c == "'" || _c == "`"{
			_block = 1;
			_blockchar = _c;
			_res += _c;
		}else _res += " ";
		_i++;
	}
	return [_res, _block, _blockchar];
}

function extract_numbers(_str){
	var _i = 1;
	var _len = string_length(_str);
	var _res = "";
	var _prevchar = 0;
	repeat _len{
		var _c = string_char_at(_str, _i);
		var _nm = char_is_nameable(_c, _prevchar);
		_res += (!_nm && ord(_c) == clamp(ord(_c), 48, 57)? _c: " ");
		_prevchar = _nm;
		_i++;
	}
	return _res;
}

function string_mix_spaces(_str1, _str2){
	var _i = 1;
	var _len1 = string_length(_str1);
	var _len2 = string_length(_str2);
	var _res = "";
	repeat max(_len1, _len2){
		var _c1 = (_i > _len1? " ": string_char_at(_str1, _i));
		var _c2 = (_i > _len2? " ": string_char_at(_str2, _i));
		_res += (_c1 == " "? _c2: _c1);
		_i++;
	}
	return _res;
}