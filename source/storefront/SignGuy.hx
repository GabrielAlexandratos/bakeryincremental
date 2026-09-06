package storefront;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class SignGuy extends FlxSprite
{
    public static inline var WIDTH = 28;
    public static inline var HEIGHT = 56;

    static inline var COOLDOWN = 0.1;

    static inline var POP = 0.14;

    static inline var TINT = 0xFFE8C36B;

    var onCall:Void->Void;
    var cooldown = 0.0;

    public function new(x:Float, y:Float, onCall:Void->Void)
    {
        super(x, y);
        this.onCall = onCall;

        makeGraphic(WIDTH, HEIGHT, FlxColor.WHITE, false, 'signguy');
        color = TINT;

        origin.set(WIDTH / 2, HEIGHT);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (cooldown > 0)
            cooldown -= elapsed;
        else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this))
        {
            cooldown = COOLDOWN;
            onCall();
        }

        var t = cooldown > 0 ? cooldown / COOLDOWN : 0;
        scale.set(1 + POP * t, 1- POP * t);
    }
}