package shaders;

import flixel.system.FlxAssets.FlxShader;

class FireShader extends FlxShader
{
	@:glFragmentSource('
    // Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
#define texture flixel_texture2D

// third argument fix
vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
	vec4 color = texture2D(bitmap, coord, bias);
	if (!hasTransform)
	{
		return color;
	}
	if (color.a == 0.0)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	if (!hasColorTransform)
	{
		return color * openfl_Alphav;
	}
	color = vec4(color.rgb / color.a, color.a);
	mat4 colorMultiplier = mat4(0);
	colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
	colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
	colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
	colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
	color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
	if (color.a > 0.0)
	{
		return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	}
	return vec4(0.0, 0.0, 0.0, 0.0);
}

// variables which is empty, they need just to avoid crashing shader
uniform float iTimeDelta;
uniform float iFrameRate;
uniform int iFrame;
#define iChannelTime float[4](iTime, 0., 0., 0.)
#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
uniform vec4 iMouse;
uniform vec4 iDate;

#define _SnowflakeAmount 200    // Number of snowflakes
#define _BlizardFactor 0.2        // Fury of the storm !
#define _SnowflakeAlpha 0.09

float rnd(float x) {
    return fract(sin(dot(vec2(x+47.49,38.2467/(x+2.3)), vec2(12.9898, 78.233)))* (43758.5453));
}

float drawCircle(vec2 uv, float radius)
{
    return 1.0 - smoothstep(0.0, radius, length(uv));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    fragColor = texture(iChannel0, uv);
    float j;
    
    for(int i=0; i<_SnowflakeAmount; i++)
    {
        j = float(i);
        float speed = 0.3+rnd(cos(j))*(0.7+0.5*cos(j/(float(_SnowflakeAmount)*0.25)));
        vec2 center = vec2((0.25-uv.y)*_BlizardFactor+rnd(j)+0.1*cos(iTime+sin(j)), mod(sin(j)-speed*(iTime*1.5*(0.1+_BlizardFactor)), 1.));
        fragColor += vec4(_SnowflakeAlpha*drawCircle(uv - center, 0.001+speed*0.012));
    }
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}
		')
	public function new()
	{
		super();
		iTime.value = [0.0];
	}

	public function update(elapsed:Float)
	{
		iTime.value[0] += elapsed;
	}
}
