#version 150

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;  // World transformation matrix for the fragment

in vec3 vaPosition;
in vec2 vaUV0;

out vec3 fragPos;  // Pass world space fragment position to the fragment shader
out vec2 texcoord;

void main() {
    // Compute world-space position of the fragment
    fragPos = (modelMatrix * vec4(vaPosition, 1.0)).xyz;

    // Pass the UV coordinates to the fragment shader
    texcoord = vaUV0;

    // Compute final position in clip space
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);
}
