//
//  Shader.vsh
//  gles1
//
//  Created by and on 05/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 colorVarying;
//varying float intensity;
varying vec3 vnormal;

uniform mat4 projection;
uniform mat4 modelview;
uniform mat3 normal_matrix;
//uniform vec3 light_dir;



void main()
{
	vec4 v = vec4(position);
	
	gl_Position = projection * modelview * v;
	
	vnormal = normal_matrix * normal;
	
	//intensity = dot(light_dir,normal);
}
