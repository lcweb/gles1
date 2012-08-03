//
//  Shader.vsh
//  gles1
//
//  Created by and on 05/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform mat4 projection;
uniform mat4 modelview;



void main()
{
	vec4 v = vec4(position);
	
	gl_Position = projection * modelview * v;

    colorVarying = color;
}