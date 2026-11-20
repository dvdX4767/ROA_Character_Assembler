focus = "nothing";
focus_secondary = "";
page = 1;

global.stats_modified = false;

values = [
	"char_height",
	"knockback_adj",
	"walk_speed",
	"walk_accel",
	"walk_turn_time",
	"initial_dash_time",
	"initial_dash_speed",
	"dash_speed",
	"dash_turn_time",
	"dash_turn_accel",
	"dash_stop_time",
	"dash_stop_percent",
	"ground_friction",
	"moonwalk_accel",
	"leave_ground_max",
	"max_jump_hsp",
	"air_max_speed",
	"jump_change",
	"air_accel",
	"prat_fall_accel",
	"air_friction",
	"max_fall",
	"fast_fall",
	"gravity_speed",
	"hitstun_grav",
	"jump_start_time",
	"jump_speed",
	"short_hop_speed",
	"djump_speed",
	"djump_accel",
	"djump_accel_start_time",
	"djump_accel_end_time",
	"max_djumps",
	"walljump_hsp",
	"walljump_vsp",
	"land_time",
	"prat_land_time",
	"wave_friction",
	"roll_forward_max",
	"roll_backward_max",
	"wave_land_time",
	"wave_land_adj",
	"air_dodge_speed",
	"techroll_speed",
	"idle_anim_speed",
	"crouch_anim_speed",
	"walk_anim_speed",
	"dash_anim_speed",
	"pratfall_anim_speed",
	"double_jump_time",
	"walljump_time",
	"wall_frames",
	"dodge_startup_frames",
	"dodge_active_frames",
	"dodge_recovery_frames",
	"tech_active_frames",
	"tech_recovery_frames",
	"techroll_startup_frames",
	"techroll_active_frames",
	"techroll_recovery_frames",
	"air_dodge_startup_frames",
	"air_dodge_active_frames",
	"air_dodge_recovery_frames",
	"roll_forward_startup_frames",
	"roll_forward_active_frames",
	"roll_forward_recovery_frames",
	"roll_back_startup_frames",
	"roll_back_active_frames",
	"roll_back_recovery_frames",
	"crouch_startup_frames",
	"crouch_active_frames",
	"crouch_recovery_frames",
	"bubble_x",
	"bubble_y"
];
defaults = [
	52,
	1,
	3.25,
	0.20,
	6,
	14,
	7,
	6.50,
	10,
	1.50,
	4,
	0.35,
	0.50,
	1.30,
	6,
	6,
	4,
	3,
	0.30,
	0.85,
	0.04,
	10,
	14,
	0.50,
	0.50,
	5,
	11,
	6,
	10,
	0,
	0,
	0,
	1,
	7,
	8,
	4,
	10,
	0.12,
	9,
	9,
	8,
	1.30,
	7.50,
	10,
	0.10,
	0.10,
	0.12,
	0.20,
	0.25,
	32,
	32,
	2,
	1,
	1,
	4,
	3,
	1,
	1,
	4,
	2,
	1,
	4,
	2,
	1,
	4,
	2,
	1,
	4,
	2,
	2,
	8,
	2,
	0,
	8
];
allstats = {};

array_foreach(values, function(_v, _i) {
	struct_set(allstats, _v, fetch_values(_v, _i));
})

function fetch_values(_value, _arrpos) {
	var _pos = archive_fetch_gml_string_startswith(AP.SCRIPTS, get_full_path("scripts/init.gml"), string("{0}=", _value), false);
	if _pos == -2 {
		show_message("Error: Could not find init.gml or read from it.");
		return undefined;
	} else if _pos == -1 {
		return defaults[_arrpos];
	} else {
		var _file = archive_fetch_file(AP.SCRIPTS, get_full_path("scripts/init.gml"));
		var _line = string_unformat(_file[_pos]);
		var _p1 = string_length(string("{0}=", _value)) + 1;
		var _p2 = string_pos(";", _line);
		if _p2 == 0 {_p2 = string_length(_line)}
		try {
			var _v = string_copy_alt(_line, _p1, _p2);
			return real(_v);
		} catch (_err) {
			show_debug_message(_err);
			return defaults[_arrpos];
		}
	}
}

function render_stat_pages() {
	layer_set_visible(layer_get_id("FrameMoves"), false);
	layer_set_visible(layer_get_id("Animations"), false);
	layer_set_visible(layer_get_id("Movement"), false);
	layer_set_visible(layer_get_id("Misc"), false);
	// json file? what's that?	
	layer_set_visible(layer_get_id(multiplexer(page - 1, "FrameMoves", "Animations", "Movement", "Misc")), true);
	if page == 1 {
		description_box("FrameMoves", "graphic_25F95898", "WALL FRAMES\n\nThe number of animation frames to play before you leave the wall");
		if is_focused("nothing") { // wall frames
			rename_int_button("FrameMoves", "graphic_24096777", "text_68532B96", allstats, "wall_frames", "wall_frames");
		}
		
		description_box("FrameMoves", "graphic_FB2DCAC", "DODGE FRAMES\n\nNumber of animation frames during parry's \n[STARTUP, ACTIVE, RECOVERY] frames");
		if is_focused("nothing") { // dodge frames
			rename_int_button("FrameMoves", "graphic_569C2D70", "text_4A9F833D", allstats, "dodge_startup_frames", "dodge_startup_frames");
			rename_int_button("FrameMoves", "graphic_2CB922D1", "text_51D9FBF9", allstats, "dodge_active_frames", "dodge_active_frames");
			rename_int_button("FrameMoves", "graphic_70134B5C", "text_71CF6331", allstats, "dodge_recovery_frames", "dodge_recovery_frames");
		}
		
		description_box("FrameMoves", "graphic_24EE0CB", "TECH FRAMES\n\nThe number of animation frames during tech's \n[ACTIVE, RECOVERY] period");
		if is_focused("nothing") { // tech frames
			rename_int_button("FrameMoves", "graphic_77DF9592", "text_412965C5", allstats, "tech_active_frames", "tech_active_frames");
			rename_int_button("FrameMoves", "graphic_2D7484D0", "text_7F6BE125", allstats, "tech_recovery_frames", "tech_recovery_frames");
		}
		
		description_box("FrameMoves", "graphic_58F9025", "TECHROLL FRAMES\n\nThe number of animation frames during techroll's \n[STARTUP, ACTIVE, RECOVERY] period");
		if is_focused("nothing") { // techroll frames
			rename_int_button("FrameMoves", "graphic_C653C6A", "text_78495127", allstats, "techroll_startup_frames", "techroll_startup_frames");
			rename_int_button("FrameMoves", "graphic_4AFAA99", "text_51E834A5", allstats, "techroll_active_frames", "techroll_active_frames");
			rename_int_button("FrameMoves", "graphic_57D42483", "text_6748F1E8", allstats, "techroll_recovery_frames", "techroll_recovery_frames");
		}
		
		description_box("FrameMoves", "graphic_638559AC", "AIRDODGE FRAMES\n\nThe number of animation frames during airdogde's \n[STARTUP, ACTIVE, RECOVERY] period");
		if is_focused("nothing") { // airdodge frames
			rename_int_button("FrameMoves", "graphic_5FEC18DB", "text_8AAFA32", allstats, "air_dodge_startup_frames", "air_dodge_startup_frames");
			rename_int_button("FrameMoves", "graphic_73C41F90", "text_12B3DA47", allstats, "air_dodge_active_frames", "air_dodge_active_frames");
			rename_int_button("FrameMoves", "graphic_74306762", "text_55B7B085", allstats, "air_dodge_recovery_frames", "air_dodge_recovery_frames");
		}
		
		description_box("FrameMoves", "graphic_1F377BF5", "ROLL FORWARDS FRAMES\n\nThe number of animation frames during forwards roll's \n[STARTUP, ACTIVE, RECOVERY] period");
		if is_focused("nothing") { // roll fwd frames
			rename_int_button("FrameMoves", "graphic_7C3F0D9A", "text_22C008A8", allstats, "roll_forward_startup_frames", "roll_forward_startup_frames");
			rename_int_button("FrameMoves", "graphic_C179B51", "text_DEB2F41", allstats, "roll_forward_active_frames", "roll_forward_active_frames");
			rename_int_button("FrameMoves", "graphic_7F7E6FBC", "text_18B5C44F", allstats, "roll_forward_recovery_frames", "roll_forward_recovery_frames");
		}
		
		description_box("FrameMoves", "graphic_144451B1", "ROLL BACKWARDS FRAMES\n\nThe number of animation frames during backwards roll's \n[STARTUP, ACTIVE, RECOVERY] period");
		if is_focused("nothing") { // roll bwd frames
			rename_int_button("FrameMoves", "graphic_71026441", "text_206BC633", allstats, "roll_back_startup_frames", "roll_back_startup_frames");
			rename_int_button("FrameMoves", "graphic_55127B0", "text_6298F742", allstats, "roll_back_active_frames", "roll_back_active_frames");
			rename_int_button("FrameMoves", "graphic_6EA588DB", "text_6F4B7D0D", allstats, "roll_back_recovery_frames", "roll_back_recovery_frames");
		}
		
		description_box("FrameMoves", "graphic_5482B5F6", "CROUCH FRAMES\n\nThe number of animation frames during crouch's \n[STARTUP, ACTIVE, RECOVERY] period");
		if is_focused("nothing") { // crouch frames
			rename_int_button("FrameMoves", "graphic_2233C20A", "text_11D14FA5", allstats, "crouch_startup_frames", "crouch_startup_frames");
			rename_int_button("FrameMoves", "graphic_24628264", "text_2589B1F7", allstats, "crouch_active_frames", "crouch_active_frames");
			rename_int_button("FrameMoves", "graphic_41A020C", "text_6CC2BB56", allstats, "crouch_recovery_frames", "crouch_recovery_frames");
		}
		
	} else if page == 2 {
		
		description_box("Animations", "graphic_7051EEBF", "INITIAL DASH\n\n1- The number of frames in your initial dash\n\n2- The speed of your initial dash in pixels per frame");
		if is_focused("nothing") { // initial dash
			rename_int_button("Animations", "graphic_3AD01E0", "text_7C4856C", allstats, "initial_dash_time", "initial_dash_time");
			rename_float_button("Animations", "graphic_F88F94F", "text_5809F819", allstats, "initial_dash_speed", "initial_dash_speed");
		}
		
		description_box("Animations", "graphic_5B888736", "DASH BEHAVIOUR\n\n1- The speed of your run in pixels per frame\n\n2- The number of frames it takes to turn while running\n\n3- The acceleration applied when turning while running");
		if is_focused("nothing") { // dash behaviour
			rename_float_button("Animations", "graphic_7782ACCE", "text_6AF5809A", allstats, "dash_speed", "dash_speed");
			rename_int_button("Animations", "graphic_498E810E", "text_6E4B1AE2", allstats, "dash_turn_time", "dash_turn_time");
			rename_float_button("Animations", "graphic_334B4FA9", "text_3F0BC3AD", allstats, "dash_turn_accel", "dash_turn_accel");
		}
		
		description_box("Animations", "graphic_38E60778", "DASH STOP\n\n1- The number of frames it takes to stop while running\n\n2- The value to multiply your horizontal speed by when going into idle from dash or dashstop");
		if is_focused("nothing") { // dash stop
			rename_int_button("Animations", "graphic_5776D912", "text_474DAEDB", allstats, "dash_stop_time", "dash_stop_time");
			rename_float_button("Animations", "graphic_33D3EDD5", "text_42369732", allstats, "dash_stop_percent", "dash_stop_percent");
		}
		
		description_box("Animations", "graphic_2E903CB7", "GROUND STATS\n\n1- Natural deceleration while on the ground\n\n2- The maximum horizontal speed you can have when you go from grounded to aerial without jumping\n\n3- The acceleration to apply while moonwalking");
		if is_focused("nothing") { // ground stats
			rename_float_button("Animations", "graphic_1AAB6A3", "text_3C1A5EA5", allstats, "ground_friction", "ground_friction");
			rename_float_button("Animations", "graphic_14D46399", "text_2CC5259D", allstats, "leave_ground_max", "leave_ground_max");
			rename_float_button("Animations", "graphic_1B4F05D8", "text_294A594D", allstats, "moonwalk_accel", "moonwalk_accel");
		}
		
		description_box("Animations", "graphic_7D35E5F7", "JUMP STATS\n\n1- The maximum horizontal speed you can have when jumping from the ground\n\n2- The horizontal speed applied if left or right is held when jumping. Will not slow you down if you're already going faster. When reversing your momentum with a double jump, this is the maximum horizontal speed you can have\n\n3- The vertical speed applied when double jumping");
		if is_focused("nothing") { // jump stats
			rename_float_button("Animations", "graphic_385385D9", "text_3B3B5C1C", allstats, "max_jump_hsp", "max_jump_hsp");
			rename_float_button("Animations", "graphic_6E2ED2AF", "text_2ADA6496", allstats, "jump_change", "jump_change");
			rename_float_button("Animations", "graphic_426852FE", "text_1684F88F", allstats, "jump_speed", "jump_speed");
		}
		
		description_box("Animations", "graphic_4C47DB9B", "AIR BEHAVIOUR\n\n1- The maximum horizontal speed you can accelerate to when in a normal aerial state\n\n2- The horizontal speed acceleration applied when you hold left or right in a normal aerial state\n\n3- Natural deceleration applied while in the air. Also applies while in hitstun");
		if is_focused("nothing") { // air behaviour
			rename_float_button("Animations", "graphic_54CB3AFB", "text_5ACC1DB2", allstats, "air_max_speed", "air_max_speed");
			rename_float_button("Animations", "graphic_2CFADAD2", "text_357617F1", allstats, "air_accel", "air_accel");
			rename_float_button("Animations", "graphic_7DC1E6F", "text_315A0626", allstats, "air_friction", "air_friction");
		}
		
		description_box("Animations", "graphic_FA3CBAF", "FALL BEHAVIOUR\n\n1- A multiplier to your normal horizontal aerial acceleration: \n(1 = normal 0 = no acceleration)\n\n2- The maximum vertical speed you can accelerate to while falling normally\n\n3- The vertical speed applied when fastfalling");
		if is_focused("nothing") { // fall behaviour
			rename_float_button("Animations", "graphic_1D326DC4", "text_3493001A", allstats, "prat_fall_accel", "prat_fall_accel");
			rename_float_button("Animations", "graphic_16001601", "text_14B5FFD2", allstats, "max_fall", "max_fall");
			rename_float_button("Animations", "graphic_69C7CD0D", "text_6580AA22", allstats, "fast_fall", "fast_fall");
		}
		
		description_box("Animations", "graphic_59C638D3", "GRAVITY\n\n1- The gravitational acceleration applied in non-hitstun aerial states\n\n2- The gravitational acceleration applied in hitstun");
		if is_focused("nothing") { // gravity
			rename_float_button("Animations", "graphic_19DBEA20", "text_7F25C2C5", allstats, "gravity_speed", "gravity_speed");
			rename_float_button("Animations", "graphic_4CD56479", "text_4B2CF96F", allstats, "hitstun_grav", "hitstun_grav");
		}
		
		description_box("Animations", "graphic_11E27F74", "DOUBLE JUMP\n\n1- The max number of double jumps you can use\n\n2- The first frame of your double jump that acceleration is applied\n\n3- The vertical speed applied when shorthopping\n\n4- The vertical speed applied when double jumping\n\n5- The amount of acceleration to apply during your double jump. Allows for Absa-style double jump cancels\n\n6- The last frame of your double jump that acceleration is applied");
		if is_focused("nothing") { // double jump
			rename_int_button("Animations", "graphic_7C129F89", "text_C509880", allstats, "max_djumps", "max_djumps");
			rename_int_button("Animations", "graphic_DE74600", "text_16B1DAC7", allstats, "djump_accel_start_time", "djump_accel_start_time");
			rename_float_button("Animations", "graphic_34E301F2", "text_238BEC11", allstats, "short_hop_speed", "short_hop_speed");
			rename_float_button("Animations", "graphic_53EB4FC2", "text_79BC8B6", allstats, "djump_speed", "djump_speed");
			rename_float_button("Animations", "graphic_243E2388", "text_555B2A7F", allstats, "djump_accel", "djump_accel");
			rename_int_button("Animations", "graphic_49A0A601", "text_6D65A4BD", allstats, "djump_accel_end_time", "djump_accel_end_time");
		}
		
		description_box("Animations", "graphic_27E56FB9", "WALLJUMP\n\n1- The horizontal speed to apply while walljumping, in pixels per frame\n\n2- The vertical speed to apply while walljumping, in pixels per frame");
		if is_focused("nothing") { // walljump
			rename_float_button("Animations", "graphic_6FE1BE61", "text_3B0394DC", allstats, "walljump_hsp", "walljump_hsp");
			rename_float_button("Animations", "graphic_78E0246F", "text_6700D943", allstats, "walljump_vsp", "walljump_vsp");
		}
		
		description_box("Animations", "graphic_66FF4B64", "LANDING\n\n1- The number of frames in your normal landing state\n\n2- The number of frames in your prat land state");
		if is_focused("nothing") { // landing
			rename_int_button("Animations", "graphic_47FF98F4", "text_2734A5DA", allstats, "land_time", "land_time");
			rename_int_button("Animations", "graphic_4538A884", "text_18EB1B47", allstats, "prat_land_time", "prat_land_time");
		}
		
		description_box("Animations", "graphic_4D214302", "ROLL BEHAVIOUR\n\n1- The speed of your forward roll\n\n2- The speed of your backwards roll");
		if is_focused("nothing") { // roll behaviour
			rename_float_button("Animations", "graphic_14ACEDEF", "text_3A7F6937", allstats, "roll_forward_max", "roll_forward_max");
			rename_float_button("Animations", "graphic_690B5F59", "text_1E41B34B", allstats, "roll_backward_max", "roll_backward_max");
		}
		
		description_box("Animations", "graphic_1C4EA8B1", "WAVE BEHAVIOUR\n\n1- Grounded deceleration when wavelanding\n\n2- The number of frames your waveland state lasts\n\n3- The multiplier to your initial horizontal speed when wavelanding. Usually greater than 1");
		if is_focused("nothing") { // wave behaviour
			rename_float_button("Animations", "graphic_75A0F5E6", "text_1EEDB2A9", allstats, "wave_friction", "wave_friction");
			rename_int_button("Animations", "graphic_71EEBF7E", "text_7D7114F1", allstats, "wave_land_time", "wave_land_time");
			rename_float_button("Animations", "graphic_4AE118A6", "text_431A1C06", allstats, "wave_land_adj", "wave_land_adj");
		}
		
		description_box("Animations", "graphic_2FBC70A8", "JUMP TIMES\n\n1- The number of frames to play the double jump animation. Most characters have a value of 32 so that the double jump animation transitions into the falling portion of the normal jump animation\n\n2- The number of frames the walljump state takes. Normally 32, but some characters have shorter values\n\n3- The number of frames of jumpsquat minus one");
		if is_focused("nothing") { // jump times
			rename_int_button("Animations", "graphic_3950A0", "text_778E43F9", allstats, "double_jump_time", "double_jump_time");
			rename_int_button("Animations", "graphic_77A4779", "text_54CA5C8", allstats, "walljump_time", "walljump_time");
			rename_int_button("Animations", "graphic_3DF2242D", "text_111D534", allstats, "jump_start_time", "jump_start_time");
		}
	} else if page == 3 {
		if is_focused("nothing") { // walk
			
			description_box("Movement", "graphic_34ADFAAF", "WALK\n\n1- The maximum speed you can achieve while walking, in pixels per frame\n\n2- The speed gained per frame while walking\n\n3- The number of frames it takes to turn around");
			rename_float_button("Movement", "graphic_627FD80F", "text_34C26CAF", allstats, "walk_speed", "walk_speed");
			rename_float_button("Movement", "graphic_6875410", "text_6C417B4B", allstats, "walk_accel", "walk_accel");
			rename_int_button("Movement", "graphic_4F2EEAB1", "text_61F05C66", allstats, "walk_turn_time", "walk_turn_time");

			description_box("Movement", "graphic_6B6A82BA", "AIR DODGE SPEED\n\n1- The speed during airdodge's movement");
			rename_float_button("Movement", "graphic_6C888A2C", "text_7A8F7EA2", allstats, "air_dodge_speed", "air_dodge_speed");

			description_box("Movement", "graphic_3A806088", "TECHROLL SPEED\n\n1- The speed during techroll's movement");
			rename_float_button("Movement", "graphic_274EBE26", "text_42D4F33F", allstats, "techroll_speed", "techroll_speed");

			description_box("Movement", "graphic_6BFEA4A3", "IDLE ANIMATION SPEED\n\n1- The speed of your idle animation in anim frames per gameplay frame");
			rename_float_button("Movement", "graphic_5810A77B", "text_1239F2E1", allstats, "idle_anim_speed", "idle_anim_speed");

			description_box("Movement", "graphic_159A8DDB", "CROUCH ANIMATION SPEED\n\n1- The speed of your (held) crouch animation in anim frames per gameplay frame");
			rename_float_button("Movement", "graphic_BFBECED", "text_736F0CD", allstats, "crouch_anim_speed", "crouch_anim_speed");

			description_box("Movement", "graphic_2FD2188B", "WALK ANIMATION SPEED\n\n1- The speed of your walk animation in anim frames per gameplay frame");
			rename_float_button("Movement", "graphic_4C294087", "text_68E03E12", allstats, "walk_anim_speed", "walk_anim_speed");

			description_box("Movement", "graphic_76B14065", "DASH ANIMATION SPEED\n\n1- The speed of your dash animation in anim frames per gameplay frame");
			rename_float_button("Movement", "graphic_5A910F8E", "text_2DD2A05", allstats, "dash_anim_speed", "dash_anim_speed");

			description_box("Movement", "graphic_1C69F767", "PRATFALL ANIMATION SPEED\n\n1- The speed of your pratfall animation in anim frames per gameplay frame");
			rename_float_button("Movement", "graphic_46791999", "text_674913A7", allstats, "pratfall_anim_speed", "pratfall_anim_speed");
		}
	} else if page == 4 {
		if is_focused("nothing") { // char height
			description_box("Misc", "graphic_40B3469", "CHARACTER HEIGHT\n\nUsed for centering things on the character, placing the overhead HUD, etc");
			rename_int_button("Misc", "graphic_30866889", "text_84EBA50", allstats, "char_height", "char_height");
		}
		if is_focused("nothing") { // kb adj
			description_box("Misc", "graphic_76852292", "KNOCKBACK MULTIPLIER\n\nThe multiplier to knockback dealt to you:\n\n1 = default value\nhigher values = lighter character\nlower values = heavier character");
			rename_float_button("Misc", "graphic_7E5398AC", "text_876638A", allstats, "knockback_adj", "knockback_adj");
		}
		if is_focused("nothing") { // bubble x and y
			description_box("Misc", "graphic_460B57BB", "BUBBLE OFFSET POSITION\n\n1- Used for visually positioning the character in Ranno's bubble horizontally\n\n2- Used for visually positioning the character in Ranno's bubble vertically");
			rename_float_button("Misc", "graphic_1566EB5E", "text_1A71FB68", allstats, "bubble_x", "bubble_x");
			rename_float_button("Misc", "graphic_441FCBA2", "text_9230578", allstats, "bubble_y", "bubble_y");
		}
	}
}

function save_all_stats() {
	problems = false;
	var _keys = struct_get_names(allstats);
	for (var _i = 0; _i < array_length(_keys); _i++) {
		var _v = _keys[_i];
		var _linepos = archive_fetch_gml_string_startswith(AP.SCRIPTS, get_full_path("scripts/init.gml"), _v + "=", false);
		if _linepos != -1 {
			if !archive_edit_gml_line(AP.SCRIPTS, get_full_path("scripts/init.gml"), _linepos, string("{0} = {1};", _v, allstats[$ _v])) {
				show_debug_message(string("Failed to save {0} to init.gml, skipping", _v));
				problems = true;
			}
		} else {
			show_debug_message(string("Didnt find {0}", _v));
			if !archive_edit_gml_newline(AP.SCRIPTS, get_full_path("scripts/init.gml"), string("{0} = {1};", _v, allstats[$ _v])) {
				show_debug_message(string("Failed to save {0} to init.gml, skipping", _v));
				problems = true;
			}
		}
	}
	if problems {
		show_message("Some stats failed to save, init.gml is either absent or not formatted correctly");
	}
}

function description_box(_boxlayer, _boxname, _formattedDescription) {
	if mouse_in_uibox(_boxlayer, _boxname, cr_handpoint, false) {
		layer_text_text(get_ui_id("Desc", "text_4AB27E96", false), _formattedDescription);
	}
}