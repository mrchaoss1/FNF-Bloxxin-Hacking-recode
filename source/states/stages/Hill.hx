package states.stages;

import objects.HealthIcon;
import FlxTransWindow;
import backend.*;

import openfl.filters.ShaderFilter;
import states.stages.objects.*;
import states.*;
import objects.Character;

import shaders.AsciiShader;
import shaders.PixelShader;
import shaders.VhsShader;
import shaders.ColorShader;
import shaders.DigitShader;
import shaders.ShakeShader;

import haxe.io.Path;
import openfl.Lib;
import lime.app.Application;

class Hill extends BaseStage {

    var bg1:BGSprite = new BGSprite('hill/hill', -200, 0, 0.9, 0.9);
    var flash:BGSprite = new BGSprite('hill/Flash', -200, 0, 0.9, 0.9);

    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(1, 1, 1));

    var shader1:AsciiShader;
    var shader2:PixelShader;
    var shader3:VhsShader;
    var shader4:DigitShader;
    var shader5:ShakeShader;

    var beating:Bool = false;

    override function create() {

        // canPause = false;

        Application.current.window.width = 1280;
        Application.current.window.height = 720;
        
        shader1 = new AsciiShader();
        shader2 = new PixelShader();
        shader3 = new VhsShader();
        shader4 = new DigitShader();
        shader5 = new ShakeShader();

        flash.alpha = 1;
        flash.screenCenter();
        flash.camera = camOther;

        Application.current.window.borderless = false;
        Application.current.window.mouseLock = false;

        add(bg1);
        add(flash);

        // CHARACTERS

        game.addCharacterToList('hack', dad);

        Lib.application.window.title = 'Roblox Player';
    }

    override function stepHit() {

        // beating = false;

        // game.currentFPS.alpha = 0;

        game.healthBar.visible = false;
        game.iconP1.alpha = 0;
        game.iconP2.alpha = 0;
        game.scoreTxt.alpha = 0;
        game.timeTxt.alpha = 0;
        game.timeBar.visible = false;

        boyfriend.alpha = 0;

        Application.current.window.x = Std.int((Application.current.window.display.bounds.width - Application.current.window.width) / 2);
        Application.current.window.y = Std.int((Application.current.window.display.bounds.height - Application.current.window.height) / 2);      

        if (curStep == 1)
            {
                FlxTween.tween(flash, {alpha: 0}, 6);
            }
        if (curStep == 767)
            {   
                Application.current.window.borderless = true;
                Application.current.window.mouseLock = true;
                FlxTween.tween(Application.current.window, {width: 1919, height: 1079}, 1.2, {ease: FlxEase.quartInOut});
            }
        if (curStep == 768 || curStep == 775 || curStep == 782 || curStep == 792)
            {
                bg1.shader = shader1;
            }
        if (curStep == 769 || curStep == 778 || curStep == 787 || curStep == 795)
            {
                bg1.shader = shader2;
            }
        if (curStep == 799)
            {
                bg1.shader = null;
                Application.current.window.fullscreen = false;
            }
        if (curStep == 800)
            {

            FlxTransWindow.getWindowsTransparent();

            if (defaultCamZoom < 1)
                {
                  bg.scale.scale(1 / defaultCamZoom);
                }
                bg.scrollFactor.set();

                addBehindDad(bg);

            }
        if (curStep == 1824)
            {
                FlxTween.tween(Application.current.window, {width: 1, height: 1}, 4.5, {ease: FlxEase.quartInOut});
            }
    }

    override function update(elapsed:Float) {

        game.moveCamera(true);

    }

    function onEndSong()
        {
            Application.current.window.width = 1280;
            Application.current.window.height = 720;
            
            Application.current.window.borderless = false;
            Application.current.window.mouseLock = false;
        }

}