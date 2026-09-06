package shop;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/** The round corner badge on a shop card, showing an item's price. */
class PriceBadge extends FlxSpriteGroup
{
    public static inline var SIZE = 33;
    public static inline var FILL = 0xFFE03B3B;

    public function new(x:Float, y:Float, price:Int, fill:FlxColor = FILL)
    {
        super(x, y);

        add(new FlxSprite(0, 0, AssetPaths.exclamationBadge__png));
    }
}
