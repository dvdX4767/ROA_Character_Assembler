focus = 0;
tab = noone;
tabs = [];
global.scroll_y = 0;
tab_view = 0;
tab_view_speed = 0;
hovered_x = -1;

surf_scripts = surface_create(300, 690);
surf_tabs = surface_create(986, 70);

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
	scripts_size[@0] = max(scripts_size[0], string_width(_name));
	array_push(script_pickers, {
		name : _name,
		width : string_width(_name),
		fullpath : _path,
		full_string : "|  " + _name,
		attack: false
	});
	_i++;
}
_i = 0;
_scrps = archive_fetch(AP.ATTACKS);
repeat array_length(_scrps){
	var _path = _scrps[_i].path;
	var _split = string_split(_path, "/");
	var _name = _split[array_length(_split)-1];
	scripts_size[@0] = max(scripts_size[0], string_width(_name));
	array_push(attack_pickers, {
		name : _name,
		width : string_width(_name),
		fullpath : _path,
		full_string : "|| " + _name,
		attack: true
	});
	_i++;
}

/*
script = {
	name: "",
	width: 0,
	fullpath: "",
	full_string: "",
	attack: bool
}
*/