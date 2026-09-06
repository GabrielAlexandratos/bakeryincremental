package shop;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/** A rounded dark badge that sizes itself to its own text. */
class Pill extends FlxSpriteGroup
{
    public static inline var FILL = 0xFF3B3B44;

    static inline var PAD_X = 7;
    static inline var PAD_Y = 3;

    public function new(x:Float, y:Float, text:String, size = 12, fill:FlxColor = FILL)
    {
        super(x, y);

        var label = new FlxText(0, 0, 0, text.toUpperCase(), size);
        label.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

        var w = Std.int(label.width) + PAD_X * 2;
        var h = Std.int(label.height) + PAD_Y * 2;

        var bg = new FlxSprite();
        bg.makeGraphic(w, h, FlxColor.TRANSPARENT, false, 'pill-${w}x${h}-${fill.toHexString()}');
        FlxSpriteUtil.drawRoundRect(bg, 0, 0, w, h, 10, 10, fill);
        add(bg);

        label.setPosition(PAD_X, PAD_Y);
        add(label);
    }
}
