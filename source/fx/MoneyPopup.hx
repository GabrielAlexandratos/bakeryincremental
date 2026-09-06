package fx;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

class MoneyPopup extends FlxText
{
    static inline var RISE_AMOUNT = 46; // pixels

    static inline var LIFETIME = 0.8; // seconds

    static inline var HORIZONTAL_SPREAD = 30;
    static inline var HORIZONTAL_DRIFT = 40;

    static inline var TINT = 0xFF7CE07C;

    var age = 0.0;
    var startX = 0.0;
    var startY = 0.0;
    var driftX = 0.0;

    public function new()
    {
        super(0, 0, 0, "", 14);
        setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        color = TINT;
    }

    public function start(x:Float, y:Float, amount:Float)
    {
        text = "+$" + Std.int(amount);

        age = 0;
        alpha = 1;

        startX = x - width / 2 + FlxG.random.float(-HORIZONTAL_SPREAD, HORIZONTAL_SPREAD);
        startY = y;
        driftX = FlxG.random.float(-HORIZONTAL_DRIFT, HORIZONTAL_DRIFT);

        setPosition(startX, startY);

    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        age += elapsed;

        if (age >= LIFETIME)
        {
            kill();
            return;
        }

        var t = age / LIFETIME;
        setPosition(startX + driftX * t, startY - RISE_AMOUNT * FlxEase.quadOut(t));
        alpha = 1 - t * t;
    }
}