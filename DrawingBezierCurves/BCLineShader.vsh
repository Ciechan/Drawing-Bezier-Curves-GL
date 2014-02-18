
attribute vec4 position;

varying vec4 colorVarying;

uniform mat4 viewProjectionMatrix;

void main()
{
    colorVarying = vec4(237.0/255.0, 76.0/255.0, 84.0/255.0, 1.0);
    
    gl_Position = viewProjectionMatrix * position;
}

