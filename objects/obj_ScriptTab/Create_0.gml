name = "";
filepath = "";
filestruct = noone;
attack = false;

data = [];
data_statements = []; //thick yellow
data_functions = []; //orange
data_const = []; //red
data_default = []; //lime
data_temp_var = []; //thin yellow
data_hash = []; //dark purple
//data_strings = []; //yellow
data_comment = []; //green
//data_numbers = []; //red

parse_localvars = [];
parse_localconst = [];
parse_localfuncs = [];

parse_timer = -1;
parse_timer_elapsed = 120;

parsed = 0;

edited = 0;
textview = [0, 0];
textscroll_speed = [0, 0];
parsetabs = 1;
txtwidt = 0;

last_cursor = noone;
cursors = [];
showcursors = 0;
cursor_hold_pause = 20;
cursor_hold_delay = 1;

direction_buffer = array_create(7, 5);

main_obj = noone;

/*
cursor = {
	line: int,
	pos: int,
	qolpos: int,
	selection: int
}
*/

text_surf = surface_create(1052, 703)

all_buffers = [];
all_container = ["data", "cursors", "data_statements", "data_functions", "data_const", "data_default", "data_temp_var", "data_hash", "data_comment"];
highlight_banks = ["data_statements", "data_functions", "data_const", "data_default", "data_temp_var", "data_hash", "data_comment"];
changes_buffer_max = 256;
undos = 0;
ctrl_cd_max = 20;
ctrl_cooldown = array_create(10, ctrl_cd_max);