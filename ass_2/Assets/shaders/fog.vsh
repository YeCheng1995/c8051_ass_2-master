precision mediump float;

attribute vec3 aPos;
attribute vec3 aNormal;
attribute vec2 aTexCoords;

varying vec3 FragPos;
varying vec3 Normal;
varying vec2 TexCoords;
varying vec4 viewSpace;

uniform mat3 normalMatrix;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main() {
    FragPos = vec3(model * vec4(aPos, 1.0));
    Normal = normalMatrix * aNormal;
    
    TexCoords = aTexCoords;
    
    viewSpace = view * vec4(FragPos, 1.0);
    gl_Position = projection * viewSpace;
}
