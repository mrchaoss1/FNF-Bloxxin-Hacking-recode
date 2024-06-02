package shaders;

import flixel.system.FlxAssets.FlxShader;

class VhsShader extends FlxShader
{
	@:glFragmentSource('
	#pragma header

uniform float iTime;

float onOff(float a, float b, float c) {
    return step(c, sin(iTime + a*cos(iTime*b)));
}

vec2 getUV(vec2 uv) {
    vec2 look = uv;
    float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,1.)));
    look.x = look.x + sin(look.y*10. + iTime)/50.*onOff(4.,4.,.3)*(1.+cos(iTime*80.))*window;
    float vShift = 0.4*onOff(2.,3.,.9) * (sin(iTime)*sin(iTime*20.) + (0.5 + 0.1*sin(iTime*200.)*cos(iTime)));
    look.y = mod(look.y + vShift, 1.);
    return look;
}

void main() {
    gl_FragColor = flixel_texture2D(bitmap, getUV(openfl_TextureCoordv));
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
