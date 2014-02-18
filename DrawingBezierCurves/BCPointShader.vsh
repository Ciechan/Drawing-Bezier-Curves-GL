
attribute vec4 position;
attribute vec2 texCoord;

varying vec2 texCoordVarying;

uniform mat4 viewProjectionMatrix;

void main()
{
    texCoordVarying = texCoord;
    
    gl_Position = viewProjectionMatrix * position;
}

