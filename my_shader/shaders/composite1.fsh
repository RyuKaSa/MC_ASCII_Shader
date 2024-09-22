#version 130
#extension GL_ARB_explicit_attrib_location : enable

uniform float viewWidth;
uniform float viewHeight;
uniform float frameTimeCounter;

uniform sampler2D colortex0;

#include "/lib/settings.glsl"

in vec2 texcoord;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 colortex0Out;

// Helper functions for saturation
vec3 rgbToHsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsvToRgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec3 color = texture(colortex0, texcoord).rgb;

    #ifdef POST_PROCESSING
    // Step 1: Apply brightness adjustment
    float brightnessFactor = 1.0;  // Adjust this value for brightness
    vec3 brightenedColor = color * brightnessFactor;  // Apply brightness first

    // Step 2: Apply saturation adjustment on the brightened color
    vec3 hsv = rgbToHsv(brightenedColor);  // Use brightenedColor for saturation adjustment
    float saturationFactor = 1.8;  // Adjust this value for saturation
    hsv.y *= saturationFactor;
    vec3 finalColor = hsvToRgb(hsv);

    // Output the final color with both brightness and saturation applied
    colortex0Out = vec4(finalColor, 1.0);
    #else
    colortex0Out = vec4(color, 1.0);  // Output the unmodified color if POST_PROCESSING is not enabled
    #endif
}
