shader_type canvas_item;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = vec4(1.0, 1.0, 1.0, tex_color.a); // Set color to white, maintain alpha
}