// Type Checks
is_real(v):#
is_int32(v):#
is_int64(v):#
is_bool(v):#
is_number(v):#
is_string(v):#
is_array(v):#
is_object(v):#

// Math 
power(v:number, p:number):#
abs(x:number):#
round(x:number):#
floor(x:number):#
ceil(x:number):#
sign(x:number):#
frac(x:number):#
sqrt(x:number):#
sqr(x:number):#
exp(x:number):#
ln(x:number):#
log2(x:number):#
log10(x:number):#
logn(n:number, x:number):#
sin(x:number):#
cos(x:number):#
tan(x:number):#
arcsin(x:number):#
arccos(x:number):#
arctan(x:number):#
arctan2(y:number, x:number):#
dsin(x:number):#
dcos(x:number):#
dtan(x:number):#
darcsin(x:number):#
darccos(x:number):#
darctan(x:number):#
darctan2(y:number, x:number):#
degtorad(x:number):#
radtodeg(x:number):#
min(...):#
max(...):#
clamp(v:number, min:number, max:number):#
lerp(v1:number, v2:number, amt:number):#
dot_product(x1:number, y1:number, x2:number, y2:number):#
dot_product_3d(x1:number, y1:number, z1:number, x2:number, y2:number, z2:number):#
angle_difference(src:number, dst:number):#
point_distance(x1:number, y1:number, x2:number, y2:number):#
point_direction(x1:number, y1:number, x2:number, y2:number):#
lengthdir_x(len:number, dir:number):#
lengthdir_y(len:number, dir:number):#

// Type Conversions
real(val):#
bool(val):#
string(val):#

// String Functions
string_format(val:number, tot:int, dec:int):#
chr(c:int):#
string_length(s:string):#
string_pos(sub:string, s:string):#
string_count(sub:string, s:string):#
string_copy(s:string, index:int, count:int):#
string_delete(s:string, index:int, count:int):#
string_char_at(s:string, index:int):#
string_ord_at(s:string, index:int):#
string_upper(s:string):#
string_lower(s:string):#
string_letters(s:string):#
string_digits(s:string):#
string_lettersdigits(s:string):#
string_replace(s:string, what:string, by:string):#
string_replace_all(s:string, what:string, by:string):#
ord(string)

// Array Functions
array_create(size:int, val=0):
array_clear(arr:array, val):
array_clone(arr:array):
array_slice(arr:array, start:int, length:int):
array_copy(dest:array, dest_index:int, source:array, source_index:int, length:int)
array_length(val):
array_length_1d(arr:array):
/// Alias for array_length
array_equals(a:array, b:array):
array_push(arr, val):
array_insert(arr:array, pos:int, val)
array_find_index(arr:array, val):
array_find_index_ext(arr:array, val, start:int):
array_find_last_index(arr:array, val):
array_find_last_index_ext(arr:array, val, start:int):
array_sort(arr:array, ascend:bool)
array_sort_sub(arr:array, sub_index:int, ascend:bool)
array_join(:array, :string):

// List Functions
ds_list_create():
ds_list_destroy(list):
ds_list_valid(list):
ds_list_clear(list)
ds_list_size(list):
ds_list_shuffle(list)
ds_list_find_value(list, index:int):
/// Alias for ds_list_find_value
ds_list_set(list, index:int, val)
ds_list_add(list, ...values)
ds_list_add_array(list, array:array)
ds_list_insert(list, index:int, val)
ds_list_delete(list, index:int)
ds_list_find_index(list, val):
ds_list_remove(list, val):
ds_list_join(list, sep:string):
ds_list_to_array(list):

// Map Functions
ds_map_create():
ds_map_destroy(map):
ds_map_valid(map):
ds_map_clear(map)
ds_map_size(map):
ds_map_keys(map):
ds_map_values(map):
ds_map_find_value(map, key):
ds_map_set(map, key, val)
ds_map_exists(map, key):
ds_map_delete(map, key):

// Grid Functions
ds_grid_create(w:int, h:int):
ds_grid_destroy(grid):
ds_grid_valid(grid):
ds_grid_clear(grid, val)
ds_grid_width(grid):
ds_grid_height(grid):
ds_grid_resize(grid, w:int, h:int)
ds_grid_get(grid, x:number, y:number):
ds_grid_set(grid, x:number, y:number, val)
ds_grid_set_region(grid, x1:number, y1:number, x2:number, y2:number, val)
ds_grid_sort(grid, column:int, ascending:bool)

// Vertex Functions
vertex_create_buffer():
vertex_create_buffer_ext(size:int):
vertex_delete_buffer(vbuf):
vertex_begin(vbuf, vfmt)
vertex_float1(vbuf, v1:number)
vertex_float2(vbuf, v1:number, v2:number)
vertex_float3(vbuf, v1:number, v2:number, v3:number)
vertex_float4(vbuf, v1:number, v2:number, v3:number, v4:number)
vertex_color(vbuf, c:int, a:number)
vertex_colour(vbuf, c:int, a:number)
vertex_texcoord(vbuf, tx:number, ty:number)
vertex_position(vbuf, x:number, y:number)
vertex_position_3d(vbuf, x:number, y:number, z:number)
vertex_normal(vbuf, nx:number, ny:number, nz:number)
vertex_argb(vbuf, v:int)
vertex_end(vbuf)
vertex_get_buffer_size(vbuf):
vertex_get_number(vbuf):
vertex_freeze(vbuf)
vertex_submit(vbuf, prType:int, tex=Texture.defValue)
vertex_format_begin():
vertex_format_end():
vertex_format_delete(vfmt):
vertex_format_add_color()
vertex_format_add_colour()
vertex_format_add_normal()
vertex_format_add_position()
vertex_format_add_position_3d()
vertex_format_add_texcoord()
vertex_format_add_custom(type:int, usage:int)

// Instance Variable Functions
variable_instance_exists(inst, varname:string):
variable_instance_get(inst, varname:string, ?defvalue):
variable_instance_set(inst, varname:string, value):
variable_instance_get_names(inst, ?outList):

// Sprite Data Functions
sprite_add_base64(b64:string, num:int, xo:number, yo:number):
sprite_exists(ind):
sprite_get_name(ind):
sprite_get_number(ind):
sprite_get_width(ind):
sprite_get_height(ind):
sprite_get_xoffset(ind):
sprite_get_yoffset(ind):
sprite_get_bbox_mode(ind):
sprite_get_bbox_left(ind):
sprite_get_bbox_right(ind):
sprite_get_bbox_top(ind):
sprite_get_bbox_bottom(ind):

// Instance Functions
instance_exists(:id):bool
instance_number(obj:id):int
instance_find(obj:id, ind:int):inst
instance_nearest(x:number,y:number,obj:id):inst
instance_furthest(x:number,y:number,obj:id):inst
:place_snapped(hsnap:number, vsnap:number):bool
:move_random(hsnap:number, vsnap:number)
:move_snap(hsnap:number, vsnap:number)
:move_towards_point(x:number, y:number, sp:number)
:move_contact_solid(dir:number, maxdist:number)
:move_contact_all(dir:number, maxdist:number)
:move_outside_solid(dir:number, maxdist:number)
:move_outside_all(dir:number, maxdist:number)
:move_bounce_solid(advanced:bool)
:move_bounce_all(advanced:bool)
:move_wrap(hor:bool, vert:bool, margin:number)
:distance_to_point(x:number, y:number):number
:distance_to_object(obj:index):number

get_instance_player(instance_id:id)
get_instance_player_id(instance_id:id)
get_instance_x(instance_id:id)
get_instance_y(instance_id:id)

// Collision Functions
:instance_place(x:number,y:number,obj:id):inst
:instance_place_list(x:number,y:number,obj:id, list, ordered:bool):inst
:instance_position(x:number,y:number,obj:id):inst
:instance_position_list(x:number,y:number,obj:id, list, ordered:bool):inst
:place_free(x:number, y:number):bool
:place_empty(x:number, y:number):bool
:place_meeting(x:number, y:number, obj:index):bool
:position_empty(x:number, y:number):bool
:position_meeting(x:number, y:number, obj:index):bool
:collision_point(x:number,y:number,obj:id,prec:bool,notme:bool):inst
:collision_rectangle(x1:number,y1:number,x2:number,y2:number,obj:id,prec:bool,notme:bool):inst
:collision_circle(x1:number,y1:number,radius,obj:id,prec:bool,notme:bool):inst
:collision_ellipse(x1:number,y1:number,x2:number,y2:number,obj:id,prec:bool,notme:bool):inst
:collision_line(x1:number,y1:number,x2:number,y2:number,obj:id,prec:bool,notme:bool):inst

:motion_set(dir:number, speed:number)
:motion_add(dir:number, speed:number)

// Motion Planning Functions (do we even have a use for these?)
:mp_linear_step(x:number,y:number,speed:number,checkall:bool):
:mp_potential_step(x:number,y:number,speed:number,checkall:bool):
:mp_linear_step_object(x:number,y:number,speed:number,obj:index):
:mp_potential_step_object(x:number, y:number, speed:number, obj:index):

/// Drawing

// Color Functions
draw_set_colour(:color)
draw_set_color(:color)
draw_set_alpha(alpha:number)
draw_get_colour():color
draw_get_color():color
draw_get_alpha():number

merge_colour(col1:number,col2:number,amount:number)£:
make_colour_rgb(red:number,green:number,blue:number)£:
make_colour_hsv(hue:number,saturation:number,value:number)£:
colour_get_red(:color)£:
colour_get_green(:color)£:
colour_get_blue(:color)£:
colour_get_hue(:color)£:
colour_get_saturation(:color)£:
colour_get_value(:color)£:
merge_colour(col1:color,col2:color,amount:number)$:
make_color_rgb(red:number,green:number,blue:number)$:
make_color_hsv(hue:number,saturation:number,value:number)$:
color_get_red(:color)$:
color_get_green(:color)$:
color_get_blue(:color)$:
color_get_hue(:color)$:
color_get_saturation(:color)$:
color_get_value(:color)$:
merge_color(:color,:color,amount:number)$:

// Font Functions
draw_set_font(:font)
draw_get_font():font
:font_get(v:string)
draw_set_halign(halign:int)
draw_get_halign():int
draw_set_valign(valign:int)
draw_get_valign():int

string_width(:string):number
string_height(:string):number
string_width_ext(:string, sep:number, w:number):number
string_height_ext(:string, sep:number, w:number):number

// Text Drawing Functions
draw_text_transformed(x,y,string,xscale,yscale,angle)
draw_text_ext_transformed(x,y,string,sep,w,xscale,yscale,angle)
draw_text_colour(x,y,string,c1,c2,c3,c4,alpha)£
draw_text_ext_colour(x,y,string,sep,w,c1,c2,c3,c4,alpha)£
draw_text_transformed_colour(x,y,string,xscale,yscale,angle,c1,c2,c3,c4,alpha)£
draw_text_ext_transformed_colour(x,y,string,sep,w,xscale,yscale,angle,c1,c2,c3,c4,alpha)£
draw_text_color(x,y,string,c1,c2,c3,c4,alpha)$
draw_text_ext_color(x,y,string,sep,w,c1,c2,c3,c4,alpha)$
draw_text_transformed_color(x,y,string,xscale,yscale,angle,c1,c2,c3,c4,alpha)$
draw_text_ext_transformed_color(x,y,string,sep,w,xscale,yscale,angle,c1,c2,c3,c4,alpha)$
:draw_debug_text(x:int, y:int, text:string)

// Shape Drawing Functions
draw_point_colour(x,y,col1)£
draw_line_colour(x1,y1,x2,y2,col1,col2)£
draw_line_width_colour(x1,y1,x2,y2,w,col1,col2)£
draw_rectangle_colour(x1,y1,x2,y2,col1,col2,col3,col4,outline)£
draw_roundrect_colour(x1,y1,x2,y2,col1,col2,outline)£
draw_roundrect_colour_ext(x1,y1,x2,y2,radiusx,radiusy,col1,col2,outline)£
draw_triangle_colour(x1,y1,x2,y2,x3,y3,col1,col2,col3,outline)£
draw_circle_colour(x,y,r,col1,col2,outline)£
draw_ellipse_colour(x1,y1,x2,y2,col1,col2,outline)£
draw_point_color(x,y,col1)$
draw_line_color(x1,y1,x2,y2,col1,col2)$
draw_line_width_color(x1,y1,x2,y2,w,col1,col2)$
draw_rectangle_color(x1,y1,x2,y2,col1,col2,col3,col4,outline)$
draw_roundrect_color(x1,y1,x2,y2,col1,col2,outline)$
draw_roundrect_color_ext(x1,y1,x2,y2,radiusx,radiusy,col1,col2,outline)$
draw_triangle_color(x1,y1,x2,y2,x3,y3,col1,col2,col3,outline)$
draw_circle_color(x,y,r,col1,col2,outline)$
draw_ellipse_color(x1,y1,x2,y2,col1,col2,outline)$

// Primitive Drawing Functions
draw_primitive_begin(kind)
draw_vertex(x,y)
draw_vertex_colour(x,y,col,alpha)£
draw_vertex_color(x,y,col,alpha)$
draw_primitive_end()
sprite_get_uvs(spr,subimg)
font_get_uvs(font)
sprite_get_texture(spr,subimg)
font_get_texture(font)
texture_get_width(texid)
texture_get_height(texid)
texture_get_uvs(texid)
draw_primitive_begin_texture(kind,texid)
draw_vertex_texture(x,y,xtex,ytex)
draw_vertex_texture_colour(x,y,xtex,ytex,col,alpha)£
draw_vertex_texture_color(x,y,xtex,ytex,col,alpha)$
texture_global_scale(pow2integer)

// GPU State Functions
gpu_set_blendenable(enable)
gpu_set_ztestenable(enable)
gpu_set_zfunc(cmp_func)
gpu_set_zwriteenable(enable)
gpu_set_fog(enable,col,start,end)
gpu_set_cullmode(cullmode)
gpu_set_blendmode(mode)
gpu_set_blendmode_ext(src,dest)
gpu_set_blendmode_ext_sepalpha(src,dest,srcalpha,destalpha)
gpu_set_colorwriteenable(red,green,blue,alpha)$
gpu_set_colourwriteenable(red,green,blue,alpha)£
gpu_set_alphatestenable(enable)
gpu_set_alphatestref(value)
gpu_set_alphatestfunc(cmp_func)
gpu_set_texfilter(linear)
gpu_set_texfilter_ext(sampler_id,linear)
gpu_set_texrepeat(repeat)
gpu_set_texrepeat_ext(sampler_id,repeat)
gpu_set_tex_filter(linear)
gpu_set_tex_filter_ext(sampler_id,linear)
gpu_set_tex_repeat(repeat)
gpu_set_tex_repeat_ext(sampler_id,repeat)
gpu_set_tex_mip_filter(filter)
gpu_set_tex_mip_filter_ext(sampler_id,filter)
gpu_set_tex_mip_bias(bias)
gpu_set_tex_mip_bias_ext(sampler_id,bias)
gpu_set_tex_min_mip(minmip)
gpu_set_tex_min_mip_ext(sampler_id,minmip)
gpu_set_tex_max_mip(maxmip)
gpu_set_tex_max_mip_ext(sampler_id,maxmip)
gpu_set_tex_max_aniso(maxaniso)
gpu_set_tex_max_aniso_ext(sampler_id,maxaniso)
gpu_set_tex_mip_enable(setting)
gpu_set_tex_mip_enable_ext(sampler_id,setting)
gpu_get_blendenable()                            :
gpu_get_ztestenable()                            :
gpu_get_zfunc()                                  :
gpu_get_zwriteenable()                           :
gpu_get_fog()                                    :
gpu_get_cullmode()                               :
gpu_get_blendmode()                              :
gpu_get_blendmode_ext()                          :
gpu_get_blendmode_ext_sepalpha()                 :
gpu_get_blendmode_src()                          :
gpu_get_blendmode_dest()                         :
gpu_get_blendmode_srcalpha()                     :
gpu_get_blendmode_destalpha()                    :
gpu_get_colorwriteenable()$                      :
gpu_get_colourwriteenable()£                     :
gpu_get_alphatestenable()                        :
gpu_get_alphatestref()                           :
gpu_get_alphatestfunc()                          :
gpu_get_texfilter()                              :
gpu_get_texfilter_ext(sampler_id)                :
gpu_get_texrepeat()                              :
gpu_get_texrepeat_ext(sampler_id)                :
gpu_get_tex_filter()                             :
gpu_get_tex_filter_ext(sampler_id)               :
gpu_get_tex_repeat()                             :
gpu_get_tex_repeat_ext(sampler_id)               :
gpu_get_tex_mip_filter()                         :
gpu_get_tex_mip_filter_ext(sampler_id)           :
gpu_get_tex_mip_bias()                           :
gpu_get_tex_mip_bias_ext(sampler_id)             :
gpu_get_tex_min_mip()                            :
gpu_get_tex_min_mip_ext(sampler_id)              :
gpu_get_tex_max_mip()                            :
gpu_get_tex_max_mip_ext(sampler_id)              :
gpu_get_tex_max_aniso()                          :
gpu_get_tex_max_aniso_ext(sampler_id)            :
gpu_get_tex_mip_enable()                         :
gpu_get_tex_mip_enable_ext(sampler_id)           :
gpu_push_state()
gpu_pop_state()
// Light Drawing Functions
draw_light_define_ambient(col)
draw_light_define_direction(ind,dx,dy,dz,col)
draw_light_define_point(ind,x,y,z,range,col)
draw_light_enable(ind,enable)
draw_set_lighting(enable)
draw_light_get_ambient()
draw_light_get(ind)
draw_get_lighting():
// Sprite Drawing Functions
draw_self()
draw_sprite(sprite:id,subimg:number,x:number,y:number)
draw_sprite_pos(sprite:id,subimg:number,x1:number,y1:number,x2:number,y2:number,x3:number,y3:number,x4:number,y4:number,alpha:number)
draw_sprite_ext(sprite:id,subimg:number,x:number,y:number,xscale:number,yscale:number,rot:number,col:number,alpha:number)
draw_sprite_stretched(sprite:id,subimg:number,x:number,y:number,w:number,h:number)
draw_sprite_stretched_ext(sprite:id,subimg:number,x:number,y:number,w:number,h:number,col:number,alpha:number)
draw_sprite_tiled(sprite:id,subimg:number,x:number,y:number)
draw_sprite_tiled_ext(sprite:id,subimg:number,x:number,y:number,xscale:number,yscale:number,col:number,alpha:number)
draw_sprite_part(sprite:id,subimg:number,left,top,w:number,h:number,x:number,y:number)
draw_sprite_part_ext(sprite:id,subimg:number,left,top,w:number,h:number,x:number,y:number,xscale:number,yscale:number,col:number,alpha:number)
draw_sprite_general(sprite:id,subimg:number,left,top,w:number,h:number,x:number,y:number,xscale:number,yscale:number,rot:number,c1:color,c2:color,c3:color,c4:color,alpha:number)
:sprite_get(v:string)

// Camera Functions
view_get_wview()
view_get_hview()
view_get_xview()
view_get_yview()
set_view_position( x, y )
shake_camera(intensity:real, time:real)

:init_shader()
:shader_start()
:shader_end()

// Resource Getters
asset_get(asset:string)
resource_get(v:string)
sprite_change_offset(spr:string, xoff:int, yoff:int, ?big_hurtbox)
sprite_change_collision_mask(sprite:string, sepmasks:int, bboxmode:int, bbleft:int, bbtop:int, bbright:int, bbbottom:int, kind:int)
instance_create(x:int, y:int, obj:string, ?script:int)
instance_destroy(...values)
article_destroy(instance_id)

:trigger_b_reverse()
random_func(index:int, high_value:int, floored:int)
random_func_2(index:int, high_value:int, floored:int)

// Sound Functions
:sound_get(v:string)
sound_play(sound, ?looping, ?panning, ?volume, ?pitch)
sound_stop(sound)
audio_sound_gain(index, volume, time)
sound_volume(index, volume, time)
audio_sound_pitch(index, pitch)
sound_pitch(index, pitch)

// Player Functions
:attack_end(?attack:int)
:set_state(state:int)
:set_attack(atk:int)
:iasa_script()
:can_tap_jump()
hit_fx_create(sprite_index:int, hit_length:int)
:spawn_hit_fx(x:int, y:int, hit_fx_index:int)
:spawn_dust_fx(x:int, y:int, sprite_index:int, length:int)
set_hit_particle_sprite( num:real, sprite_index:real, ?uses_shader:bool)
:take_damage(player:int, attacker:int, damage:int)

get_player_damage(player:int)
get_player_stocks(player:int)
get_player_team(player:int)
set_player_stocks(player:int, stocks:int)
set_player_team(player:int, team:int)
set_player_damage(player:int, damage:int)
get_player_color(player:int)
get_player_name(player:int)
get_synced_var(player:int)
set_synced_var(player:int, value)

set_ui_element(type:int, value:int)

will_die_from_kb(instance:real, power:real, angle:real, hitstun:real)
trigger_hit_shockwave(instance:real, disable_hitstop:bool)

set_victory_theme(index:int)
set_victory_bg(bg:int)
set_victory_portrait(sprite_index:int)
set_victory_sidebar(sprite_index:int)

get_training_cpu_action()

:clear_button_buffer(input_id:int)

get_state_name(state:int)

get_local_player()

is_attack_pressed( dir )
is_strong_pressed( dir )
is_special_pressed( dir )

get_char_info(player, info)

has_rune(rune:string)

get_player_hud_color( player )

// Hitbox Functions
:create_hitbox(attack:int, hitbox_num:int, x:int, y:int)
get_hitstop_formula(plr_damage:int, hbox_damage:int, base_hitpause:int, hitpause_scaling:real, extra_hitpause:int)
get_hitstun_formula(plr_damage:int, plr_knockback_adj:real, kb_multiplier:real, hbox_damage:int, base_knockback:real, knockback_scaling:real)
get_kb_formula(plr_damage:int, plr_knockback_adj:real, kb_multiplier:real, hbox_damage:int, base_knockback:real, knockback_scaling:real)
:create_deathbox(x:int, y:int, w:int, h:int, player:int, free:bool, shape:int, lifespan:int, bg_type:int)
:destroy_hitboxes()
:get_hitbox_angle(hitbox_id:int)

// Debug Functions
print(text)
print_debug(text)
trace(...values)

// Alt Palette Functions
set_color_profile_slot(color:int, shade:int, r:int, g:int, b:int)
set_color_profile_slot_range(shade:int, r:int, g:int, b:int)
set_character_color_slot(shade_slot:int, r:int, g:int, b:int, ?a:int)
set_article_color_slot(shade_slot:int, r:int, g:int, b:int, ?a:int)
set_character_color_shading(shade_slot:int, shading_value)
get_color_profile_slot_r(color_slot:int, shade_slot:int)
get_color_profile_slot_g(color_slot:int, shade_slot:int)
get_color_profile_slot_b(color_slot:int, shade_slot:int)
get_color_profile_slot_range(shade_slot:int, hsv:int)
set_num_palettes(num:int)

get_gameplay_time()
get_game_timer()

get_stage_data(index:int)


:set_attack_value(attack:int, index:int, value)
:get_attack_value(attack:int, index:int)
:reset_attack_value(attack:int, index:int)
:set_window_value(attack:int, window:int, index:int, value)
:get_window_value(attack:int, window:int, index:int)
:reset_window_value(attack:int, window:int, index:int)
:set_hitbox_value(attack:int, hitbox:int, index:int, value)
:get_hitbox_value(attack:int, hitbox:int, index:int)
:reset_hitbox_value(attack:int, hitbox:int, index:int)
:set_num_hitboxes(attack:int, value)
:get_num_hitboxes(attack:int)
:reset_num_hitboxes(attack:int)

// Easing Functions
tween(ease, start:int, end:int, current_time:int, total_time:int, ...values)
ease_linear(start:int, end:int, current_time:int, total_time:int)
ease_backIn(start:int, end:int, current_time:int, total_time:int, overshoot:int)
ease_backInOut(start:int, end:int, current_time:int, total_time:int, overshoot:int)
ease_backOut(start:int, end:int, current_time:int, total_time:int, overshoot:int)
ease_bounceIn(start:int, end:int, current_time:int, total_time:int)
ease_bounceInOut(start:int, end:int, current_time:int, total_time:int)
ease_bounceOut(start:int, end:int, current_time:int, total_time:int)
ease_circIn(start:int, end:int, current_time:int, total_time:int)
ease_circInOut(start:int, end:int, current_time:int, total_time:int)
ease_circOut(start:int, end:int, current_time:int, total_time:int)
ease_cubeIn(start:int, end:int, current_time:int, total_time:int)
ease_cubeInOut(start:int, end:int, current_time:int, total_time:int)
ease_cubeOut(start:int, end:int, current_time:int, total_time:int)
ease_expoIn(start:int, end:int, current_time:int, total_time:int)
ease_expoInOut(start:int, end:int, current_time:int, total_time:int)
ease_expoOut(start:int, end:int, current_time:int, total_time:int)
ease_quadIn(start:int, end:int, current_time:int, total_time:int)
ease_quadInOut(start:int, end:int, current_time:int, total_time:int)
ease_quadOut(start:int, end:int, current_time:int, total_time:int)
ease_quartIn(start:int, end:int, current_time:int, total_time:int)
ease_quartInOut(start:int, end:int, current_time:int, total_time:int)
ease_quartOut(start:int, end:int, current_time:int, total_time:int)
ease_quintIn(start:int, end:int, current_time:int, total_time:int)
ease_quintInOut(start:int, end:int, current_time:int, total_time:int)
ease_quintOut(start:int, end:int, current_time:int, total_time:int)
ease_sineIn(start:int, end:int, current_time:int, total_time:int)
ease_sineInOut(start:int, end:int, current_time:int, total_time:int)
ease_sineOut(start:int, end:int, current_time:int, total_time:int)

end_match( ?first:real, ?second:real, ?third:real, ?fourth:real )
get_match_setting( setting:real )
get_local_setting( setting:real )

// Stage Functions
get_marker_x( num:real )
get_marker_y( num:real )
is_aether_stage()
get_article_script( instance_id )
music_play_file( file )
music_stop()
music_set_volume( volume:real )
music_fade( ?volume:real, ?amount_per_frame:real )
music_crossfade( ?fade_to_laststock:bool, ?amount_per_frame:real )
is_laststock()
is_player_on( slot:real )
suppress_stage_music( ?volume:real, ?amount_per_frame:real )

get_bg_data(layer:int, data:int)
set_bg_data(layer:int, data:int, value)

// Misc Functions
set_kill_bg(x:real, y:real, type:real)
user_event( num:real )
event_user( num:real )
:script_execute(script:int, ...args):
script_get_name(script:int):
script_get_index(script_name:string):
get_string(prompt:string, default:string)
