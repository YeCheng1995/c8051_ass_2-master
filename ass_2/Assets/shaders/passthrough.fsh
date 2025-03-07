precision mediump float;

struct Material {
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
};

varying vec2 TexCoords;

uniform Material material;

void main() {
    gl_FragColor = texture2D(material.diffuse, TexCoords);
    gl_FragColor.a = 0.2;
}
