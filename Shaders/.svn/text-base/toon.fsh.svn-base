//
//  Shader.fsh
//  gles1
//
//  Created by and on 05/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

//varying lowp float intensity;
varying lowp vec3 vnormal;

uniform lowp vec3 light_dir;

void main()
{
		
	lowp float intensity;
	lowp vec4 color;

	
	intensity = dot(light_dir,normalize(vnormal));
	
	if (intensity > 0.95)
		color = vec4(1.0,0.5,0.5,1.0);
	else if (intensity > 0.5)
		color = vec4(0.6,0.3,0.3,1.0);
	else if (intensity > 0.25)
		color = vec4(0.4,0.2,0.2,1.0);
	else
		color = vec4(0.2,0.1,0.1,1.0);		
	
	gl_FragColor = color;

}
