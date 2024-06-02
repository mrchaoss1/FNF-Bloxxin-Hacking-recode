package shaders;

import flixel.system.FlxAssets.FlxShader;

class ColorShader extends FlxShader
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
    
    void mainImage(out vec4 fragColor, in vec2 fragCoord)
    {
        // Calculate aberration amount based on mouse position
        float aberrationAmount = 0.1 + abs(iMouse.y / iResolution.y / 8.0);
    
        // Normalize fragment coordinates to [0, 1]
        vec2 uv = fragCoord.xy / iResolution.xy;
    
        // Calculate distance from the center
        vec2 distFromCenter = uv - 0.5;
    
        // Apply aberration by raising to power 3 for stronger effect near edges
        vec2 aberrated = aberrationAmount * pow(distFromCenter, vec2(3.0));
    
        // Define offsets for each color channel
        vec2 redOffset = vec2(0.0015);
        vec2 greenOffset = vec2(0.0015); // No offset for green channel
        vec2 blueOffset = vec2(-0.0015);
    
        // Sample the texture with aberration for each color channel
        vec3 redChannel = texture(iChannel0, clamp(uv - redOffset, 0.0, 1.0)).rgb;
        vec3 greenChannel = texture(iChannel0, clamp(uv + greenOffset, 0.0, 1.0)).rgb;
        vec3 blueChannel = texture(iChannel0, clamp(uv - blueOffset, 0.0, 1.0)).rgb;
    
        // Combine the color channels
        fragColor = vec4(redChannel.r, greenChannel.g, blueChannel.b, texture(iChannel0, uv).a);
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
