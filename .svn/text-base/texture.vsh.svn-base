attribute vec3 position;
attribute vec2 textcoord;
uniform mat4 projection;
uniform mat4 modelview;
varying vec2 fragmentTextureCoordinates; 
void main()
{
	vec4 pos = vec4(position, 1.0);
    gl_Position = projection * modelview * pos;
    fragmentTextureCoordinates = textcoord;
}