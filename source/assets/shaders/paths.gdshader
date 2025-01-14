shader_type spatial;
render_mode unshaded;

uniform vec4 color : hint_color = vec4(1.0);
uniform float brightness = 1.0;
uniform float grow = 0.0;

uniform float transp_intensity = 0.1;
uniform vec2 transp_vel = vec2(1.0);
uniform vec2 transp_uv_scale = vec2(1.0);
uniform vec3 transp_edge_rot = vec3(0.2, 0.2, 0.2);
uniform sampler2D transp_tex_x : hint_white;
uniform sampler2D transp_tex_y : hint_white;
uniform sampler2D transp_tex_z : hint_white;

// Randomizer from The Book of Shaders.
float rand(vec2 st) {
	return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

void vertex() {
	// We transpose each vertex using its UV coordinates mapped especially for this.
	// It is also randomized on node world position.
	vec3 world_origin = (WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	float rng = rand(vec2(world_origin.x + world_origin.z, world_origin.y + world_origin.z));
	vec2 offset_uv = vec2(0.0);
	offset_uv.x = UV.x * transp_uv_scale.x + TIME * transp_vel.x * 0.05 + rng;
	offset_uv.y = UV.y * transp_uv_scale.y + TIME * transp_vel.y * 0.05 + rng;
	vec3 offset = vec3(0.0);
	offset.x = texture(transp_tex_x, offset_uv).x * 2.0 - 1.0;
	offset.y = texture(transp_tex_y, offset_uv).x * 2.0 - 1.0;
	offset.z = texture(transp_tex_z, offset_uv).x * 2.0 - 1.0;
	
	// In order for each strand to connect each other, we must guarantee the ends are
	// always in the same place. We displace them for better looks.
	float bounds = smoothstep(0.0, 0.2, UV.x) * smoothstep(0.0, 0.2, 1.0 - UV.x);
	bounds *= smoothstep(0.0, 0.2, UV.y) * smoothstep(0.0, 0.2, 1.0 - UV.y);
	vec3 edge_offs = vec3(0.0);
	edge_offs.x = sin(TIME * transp_edge_rot.x) * 0.0;
	edge_offs.y = cos(TIME * transp_edge_rot.y) * 0.0;
	edge_offs.z = sin(TIME * transp_edge_rot.z) * 0.0;
	
	VERTEX += mix(edge_offs, offset, bounds) * transp_intensity + NORMAL * grow;
}

void fragment() {
	ALBEDO = color.rgb * brightness;
}