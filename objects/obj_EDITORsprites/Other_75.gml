                                                                             switch (async_load[?"event_type"]) {
	case "file_drag_enter_start":
		filedrag = true;
		break;
	case "file_drag_leave":
		reset_drag();
		break;
	case "file_drop":
		if focus != "nothing" {exit}
		numdragfiles++;
		var _f = async_load[?"filename"];
		if filename_ext(_f) == ".png" {
			var _newPos = get_full_path(string("sprites/{0}", filename_name(_f)));
			if !array_contains(forbidden, filename_name(_f)) {
				numdragfilessuccess++;
				archive_create(AP.SPRITES, _newPos, FT.SPRITE);
				archive_edit_sprite(AP.SPRITES, _newPos, _f, _newPos);
			}
		}
		break;
	case "file_drop_end":
		if numdragfiles > 0 {
			if numdragfiles == numdragfilessuccess {
				show_message(string("Successfully imported {0} sprites", numdragfilessuccess));
			} else {
				show_message(string("Successfully imported {0} sprites out of {1} files", numdragfilessuccess, numdragfiles));
			}
			load_all();
		}
		reset_drag();
		break;
}