package shop;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ingredients.Ingredient;
import ingredients.IngredientType;

class ShopMenu extends FlxSpriteGroup
{
    static inline var PAD = 12;

    public static inline var WIDTH = ShopItem.WIDTH + PAD * 2;

    public function new(x:Float, y:Float, onBuy:IngredientType->Void)
    {
        super(x, y);

        var panel = new FlxSprite();
        panel.makeGraphic(WIDTH, FlxG.height, 0xFF24242D, false, 'shop-panel');
        add(panel);

        var header = new FlxText(0, PAD, WIDTH, "TOPPINGS", 16);
        header.alignment = CENTER;
        add(header);

        var itemY = PAD + 28;

        for (type in Ingredient.TYPES)
        {
            add(new ShopItem(PAD, itemY, type, onBuy));
            itemY += ShopItem.HEIGHT + PAD;
        }
    }
}