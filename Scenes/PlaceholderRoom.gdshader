shader_type canvas_item;

// Settings you can adjust
uniform vec2 player_position = vec2(0.0, 0.0);  // Player's screen position
uniform float min_distance = 50.0;              // Distance where fog starts
uniform float max_distance = 300.0;             // Distance where fog is fully opaque
uniform float min_alpha = 0.0;                  // Minimum fog transparency (close to player)
uniform float max_alpha = 0.85;                 // Maximum fog transparency (far from player)
uniform vec4 fog_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);  // Fog color (black)

void fragment() {
	// Calculate distance from this pixel to the player
	float dist = length(FRAGCOORD.xy - player_position);
	
	// Smoothly transition from min_alpha to max_alpha based on distance
	float fog_strength = smoothstep(min_distance, max_distance, dist);
	float alpha = mix(min_alpha, max_alpha, fog_strength);
	
	// Apply the fog color with calculated transparency
	COLOR = vec4(fog_color.rgb, alpha);
}
