package shaders;

import flixel.system.FlxAssets.FlxShader;

class AsciiShader extends FlxShader
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
	
	float ASCII_Details = 12.0; 
	float PixelSize = 6.5;
	
	float character(float n, vec2 p)
	{
		p = floor(p*vec2(4.0, -4.0) + 2.5);
		if (clamp(p.x, 0.0, 4.0) == p.x && clamp(p.y, 0.0, 4.0) == p.y
		 && int(mod(n/exp2(p.x + 5.0*p.y), 2.0)) == 1) return 1.0;
		return 0.0;
	}
	
	void mainImage( out vec4 fragColor, in vec2 fragCoord )
	{
		vec2 uv = fragCoord.xy;
		vec3 col = texture(iChannel0, floor(uv / ASCII_Details) * ASCII_Details / iResolution.xy).rgb;	
		
		float n = 65536.0 + 
				  step(0.2, col.r) * 64.0 + 
				  step(0.3, col.r) * 267172.0 +
				  step(0.4, col.r) * 14922314.0 + 
				  step(0.5, col.r) * 8130078.0 - 
				  step(0.6, col.r) * 8133150.0 - 
				  step(0.7, col.r) * 2052562.0 -
				  step(0.8, col.r) * 1686642.0;
			
		vec2 p = mod(uv / PixelSize, 2.0) - vec2(1.0);
		if (iMouse.z > 0.5)	col = col * vec3(character(n, p));
		else col = col * vec3(character(n, p));
		
		fragColor = vec4(col, texture(iChannel0, uv).a);
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
