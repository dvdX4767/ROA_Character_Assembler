/* 
	This is like... the ACTUAL serious utils file which i use for all my projects.
	Now here it should be more tidy and organized than mess.gml
	See? I even used a multi line comment! That's how organized this is.
*/

#macro maybe irandom(1) == 0
#macro perhaps irandom(9) == 0
#macro unlikely irandom(99) == 0
#macro elif else if

/// @desc							Converts a string into a HEX value
/// @param {String} rgb_string		The string formatted as RRRGGGBBB (0-255)
/// @return {Constant.Color}
function string_to_hex(_rgb_string) {
	var _r = real(string_copy(_rgb_string, 1, 3));
	var _g = real(string_copy(_rgb_string, 4, 6));
	var _b = real(string_copy(_rgb_string, 7, 9));
	return make_color_rgb(_r, _g, _b);
}

/// @desc					Looks at a json file given the path and returns a struct array
/// @param {String} path	The file path
/// @return {Array}
function json_into_array(path) {
	if file_exists(path) {
		var _buffer = buffer_load(path);
		
		var _json = buffer_read(_buffer, buffer_string);
		
		buffer_delete(_buffer);
		
		return json_parse(_json);
	} else {
		show_error("Missing file: " + path, true);
	}
}

/// @description			Returns TRUE if the percentage is rolled. Accepts both 0-1 and 2-100% values
/// @param percentage		The percentage value to roll
function chance_of(_percent) {
	if _percent > 1 {return random(1) <= (_percent / 100);} else {return random(1) <= _percent;}
}

/// @desc							Works like instance variable exists AND != undefined for the ULTIMATE varibale check!!!!!!!!
/// @param {Id.Instance} id			The ID of the instance
/// @param {String} variablename	The name of the variable to check
/// @param {Any} value				The value of the variable to check
function is_set(_id, _variableString, _variableValue) {
	return variable_instance_exists(_id, _variableString) and _variableValue != undefined and _variableValue != "";
}

/// @description						Gives a sine/cosine wave ticking a custom variable
/// @param {Bool} usecosine				Wether or not to use cos() instead of sin()
/// @param {Real} width					The width of the wave (distance from zero)
/// @param {Real} offset				The offset of the wave from zero
/// @param {Bool} offsettopositives		Wether or not to make the whole wave positive by pushing it up
/// @param {Real} tickvariable			The variable to tick to progress the wave
/// @return {Real}
function wave(useCosine, width, offset, offsetToPositives, tickVariable) {
	if useCosine {
		return offset + ((width * offsetToPositives) + cos(tickVariable) * width);
	} else {
		return offset + ((width * offsetToPositives) + sin(tickVariable) * width);
	}
}

/// @description				This function returns -1 if the condition is false, and 1 if it's true
/// @param {Bool} condition		The condition to check
/// @return {Real}
function negate(condition) {
	return (condition * 2) - 1;
}

/// @description						Draws a horizontal progress bar that gradually replaces the empty sprite with the full sprite
/// @param {real} x						The x position to draw the progress bar
/// @param {real} y						The y position to draw the progress bar
/// @param {real} percentage			The percentage to show the progress bar (automatic clamp)
/// @param {Asset.GMSprite} emptysprite	The sprite to draw behind the progress bar that works as a background
/// @param {Asset.GMSprite} fullsprite	The sprite to draw as the progress bar that displays the percentage
/// @param {real} xscale				The horizontal scaling of both sprites (default 1)
/// @param {real} yscale				The vertical scaling of both sprites (default 1)
/// @param {Constant.Color}	color		The color to blend with the sprite (default c_white)
/// @param {bool} fadeout				Should the progress bar fade away from 100 to 120%
/// @param {bool} colorempty			Wether or not to apply the color to the empty sprite
function draw_horizontal_progressbar(_targetX, _targetY, _percentage, _emptySprite, _fullSprite, _xsize, _ysize, _color, _fadeOut, _colorEmpty = true, alpha = 1) {
	var _fillPercent = clamp(_percentage, 0, 1);
	var _alpha = alpha;
	if _fadeOut {
		_alpha =  alpha - clamp((_fillPercent - 1) / 0.2, 0, alpha);
		if _alpha == 1 {
			if _colorEmpty {
				draw_sprite_ext(_emptySprite, 0, _targetX, _targetY, _xsize, _ysize, 0, _color, _alpha);
			} else {
				draw_sprite_ext(_emptySprite, 0, _targetX, _targetY, _xsize, _ysize, 0, c_white, _alpha);
			}
		}
	} else {
		if _colorEmpty {
			draw_sprite_ext(_emptySprite, 0, _targetX, _targetY, _xsize, _ysize, 0, _color, alpha);
		} else {
			draw_sprite_ext(_emptySprite, 0, _targetX, _targetY, _xsize, _ysize, 0, c_white, alpha);
		}
	}
	var _sprH = sprite_get_height(_fullSprite);
	var _sprW = sprite_get_width(_fullSprite);
	var _fillW = _sprW * _fillPercent;
	var _sprLeft = _sprW - _fillW;
	var _x_pos = _targetX - sprite_get_xoffset(_fullSprite) * _xsize;
	var _y_pos = _targetY - sprite_get_yoffset(_fullSprite) * _ysize;
	draw_sprite_part_ext(_fullSprite, 0, 0, 0, _fillW, _sprH, _x_pos, _y_pos, _xsize, _ysize, _color, _alpha);
}

/// @description						Draws a vertical progress bar that gradually replaces the empty sprite with the full sprite
/// @param {real} x						The x position to draw the progress bar
/// @param {real} y						The y position to draw the progress bar
/// @param {real} percentage			The percentage to show the progress bar (automatic clamp)
/// @param {Asset.GMSprite} emptysprite	The sprite to draw behind the progress bar that works as a background
/// @param {Asset.GMSprite} fullsprite	The sprite to draw as the progress bar that displays the percentage
/// @param {real} xscale				The horizontal scaling of both sprites (default 1)
/// @param {real} yscale				The vertical scaling of both sprites (default 1)
/// @param {Constant.Color}	color		The color to blend with the sprite (default c_white)
/// @param {bool} fadeout				Should the progress bar fade away from 100 to 120%
/// @param {bool} colorempty			Wether or not to apply the color to the empty sprite
function draw_vertical_progressbar(_targetX, _targetY, _percentage, _emptySprite, _fullSprite, _xsize, _ysize, _color, _fadeOut, _colorEmpty = true) {
	var _fillPercent = clamp(_percentage, 0, 1);
	var _alpha = 1
	if _fadeOut {
		_alpha =  1 - clamp((_fillPercent - 1) / 0.2, 0, 1);
		if _alpha == 1 {
			if _colorEmpty {
				draw_sprite_ext(_emptySprite, 0, _targetX, _targetY, _xsize, _ysize, 0, _color, _alpha);
			} else {
				draw_sprite_ext(_emptySprite, 0, _targetX, _targetY, _xsize, _ysize, 0, c_white, _alpha);
			}
		}
	} else {
		if _colorEmpty {
			draw_sprite_ext(_emptySprite, 0, _targetX, _targetY, _xsize, _ysize, 0, _color, 1);
		} else {
			draw_sprite_ext(_emptySprite, 0, _targetX, _targetY, _xsize, _ysize, 0, c_white, 1);
		}
	}
	var _sprH = sprite_get_height(_fullSprite);
	var _sprW = sprite_get_width(_fullSprite);
	var _fillH = _sprH * _fillPercent;
	var _sprTop = _sprH - _fillH;
	var _x_pos = _targetX - sprite_get_xoffset(_fullSprite) * _xsize;
	var _y_pos = _targetY - sprite_get_yoffset(_fullSprite) * _ysize;
	draw_sprite_part_ext(_fullSprite, 0, 0, _sprTop, _sprW, _fillH, _x_pos, _y_pos + (_sprTop * _ysize), _xsize, _ysize, _color, _alpha);
}

/// @description						Draws a horizontal progress bar that gradually replaces a grayed out version of the full sprite with the full sprite
/// @param {real} x						The x position to draw the progress bar
/// @param {real} y						The y position to draw the progress bar
/// @param {real} percentage			The percentage to show the progress bar (automatic clamp)
/// @param {Asset.GMSprite} fullsprite	The sprite to draw as the progress bar that displays the percentage
/// @param {real} xscale				The horizontal scaling of both sprites (default 1)
/// @param {real} yscale				The vertical scaling of both sprites (default 1)
/// @param {Constant.Color}	color		The color to blend with the sprite (default c_white)
/// @param {bool} fadeout				Should the progress bar fade away from 100 to 120%
function draw_horizontal_progressbar_single(_targetX, _targetY, _percentage, _fullSprite, _xsize, _ysize, _color, _fadeOut) {
	var _fillPercent = clamp(_percentage, 0, 1);
	var _alpha = 1
	if _fadeOut {
		_alpha =  1 - clamp((_fillPercent - 1) / 0.2, 0, 1);
		if _alpha == 1 {
			draw_sprite_ext(_fullSprite, 0, _targetX, _targetY, _xsize, _ysize, 0, c_gray, _alpha);
		}
	} else {
		draw_sprite_ext(_fullSprite, 0, _targetX, _targetY, _xsize, _ysize, 0, c_gray, 1);
	}
	var _sprH = sprite_get_height(_fullSprite);
	var _sprW = sprite_get_width(_fullSprite);
	var _fillW = _sprW * _fillPercent;
	var _sprLeft = _sprW - _fillW;
	var _x_pos = _targetX - sprite_get_xoffset(_fullSprite) * _xsize;
	var _y_pos = _targetY - sprite_get_yoffset(_fullSprite) * _ysize;
	draw_sprite_part_ext(_fullSprite, 0, 0, 0, _fillW, _sprH, _x_pos, _y_pos, _xsize, _ysize, _color, _alpha);
}

/// @description						Draws a vertical progress bar that gradually replaces the empty sprite with the full sprite
/// @param {real} x						The x position to draw the progress bar
/// @param {real} y						The y position to draw the progress bar
/// @param {real} percentage			The percentage to show the progress bar (automatic clamp)
/// @param {Asset.GMSprite} fullsprite	The sprite to draw as the progress bar that displays the percentage
/// @param {real} xscale				The horizontal scaling of both sprites (default 1)
/// @param {real} yscale				The vertical scaling of both sprites (default 1)
/// @param {Constant.Color}	color		The color to blend with the sprite (default c_white)
/// @param {bool} fadeout				Should the progress bar fade away from 100 to 120%
function draw_vertical_progressbar_single(_targetX, _targetY, _percentage, _fullSprite, _xsize, _ysize, _color, _fadeOut) {
	var _fillPercent = clamp(_percentage, 0, 1);
	var _alpha = 1
	if _fadeOut {
		_alpha =  1 - clamp((_fillPercent - 1) / 0.2, 0, 1);
		if _alpha == 1 {
			draw_sprite_ext(_fullSprite, 0, _targetX, _targetY, _xsize, _ysize, 0, c_gray, _alpha);
		}
	} else {
		draw_sprite_ext(_fullSprite, 0, _targetX, _targetY, _xsize, _ysize, 0, c_gray, 1);
	}
	var _sprH = sprite_get_height(_fullSprite);
	var _sprW = sprite_get_width(_fullSprite);
	var _fillH = _sprH * _fillPercent;
	var _sprTop = _sprH - _fillH;
	var _x_pos = _targetX - sprite_get_xoffset(_fullSprite) * _xsize;
	var _y_pos = _targetY - sprite_get_yoffset(_fullSprite) * _ysize;
	draw_sprite_part_ext(_fullSprite, 0, 0, _sprTop, _sprW, _fillH, _x_pos, _y_pos + (_sprTop * _ysize), _xsize, _ysize, _color, _alpha);
}

/// @desc Aims at a target trying to predict where it's going
/// @param {Id.Instance} target The target to aim at
/// @param {Read} prediction How many frames in the future should predict
/// @param {Read} direction The current direction of the aimer
function predictive_aim_at(_target, _leadFrames, _myDir) {
	if instance_exists(_target) {
		var _predX = _target.x + (_target.hspeed * _leadFrames);
		var _predY = _target.y + (_target.vspeed * _leadFrames);
		var _targetDir = point_direction(x, y, _predX, _predY);
		var _aDiff = angle_difference(_myDir, _targetDir);
		var _turnSpeed = max(abs(_aDiff) * 0.1, 3);
		if (abs(_aDiff) <= _turnSpeed) {
			return _targetDir;
		} else {
			return _myDir - sign(_aDiff) * _turnSpeed;
		}
	}

}

/// @desc My beloved lerp smoothly transitions between all colors using HSV
/// @param {Constant.Color} col1 The color to start from
/// @param {Constant.Color} col2 The color to end to
/// @param {Real} amount The amount to move by (0-1)
function lerp_color_HSV(colA, colB, amt) { // if you want to lerp colors by RGB use merge_color()
	var _h = color_get_hue(colA)
	var _s = color_get_saturation(colA)
	var _v = color_get_value(colA)

	var _th = color_get_hue(colB)
	var _ts = color_get_saturation(colB)
	var _tv = color_get_value(colB)

	_h = lerp(_h, _th, amt);
	_s = lerp(_s, _ts, amt);
	_v = lerp(_v, _tv, amt);

	return make_colour_hsv(_h, _s, _v);
}

/// @desc Deletes all apperances of a certain element in an array
/// @param {Array} array The target array
/// @param {Any} value The value
/// @return {Array}
function array_delete_value(_array, _value) {
	if array_contains(_array, _value) {
		for (var i = 0; i < array_length(_array); i++) {
			if _array[i] == _value {
				array_delete(_array, i, 1);
				i--;
			}
		}
	}
	return _array;
}

/// @desc Returns a random element from the provided array
/// @param {Array} array The target array to select an element from
function array_get_random(_array) {
	return _array[irandom(array_length(_array) - 1)];
}

/// @desc Returns a random element from a specific index range within the array
/// @param {Array} array The target array to select an element from
/// @param {Real} min The lowest index boundary to include
/// @param {Real} max The highest index boundary to include
function array_get_random_range(_array, _min, _max) {
	return _array[irandom_range(max(0, _min), min(_max, array_length(_array) - 1))];
}

/// @desc Returns the value of the specific point in an animcurve channel
/// @param {Asset.GMAnimCurve} curve_struct_or_id The ID or struct pointer of the animation curve to evaluate
/// @param {String} channel_name_or_index The channel name (string) or index (integer)
/// @param {Real} posx The position in time to check (0 to 1)
function animcurve_evaluate(_animcurve, _channel, _xpos) {
	return animcurve_channel_evaluate(animcurve_get_channel(_animcurve, _channel), _xpos);
}

/// @desc				Checks if sequence is over, then deletes it
/// @param sequence		The sequence
function sequence_tick_end(_sequence) {
	if (layer_sequence_is_finished(_sequence)) {
		layer_sequence_destroy(_sequence);
		return true;
	}
	return false;
}

/// @desc Checks if sequence is over, then deletes it and resets the tracking variable
/// @param {Id.SequenceElement} sequence_element_id The unique ID value of the sequence element to target
/// @param {String} variable_name The name of the instance variable to reset
function sequence_tick_end_tracking(_sequence, _var_name = "") {
	if (layer_sequence_is_finished(_sequence)) {
		layer_sequence_destroy(_sequence);
		if _var_name != "" {
			variable_instance_set(id, _var_name, -1);
		}
		return true;
	}
	return false;
}

/// @desc Checks if sequence exists considering edge cases too
/// @param {Id.Layer} layer The layer to check
/// @param {Id.SequenceElement} sequence_element_id The unique ID value of the sequence element to target
function layer_sequence_exists_safe(_layer, _sequence) {
	if _sequence != undefined and !is_real(_sequence) {
		return layer_sequence_exists(_layer, _sequence);
	}
	return false;
}


/// @desc This NEEDS to have a viewport with 10 px zoom-in from the room to work, put this in a controller's step event
function tick_screen_shake() {
	if global.paused {exit;}


	global.shake = min(global.shake, 5);
	var _cam = view_camera[0];
	var _cam_w = camera_get_view_width(_cam);
	var _cam_h = camera_get_view_height(_cam);

	var _target_x = room_width / 2;
	var _target_y = room_height / 2;

	var _view_x = _target_x - (_cam_w / 2);
	var _view_y = _target_y - (_cam_h / 2);

	if (global.shake > 0) {
		_view_x += random_range(-global.shake, global.shake);
		_view_y += random_range(-global.shake, global.shake);
		global.shake -= 0.2;
	} else {
		global.shake = 0; 
	}
	_view_x = clamp(_view_x, 0, room_width - _cam_w);
	_view_y = clamp(_view_y, 0, room_height - _cam_h);

	camera_set_view_pos(_cam, _view_x, _view_y);
}

/// @desc Shake the screen, only works if tick_screen_shake is in a step event
/// @param {Real} shake_intensity The intensity of the shake
function shake(_int) {
	global.shake += _int;
}

///@desc Draw self with a semi transparent white overlay
/// @param {Real} amount The alpha of the white overlay
function draw_self_brighter(_amount) {
	shader_set(shd_bright);
	var u_amount = shader_get_uniform(shd_bright, "amount");
	shader_set_uniform_f(u_amount, _amount);
	draw_self();
	shader_reset();
}

///@desc Enables a semi transparent white overlay on anything drawn, reset with shader_reset()
/// @param {Real} amount The alpha of the white overlay
function draw_set_brightness(_amount) {
	shader_set(shd_bright);
	var u_amount = shader_get_uniform(shd_bright, "amount");
	shader_set_uniform_f(u_amount, _amount);
}

/// @desc Scans a directory for .json files, parses them using json_into_array(), and puts the results to a provided array.
/// @param {String} directory The folder path to search in (starts from datafiles/) (cannot be empty, folder path IS needed).
/// @param {Array} target_array The array to push the loaded JSON data into.
function json_load_all_datafiles(_directory, _array) {
	if (string_char_at(_directory, string_length(_directory)) != "/") {
		_directory += "/";
	}
	
	var _file_name = file_find_first(_directory + "*.json", 0);
	
	while (_file_name != "") {
		var _full_path = _directory + _file_name;
		
		var _parsed_data = json_into_array(_full_path);
		
		array_push(_array, _parsed_data);
		
		_file_name = file_find_next();
	}
	
	file_find_close();
}

/// @desc Scans the external AppData save directory for .json files and appends them to the array.
/// @param {String} folder_name The folder inside AppData to search (cannot be empty, folder path IS needed).
/// @param {Array} target_array The array to push the loaded JSON data into.
function json_load_all_appdata(_folder_name, _array) {
	if (string_char_at(_folder_name, string_length(_folder_name)) != "/") {
		_folder_name += "/";
	}
	
	var _directory = game_save_id + _folder_name;
	
	if (!directory_exists(_directory)) {
		directory_create(_directory);
		return;
	}
	
	var _file_name = file_find_first(_directory + "*.json", 0);
	
	while (_file_name != "") {
		var _full_path = _directory + _file_name;
		
		var _parsed_data = json_into_array(_full_path);
		
		array_push(_array, _parsed_data);
		
		_file_name = file_find_next();
	}
	
	file_find_close();
}


/// @desc Sets up the global variables needed to implement a tilemap editor
/// @param {String} tile_map_layer_name The name of the existing tile map layer to edit
/// @param {Real} tile_pixel_size The width and height of the tile in pixels (32x32 -> 32)
/// @param {Asset.GMSprite} sprite The sprite sheet with all the tiles in it assigned to the tilemap
function setup_tilemap_editor(_tileMapLayerName, _tileMapPixelSize, _tilemapTileset, _tilemapSprite) {
	global.tileLayer = layer_get_id(_tileMapLayerName);
	global.tilemapID = layer_tilemap_get_id(global.tileLayer);
	global.tilemapPXSize = _tileMapPixelSize;
	global.tilemapSprite = _tilemapSprite;
	global.selectedTile = 1;
	tilemap_tileset(global.tilemapID, _tilemapTileset);
}

/// @desc When enabled is true, paints the current global.selectedTile to the position
/// @param {Bool} enabled Wether or not to draw in the current frame
/// @param {Bool} erase Wether or not to draw or erase
function tick_tile_editor_drawing(_enabled, _erase) {
	if _enabled {
		var _clickX = floor((mouse_x + global.dynamicCamX) / global.tilemapPXSize);
		var _clickY = floor((mouse_y + global.dynamicCamY) / global.tilemapPXSize);
		if !_erase {
			tilemap_set(global.tilemapID, global.selectedTile, _clickX, _clickY);
		} else {
			tilemap_set(global.tilemapID, 0, _clickX, _clickY);
		}
	}
}

/// @desc Draws a semi transparent preview of the tile about to be drawn at the mouse position
/// @param {Bool} enabled Wether or not to show the preview
function draw_editor_preview(_enabled) {
	if !_enabled {exit}

	var _sheetColumns = floor(sprite_get_width(global.tilemapSprite) / global.tilemapPXSize);

	var _clickX = floor((mouse_x + global.dynamicCamX) / global.tilemapPXSize);
	var _clickY = floor((mouse_y + global.dynamicCamY) / global.tilemapPXSize);
	
	var _drawX = _clickX * global.tilemapPXSize;
	var _drawY = _clickY * global.tilemapPXSize;

	var _sheetX = (global.selectedTile mod _sheetColumns) * global.tilemapPXSize;
	var _sheetY = (global.selectedTile div _sheetColumns) * global.tilemapPXSize;

	draw_sprite_part_ext(global.tilemapSprite, 0, _sheetX, _sheetY, global.tilemapPXSize, global.tilemapPXSize, _drawX, _drawY, 1, 1, c_white, 0.5);
}


/// @desc Draws a certain tile at a position, snapping it to the grid
/// @param {Real} x The x coordinate
/// @param {Real} y The y coordinate
/// @param {Real} tile The tile to place
function draw_tile(_x, _y, _tile) {
	var _sheetColumns = floor(sprite_get_width(global.tilemapSprite) / global.tilemapPXSize);

	var _clickX = floor((_x + global.dynamicCamX) / global.tilemapPXSize);
	var _clickY = floor((_y + global.dynamicCamY) / global.tilemapPXSize);
	
	var _drawX = _clickX * global.tilemapPXSize;
	var _drawY = _clickY * global.tilemapPXSize;

	var _sheetX = (global.selectedTile mod _sheetColumns) * global.tilemapPXSize;
	var _sheetY = (global.selectedTile div _sheetColumns) * global.tilemapPXSize;

	draw_sprite_part_ext(global.tilemapSprite, 0, _sheetX, _sheetY, global.tilemapPXSize, global.tilemapPXSize, _drawX, _drawY, 1, 1, c_white, 1);
}

/// @desc Draws a fixed focus tile palette on the GUI layer. The selected tile remains stationary at the provided x/y coordinates while the sprite sheet slides behind it.
/// @param {Real} _x The X coordinate on the GUI layer to center the selected tile on.
/// @param {Real} _y The Y coordinate on the GUI layer to center the selected tile on.
/// @param {Real} _tile The current index of the selected tile.
/// @param {Real} _alpha The opacity of the drawn palette.
/// @param {Real} _xscale The horizontal scaling multiplier for the palette and cursor.
/// @param {Real} _yscale The vertical scaling multiplier for the palette and cursor.
function draw_GUI_tilemap_selection(_x, _y, _tile, _alpha, _xscale, _yscale) {
	_tile++;
	
	var _sheetColumns = floor(sprite_get_width(global.tilemapSprite) / global.tilemapPXSize);
	
	var _scaledTileWidth = global.tilemapPXSize * _xscale;
	var _scaledTileHeight = global.tilemapPXSize * _yscale;
	
	var _cursorX = _x - (_scaledTileWidth / 2);
	var _cursorY = _y - (_scaledTileHeight / 2);
	
	var _tileOffsetX = ((_tile - 1) mod _sheetColumns) * _scaledTileWidth;
	var _tileOffsetY = ((_tile - 1) div _sheetColumns) * _scaledTileHeight;
	
	var _drawX = _cursorX - _tileOffsetX;
	var _drawY = _cursorY - _tileOffsetY;
	
	var _sheetW = sprite_get_width(global.tilemapSprite) * _xscale;
	var _sheetH = sprite_get_height(global.tilemapSprite) * _yscale;
	
	draw_sprite_ext(global.tilemapSprite, 0, _drawX, _drawY, _xscale, _yscale, 0, c_white, _alpha);
	
	var _prevAlpha = draw_get_alpha();
	draw_set_alpha(1.0);
	
	draw_rectangle_color(_drawX - 1, _drawY - 1, _drawX + _sheetW, _drawY + _sheetH, c_lime, c_lime, c_lime, c_lime, true);
	draw_rectangle_color(_drawX - 2, _drawY - 2, _drawX + _sheetW + 1, _drawY + _sheetH + 1, c_lime, c_lime, c_lime, c_lime, true);
	
	if global.tick % 60 <= 30 {
		draw_rectangle_color(_cursorX, _cursorY, _cursorX + _scaledTileWidth - 1, _cursorY + _scaledTileHeight - 1, c_yellow, c_yellow, c_yellow, c_yellow, true);
		draw_rectangle_color(_cursorX + 1, _cursorY + 1, _cursorX + _scaledTileWidth - 2, _cursorY + _scaledTileHeight - 2, c_yellow, c_yellow, c_yellow, c_yellow, true);
	} else {
		draw_rectangle_color(_cursorX, _cursorY, _cursorX + _scaledTileWidth - 1, _cursorY + _scaledTileHeight - 1, c_red, c_red, c_red, c_red, true);
		draw_rectangle_color(_cursorX + 1, _cursorY + 1, _cursorX + _scaledTileWidth - 2, _cursorY + _scaledTileHeight - 2, c_red, c_red, c_red, c_red, true);
	}
	draw_set_alpha(_prevAlpha);
}

/// @desc Cycles to the tile after n skips
/// @param {Real} step The skips to perform, can be negative to move backwards
function cycle_selected_tile(_step) {
	var _maxTiles = (sprite_get_width(global.tilemapSprite) div global.tilemapPXSize) * (sprite_get_height(global.tilemapSprite) div global.tilemapPXSize);
	var _paintableTiles = _maxTiles - 1;
	var _currentIndex = global.selectedTile - 1;
	var _newIndex = (_currentIndex + _step) mod _paintableTiles;
	
	if (_newIndex < 0) {
		_newIndex += _paintableTiles;
	}
	
	global.selectedTile = _newIndex + 1;
}

/// @desc Returns the tile at x and y
/// @param {Real} x The x coordinate of the place where to check
/// @param {Real} y The y coordinate of the place where to check
function pick_tile(_x, _y) {
	var _clickX = floor((_x + global.dynamicCamX) / global.tilemapPXSize);
	var _clickY = floor((_y + global.dynamicCamY) / global.tilemapPXSize);
	
	return tilemap_get(global.tilemapID, _clickX, _clickY);
}

/// @desc initializes the global variables to allow for dynamic camera controls. Needs a viewport to be enabled!
/// @param {Real} cam_xscale The initial pixel width of the camera
/// @param {Real} cam_yscale The initial pixel height of the camera
function setup_dynamic_camera(_camScaleX, _camScaleY) {
	global.dynamicCamera = true;
	global.dynamicCamSize = 1;
	global.dynamicCamX = 0;
	global.dynamicCamY = 0;
	global.dynamicCamXscale = _camScaleX;
	global.dynamicCamYscale = _camScaleY;
}

/// @desc Ticks the dynamic camera, needs a viewport and setupDynamicCamera().
/// @param {Array<id.Camera>} _viewport The id of the camera to control
function tick_dynamic_camera(_viewport) {
	var _cam_width = (global.dynamicCamXscale * global.dynamicCamSize);
	var _cam_height = (global.dynamicCamYscale * global.dynamicCamSize);
	
	camera_set_view_size(_viewport, _cam_width, _cam_height);
	camera_set_view_pos(_viewport, (global.dynamicCamX), (global.dynamicCamY));
}

/// @desc Zooms the dynamic camera out, needs setupDynamicCamera() and tickDynamicCamera().
/// @param {Real} value The value to add to the current zoom ratio
function dynamic_camera_zoom_add(_value) {
	global.dynamicCamSize = max(global.dynamicCamSize + _value, 0.1);
}

/// @desc Zooms the dynamic camera, needs setupDynamicCamera() and tickDynamicCamera().
/// @param {Real} value The value to set the current zoom ratio
function dynamic_camera_zoom_set(_value) {
	global.dynamicCamSize = max(_value, 0.1);
}


/// @desc Looks into a rectangular matrix array and returns the value at the coordinates if out of bounds, returns fallback.
/// @param {Array<Array>} array The rectangular array
/// @param {Real} x The x coordinate inside the array
/// @param {Real} y The y coordinate inside the array
/// @param {Any} fallback The fallback value in case the check fails
function array_check_2D(_array, _x, _y, _fallback) {
	if _x < 0 or _x >= array_length(_array) or _y < 0 or _y >= array_length(_array[0]) {return _fallback}
	return _array[_x][_y];
}

/// @desc Finds a path to the target using A* and returns the coordinates (as an array [x,y]) of the adjacent tile to reach it.
/// @param {Array<Array>} _array The square array matrix
/// @param {Real} _arrayX The x array coordinate of the starting point
/// @param {Real} _arrayY The y array coordinate of the starting point
/// @param {Real} _endArrayX The x array coordinate of the ending point
/// @param {Real} _endArrayY The y array coordinate of the ending point
/// @param {Real} _wallValue The integer that represents an unpassable wall (e.g., 20)
function pathfind_astar(_array, _arrayX, _arrayY, _endArrayX, _endArrayY, _wallValue) {
	// NOT MY CODE I FOUND IT SOMEWHERE
	if (_arrayX == _endArrayX and _arrayY == _endArrayY) { return undefined; }
	if (array_check_2D(_array, _endArrayX, _endArrayY, _wallValue) == _wallValue) { return undefined; }
	var _openList = ds_priority_create();
	var _nodeMap = array_create(array_length(_array));
	for (var _i = 0; _i < array_length(_array); _i++) {
		_nodeMap[_i] = array_create(array_length(_array[0]), 0);
	}
	_nodeMap[_arrayX][_arrayY] = { g: 0, parent: undefined, closed: false };
	ds_priority_add(_openList, [_arrayX, _arrayY], 0);
	var _pathFound = false;
	while (!ds_priority_empty(_openList)) {
		var _current = ds_priority_delete_min(_openList);
		var _cx = _current[0];
		var _cy = _current[1];
		
		if (_cx == _endArrayX and _cy == _endArrayY) {
			_pathFound = true;
			break;
		}
		_nodeMap[_cx][_cy].closed = true;
		var _dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
		for (var _i = 0; _i < 4; _i++) {
			var _nx = _cx + _dirs[_i][0];
			var _ny = _cy + _dirs[_i][1];
			if (array_check_2D(_array, _nx, _ny, _wallValue) == _wallValue) { continue; }
			if (_nodeMap[_nx][_ny] == 0) {
				_nodeMap[_nx][_ny] = { g: 999999, parent: undefined, closed: false };
			}
			if (_nodeMap[_nx][_ny].closed) { continue; }
			var _newG = _nodeMap[_cx][_cy].g + 1;
			if (_newG < _nodeMap[_nx][_ny].g) {
				_nodeMap[_nx][_ny].g = _newG;
				_nodeMap[_nx][_ny].parent = [_cx, _cy];
				var _h = abs(_endArrayX - _nx) + abs(_endArrayY - _ny);
				var _f = _newG + _h;
				ds_priority_add(_openList, [_nx, _ny], _f);
			}
		}
	}
	var _result = undefined;
	if (_pathFound) {
		var _traceX = _endArrayX;
		var _traceY = _endArrayY;
		var _finalPath = [];
		
		while (_traceX != _arrayX or _traceY != _arrayY) {
			array_push(_finalPath, [_traceX, _traceY]);
			var _p = _nodeMap[_traceX][_traceY].parent;
			_traceX = _p[0];
			_traceY = _p[1];
		}
		_result = array_pop(_finalPath);
	}
	ds_priority_destroy(_openList);
	return _result;
}

/// @desc Casts a ray across the grid to check if line of sight is clear. Returns true if clear, false if blocked.
/// @param {Array<Array>} _array The array matrix representing the grid
/// @param {Real} _x0 The x array coordinate of the starting point
/// @param {Real} _y0 The y array coordinate of the starting point
/// @param {Real} _x1 The x array coordinate of the target point
/// @param {Real} _y1 The y array coordinate of the target point
/// @param {Real} _wallValue The integer that represents an unpassable wall (e.g., 20)
function array_line_of_sight(_array, _x0, _y0, _x1, _y1, _wallValue) {
	var _dx = abs(_x1 - _x0);
	var _sx = (_x0 < _x1) ? 1 : -1;
	var _dy = -abs(_y1 - _y0);
	var _sy = (_y0 < _y1) ? 1 : -1;
	var _err = _dx + _dy;
	while (true) {
		if (array_check_2D(_array, _x0, _y0, _wallValue) == _wallValue) {
			return false;
		}
		if (_x0 == _x1 and _y0 == _y1) {
			break;
		}
		var _e2 = 2 * _err;
		if (_e2 >= _dy) { _err += _dy; _x0 += _sx; }
		if (_e2 <= _dx) { _err += _dx; _y0 += _sy; }
	}
	
	return true;
}

/// @desc Finds a path using A*, applies raycast smoothing, and returns the FURTHEST visible [x,y] coordinate.
/// @param {Array<Array>} _array The square array matrix
/// @param {Real} _arrayX The x array coordinate of the starting point
/// @param {Real} _arrayY The y array coordinate of the starting point
/// @param {Real} _endArrayX The x array coordinate of the ending point
/// @param {Real} _endArrayY The y array coordinate of the ending point
/// @param {Real} _wallValue The integer that represents an unpassable wall
function pathfind_astar_ext(_array, _arrayX, _arrayY, _endArrayX, _endArrayY, _wallValue) {
	// SAME AS THE ONE BEFORE
	if (_arrayX == _endArrayX and _arrayY == _endArrayY) { return undefined; }
	if (array_check_2D(_array, _endArrayX, _endArrayY, _wallValue) == _wallValue) { return undefined; }
	var _openList = ds_priority_create();
	var _nodeMap = array_create(array_length(_array));
	for (var _i = 0; _i < array_length(_array); _i++) {
		_nodeMap[_i] = array_create(array_length(_array[0]), 0);
	}
	_nodeMap[_arrayX][_arrayY] = { g: 0, parent: undefined, closed: false };
	ds_priority_add(_openList, [_arrayX, _arrayY], 0);
	var _pathFound = false;
	while (!ds_priority_empty(_openList)) {
		var _current = ds_priority_delete_min(_openList);
		var _cx = _current[0];
		var _cy = _current[1];
		if (_cx == _endArrayX and _cy == _endArrayY) {
			_pathFound = true;
			break;
		}
		_nodeMap[_cx][_cy].closed = true;
		var _dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
		for (var _i = 0; _i < 4; _i++) {
			var _nx = _cx + _dirs[_i][0];
			var _ny = _cy + _dirs[_i][1];
			if (array_check_2D(_array, _nx, _ny, _wallValue) == _wallValue) { continue; }
			if (_nodeMap[_nx][_ny] == 0) {
				_nodeMap[_nx][_ny] = { g: 999999, parent: undefined, closed: false };
			}
			if (_nodeMap[_nx][_ny].closed) { continue; }
			var _newG = _nodeMap[_cx][_cy].g + 1;
			if (_newG < _nodeMap[_nx][_ny].g) {
				_nodeMap[_nx][_ny].g = _newG;
				_nodeMap[_nx][_ny].parent = [_cx, _cy];
				var _h = abs(_endArrayX - _nx) + abs(_endArrayY - _ny);
				var _f = _newG + _h;
				ds_priority_add(_openList, [_nx, _ny], _f);
			}
		}
	}
	var _result = undefined;
	if (_pathFound) {
		var _traceX = _endArrayX;
		var _traceY = _endArrayY;
		var _finalPath = [];
		while (_traceX != _arrayX or _traceY != _arrayY) {
			array_push(_finalPath, [_traceX, _traceY]);
			var _p = _nodeMap[_traceX][_traceY].parent;
			_traceX = _p[0];
			_traceY = _p[1];
		}
		for (var _i = 0; _i < array_length(_finalPath); _i++) {
			var _targetNodeX = _finalPath[_i][0];
			var _targetNodeY = _finalPath[_i][1];
			if (array_line_of_sight(_array, _arrayX, _arrayY, _targetNodeX, _targetNodeY, _wallValue)) {
				_result = [_targetNodeX, _targetNodeY];
				break; 
			}
		}
	}
	ds_priority_destroy(_openList);
	return _result;
}

/// @desc Calculates the animation frame for a sprite.
/// @param {Asset.GMSprite} sprite The sprite asset to calculate the frame for.
/// @param {Real} tick_variable The variable that ticks the animation
function sprite_get_frame(_sprite, _current_tick) {
	return floor(_current_tick * (sprite_get_speed(_sprite) / game_get_speed(gamespeed_fps))) mod sprite_get_number(_sprite);
}

/// @desc Snaps a direction to the given degree angles
/// @param {Real} direction The direction to snap
/// @param {Real} snap_degrees The degrees to snap the direction (use 90 for cardinal coords)
function snap_direction(_dir, _snap_degrees) {
	return round(_dir / _snap_degrees) * _snap_degrees;
}

/// @desc Smoothly rotates an angle towards a target angle by a maximum step.
/// @param {real} _current_angle The starting angle
/// @param {real} _target_angle The angle to rotate towards
/// @param {real} _turn_speed The maximum degrees to turn this frame
function turn_direction(_current_angle, _target_angle, _turn_speed) {
	return _current_angle + clamp(angle_difference(_target_angle, _current_angle), -_turn_speed, _turn_speed);
}

/// @desc Lerps between two angles via the shortest path.
/// @param {real} _current_angle The starting angle
/// @param {real} _target_angle The angle to lerp towards
/// @param {real} _amount The interpolation amount (0 to 1)
function angle_lerp(_current_angle, _target_angle, _amount) {
	return _current_angle + (angle_difference(_target_angle, _current_angle) * _amount);
}

/// @desc Takes an array or struct and saves it into a named json file
/// @param {String} path The path with the name of the file to save
/// @param {Any} struct_or_array The structure to save in the file
function save_into_json(_path, _element) {
	var _file = file_text_open_write(_path);
	file_text_write_string(_file, json_stringify(_element, true));
	file_text_close(_file);
}

/// @desc Takes a value, and returns that value's index argument
/// @param {Real} index The index to return
/// @param {Any} values The values to insert
 function multiplexer() { // i love this function, it's my favourite
	if (real(argument[0]) + 1 < argument_count) {
		return argument[real(argument[0]) + 1];
	}
	return undefined;
}

/// @desc Returns the mouse_y reduced by room height, useful for debugging
/// @param {Bool} ignore Wether to ignore the room_height or not
function mouse_y_diff(_ignore_mid = false) { // these two are a close second
	show_debug_message("Y: " + string(mouse_y - (room_height / 2) * (1 - _ignore_mid)));
	return mouse_y - (room_height / 2) * (1 - _ignore_mid);
}

/// @desc Returns the mouse_x reduced by room width, useful for debugging
/// @param {Bool} ignore Wether to ignore the room_width or not
function mouse_x_diff(_ignore_mid = false) {
	show_debug_message("X: " + string(mouse_x - (room_width / 2) * (1 - _ignore_mid)));
	return mouse_x - (room_width / 2) * (1 - _ignore_mid);
}

/// @desc Converts raw seconds into a formatted time string (ex: "1h 5m 30s").
/// @param {real} total_seconds The total amount of seconds to convert.
/// @param {bool} extend If true, forces the display of hours and minutes even if they are 0.
function seconds_to_time(_total_seconds, _extend = false) {
	var _h = _total_seconds div 3600;
	var _m = (_total_seconds div 60) mod 60;
	var _result = "";
	if (_h > 0 or _extend) {
		_result += string(_h) + "h ";
	}
	if (_m > 0 or _h > 0 or _extend) {
		_result += string(_m) + "m ";
	}
	_result += string(_total_seconds mod 60) + "s";
	return _result;
}

/// @desc Doesn't allow the given value to go betweem the two other given values (excluded)
/// @param {Real} number The value to reverse clamp
/// @param {Real} smaller_limit The start of the forbinned zone
/// @param {Real} bigger_limit The end of the forbidden zone
function reverse_clamp(_num, _min, _max) {
	var _mid = (_min + _max) / 2;
	if _num >= _mid and _num <= _max {
		return _max;
	} else if _num <= _mid and _num >= _min {
		return _min;
	} else {
		return _num;
	}
}

/// @desc						Similar to string_copy, but takes from-to positions instead of start and length
/// @param {String} string		The string to check
/// @param {Real} start_index	The starting index to start the copy
/// @param {Real} end_index		The finishing index to end the copy
//FUCK YOU STRING_COPY I WILL NOT BOW TO YOUR BULLSHIT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function string_copy_alt(_str, index_1, index_2) {
	if index_1 < index_2 {
		return string_copy(_str, index_1, index_2 - index_1);
	}
	return "";
}

/// @desc					Checks if the mouse cursor is inside a rectangle determined by the top left corner pos (x1, y1) and the bottom right corner (x2, y2)
/// @param {Real} x1		The x coord of the top left corner
/// @param {Real} y1		The y coord of the top left corner
/// @param {Real} x2		The x coord of the bottom right corner
/// @param {Real} y2		The y coord of the bottom right corner
/// @param {Bool} debug		Wether or not to draw a red rectangle around the check area, works only inside draw events
function mouse_in_rectangle(_x1, _y1, _x2, _y2, _debug = false) {
	if _debug {draw_rectangle_colour(_x1, _y1, _x2, _y2, c_red, c_red, c_red, c_red, true)}
	return point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2);
}

/// @desc					Wrapper function for show_debug_message()
/// @param {Any} output		The value to pass
function print(_msg) {
	show_debug_message(_msg);
}

/// @desc						Checks if a substring is inside a given string
/// @param {String} substr		The string to look for
/// @param {String} str			The string cheked
function string_contains(_substr, _str) {
	return string_pos(_substr, _str) != 0;
}

/// @desc	Returns the string position AFTER the found substring, returns the first position if subrstring is not present
/// @param {String} substr		The string to look for
/// @param {String} str			The string cheked
function string_pos_alt(_substr, _str) {
	var _pos = string_pos(_substr, _str);
	if _pos == 0 {
		return 0;
	} else {
		return _pos + string_length(_substr);
	}
}

/// @desc							Wrapper function for color_get_hue()
/// @param {Constant.Color} col		The color to check
function color_h(_col) {
	return color_get_hue(_col)
}

/// @desc							Wrapper function for color_get_saturation()
/// @param {Constant.Color} col		The color to check
function color_s(_col) {
	return color_get_saturation(_col)
}

/// @desc							Wrapper function for color_get_value()
/// @param {Constant.Color} col		The color to check
function color_v(_col) {
	return color_get_value(_col)
}

/// @desc							Wrapper function for color_get_red()
/// @param {Constant.Color} col		The color to check
function color_r(_col) {
	return color_get_red(_col)
}

/// @desc							Wrapper function for color_get_green()
/// @param {Constant.Color} col		The color to check
function color_g(_col) {
	return color_get_green(_col)
}

/// @desc							Wrapper function for color_get_blue()
/// @param {Constant.Color} col		The color to check
function color_b(_col) {
	return color_get_blue(_col)
}