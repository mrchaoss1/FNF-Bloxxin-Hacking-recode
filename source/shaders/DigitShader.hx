package shaders;

import flixel.system.FlxAssets.FlxShader;

class DigitShader extends FlxShader
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
    
    /*
     Bad analog television reception fragment shader
     Bastiaan de Waard
     defcon8
    */
    
    #define noiselevel 0.4
    #define rgbshiftlevel 0.01
    #define ghostreflectionlevel 0.03
    #define bypass false
    
    float rand(vec2 co){
        return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
    }
    
    void mainImage( out vec4 fragColor, in vec2 fragCoord )
    {
        vec2 uv = fragCoord.xy / iResolution.xy;
        
        float randomValue = rand(vec2(uv.x+sin(iTime), uv.y+cos(iTime)));
        float rgbShift = sin(iTime+randomValue)*rgbshiftlevel;
        
        if(randomValue > 0.95-ghostreflectionlevel)
            uv.x+=sin(iTime/5.0)*0.5;
       
        uv.y += (cos(iTime*randomValue)+0.5) * (randomValue*0.01);
        
        float colorr = texture(iChannel0, vec2(uv.x+rgbShift, uv.y)).r;
        float colorg = texture(iChannel0, vec2(uv.x, uv.y)).g;
        float colorb = texture(iChannel0, vec2(uv.x-rgbShift, uv.y)).b;
        
          vec4 movieColor = vec4(colorr,colorg,colorb, 1.0);
        vec4 noiseColor = vec4(randomValue,randomValue,randomValue,1.0);
     
        if(randomValue > 0.55-ghostreflectionlevel)
            noiseColor = abs(noiseColor - 0.2);
     
        if(bypass)
            fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy); 
        else
              fragColor = mix(movieColor, noiseColor, noiselevel);  
        
        
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
