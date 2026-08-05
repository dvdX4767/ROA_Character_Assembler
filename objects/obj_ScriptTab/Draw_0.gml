surface_set_target(text_surf);
draw_clear_alpha(c_black, 0);
draw_set_font(fnt_maplemono_SDF);
draw_set_halign(fa_left);
var px = textview[0];
var py = textview[1];
var _scis = gpu_get_scissor();
var _lendata = array_length(data)
var _start = max(0, -floor(py/20))
var _am = min(_lendata-_start, 36 - max(0, floor(py/20)));
var _g = _start;
repeat _am{
	draw_text(4, py + _g*20, _g+1);
	_g++;
}
_g = 0;
gpu_set_scissor(40, 0, 1000, 1000);
var _cwdt = string_width(" ");
var tx = px + 44;
repeat array_length(cursors){
	var _cur = cursors[_g];
	if _cur.selection != -1{
		switch cursor_position_to_anchor(_cur){
			case 1: //cursor is lines below
			draw_rectangle_colour(tx, py + _cur.line*20, tx + _cur.pos*_cwdt, py + _cur.line*20 + 20, c_gray, c_gray, c_gray, c_gray, 0)
			draw_rectangle_colour(tx + _cur.selection[0]*_cwdt, py + _cur.selection[1]*20, tx + string_length(data[_cur.selection[1]])*_cwdt, py + _cur.selection[1]*20 + 20, c_gray, c_gray, c_gray, c_gray, 0)
			var _t = 1;
			repeat max(abs(_cur.line - _cur.selection[1]) - 1, 0){
				draw_rectangle_colour(tx, py + (_cur.selection[1]+_t)*20, tx + string_length(data[_cur.selection[1]+_t])*_cwdt, py + (_cur.selection[1]+_t+1)*20, c_gray, c_gray, c_gray, c_gray, 0)
				_t++;
			}
			break;
			
			case 0: //cursor is on the same line
			draw_rectangle_colour(tx + min(_cur.pos, _cur.selection[0])*_cwdt, py + _cur.line*20, tx + max(_cur.pos, _cur.selection[0])*_cwdt, py + _cur.line*20 + 20, c_gray, c_gray, c_gray, c_gray, 0)
			break;
			
			case -1: //cursor is lines above
			draw_rectangle_colour(tx, py + _cur.selection[1]*20, tx + _cur.selection[0]*_cwdt, py + _cur.selection[1]*20 + 20, c_gray, c_gray, c_gray, c_gray, 0)
			draw_rectangle_colour(tx + _cur.pos*_cwdt, py + _cur.line*20, tx + string_length(data[_cur.line])*_cwdt, py + _cur.line*20 + 20, c_gray, c_gray, c_gray, c_gray, 0)
			_t = 1;
			repeat max(abs(_cur.line - _cur.selection[1]) - 1, 0){
				draw_rectangle_colour(tx, py + (_cur.line+_t)*20, tx + string_length(data[_cur.line+_t])*_cwdt, py + (_cur.line+_t+1)*20, c_gray, c_gray, c_gray, c_gray, 0)
				_t++;
			}
			break;
		}
	}
	if showcursors%60 < 30 draw_text(tx - _cwdt/2 + _cwdt*_cur.pos, py + _cur.line*20, "|");
	_g++;
}

_g = _start;
repeat _am{
	if string_trim(data[_g]) != "" draw_text(tx, py + _g*20, data[_g]);
	_g++;
}

if global.loaded_dialect && parsed{
	_g = _start;
	draw_set_font(fnt_maplemonobold_SDF);
	repeat _am{
		var _c = c_orange;
		draw_text_colour(tx, py + _g*20, data_statements[_g], _c, _c, _c, _c, 1);
		_g++;
	}
	_g = _start;
	var _c = 0;
	draw_set_font(fnt_maplemono_SDF);
	repeat _am{
		if string_trim(data_functions[_g]) != ""{
			_c = c_orange;
			draw_text_colour(tx, py + _g*20, data_functions[_g], _c, _c, _c, _c, 1);
		}
		if string_trim(data_const[_g]) != ""{
			_c = c_red;
			draw_text_colour(tx, py + _g*20, data_const[_g], _c, _c, _c, _c, 1);
		}
		if string_trim(data_default[_g]) != ""{
			_c = c_lime;
			draw_text_colour(tx, py + _g*20, data_default[_g], _c, _c, _c, _c, 1);
		}
		if string_trim(data_temp_var[_g]) != ""{
			_c = c_yellow;
			draw_text_colour(tx, py + _g*20, data_temp_var[_g], _c, _c, _c, _c, 1);
		}
		if string_trim(data_hash[_g]) != ""{
			_c = c_purple;
			draw_text_colour(tx, py + _g*20, data_hash[_g], _c, _c, _c, _c, 1);
		}
		if string_trim(data_comment[_g]) != ""{
			_c = c_green;
			draw_text_colour(tx, py + _g*20, data_comment[_g], _c, _c, _c, _c, 1);
		}
		_g++;
	}
}
gpu_set_scissor(_scis, 0, 10000, 10000);
surface_reset_target();