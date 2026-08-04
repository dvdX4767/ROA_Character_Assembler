varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D tex_original;
uniform sampler2D tex_replacement;
uniform float u_color_count;

void main() {
	vec4 current_color = texture2D(gm_BaseTexture, v_vTexcoord);
	
	for (float i = 0.0; i < 2048.0; i++) {
		if (i >= u_color_count) {
			break;
		}
		
		vec4 check_color = texture2D(tex_original, vec2((i + 0.5) / u_color_count, 0.0));
		
		if (distance(floor(current_color.rgb * 255.0 + 0.5), floor(check_color.rgb * 255.0 + 0.5)) < 0.5) {
			current_color = texture2D(tex_replacement, vec2((i + 0.5) / u_color_count, 0.0));
			break;
		}
	}
	
	gl_FragColor = v_vColour * current_color;
}