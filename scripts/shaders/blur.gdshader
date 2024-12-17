shader_type canvas_item;

uniform float blur_amount : hint_range(0, 5);
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV, blur_amount);
}