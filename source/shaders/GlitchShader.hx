package shaders;

import flixel.system.FlxAssets.FlxShader;

class GlitchShader extends FlxShader
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
    
    // Set to 0.0 to stop animation.
    // Only integer numbers with float format, or else the animation cuts!
    float scanSpeedAdd = 6.0;
    
    // Change this value to change scanline size (> = smaller lines).
    float lineCut = 0.1;
    
    float whiteIntensity = 0.8;
    float anaglyphIntensity = 0.5;
    
    // Anaglyph colors.
    vec3 col_r = vec3(0.0, 1.0, 1.0);
    vec3 col_l = vec3(1.0, 0.0, 0.0);
    
    
    void mainImage( out vec4 fragColor, in vec2 fragCoord )
    {
        // Normalized pixel coordinates (from 0 to 1).
        vec2 uv = fragCoord/iResolution.xy;
        vec2 uv_right = vec2(uv.x + 0.01, uv.y + 0.01);
        vec2 uv_left = vec2(uv.x - 0.01, uv.y - 0.01);
    
        // Black screen.
        vec3 col = vec3(0.0);
        
        // Measure speed.
        float scanSpeed = (fract(iTime) * 2.5 / 40.0) * scanSpeedAdd;
        
        // Remove scanlines.
        //vec3 scanlines = vec3(1.0) * abs(cos((uv.y + scanSpeed) * 100.0)) - lineCut;
        //vec3 scanlines_right = col_r * abs(cos((uv_right.y + scanSpeed) * 100.0)) - lineCut;
        //vec3 scanlines_left = col_l * abs(cos((uv_left.y + scanSpeed) * 100.0)) - lineCut;
        
        // Smoothstep to blend colors.
        col = smoothstep(0.1, 0.7, vec3(0.0) * whiteIntensity)
            + smoothstep(0.1, 0.7, vec3(0.0) * anaglyphIntensity)
            + smoothstep(0.1, 0.7, vec3(0.0) * anaglyphIntensity);
        
        vec2 eyefishuv = (uv - 0.5) * 2.5;
        float deform = (1.0 - eyefishuv.y*eyefishuv.y) * 0.02 * eyefishuv.x;
        //deform = 0.0;
        
        // Add texture to visualize better the effect.
        vec4 texture1 = texture(iChannel0, vec2(uv.x - deform*0.95, uv.y));
        
        // Add vignette effect.
        float bottomRight = pow(uv.x, uv.y * 100.0);
        float bottomLeft = pow(1.0 - uv.x, uv.y * 100.0);
        float topRight = pow(uv.x, (1.0 - uv.y) * 100.0);
        float topLeft = pow(uv.y, uv.x * 100.0);
        
        float screenForm = bottomRight
            + bottomLeft
            + topRight
            + topLeft;
    
        // Invert screenForm color.
        vec3 col2 = 1.0-vec3(screenForm);
        
        // Output to screen.
        // Invert last 0.1 and 1.0 positions for image processing.
        fragColor = texture1 + vec4((smoothstep(0.1, 0.9, col) * 0.1), 1.0);
        fragColor = vec4(fragColor.rgb * col2, texture(iChannel0, uv).a);
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
