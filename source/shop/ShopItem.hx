package shop;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import ingredients.Ingredient;
import ingredients.IngredientType;

class ShopItem extends FlxSpriteGroup
{
    public static inline var WIDTH = 195;
    public static inline var HEIGHT = 90;

    static inline var PAD = 4;
    static inline var ART = 64;
    static inline var ICON = 40;
    static inline var ROW_GAP = 1;

    /** How far the corner badge overhangs the card's top-right corner. */
    static inline var BADGE_OVERHANG = 10;

    // DRAWING CARD WITH FLXSPRITE
    // static inline var CARD_FILL = 0xFF8F8F99;
    // static inline var CARD_EDGE = 0xFF2B2B33;
    static inline var ART_FILL = 0xFF3B3B44;

    public var type(default, null):IngredientType;
    var onBuy:IngredientType->Void;

    public function new(x:Float, y:Float, type:IngredientType, onBuy:IngredientType->Void, level = 1, isMax = false)
    {
        super(x, y);
        this.type = type;
        this.onBuy = onBuy;

        // DRAWING CARD WITH FLXSPRITE

        // var card = new FlxSprite();
        // card.makeGraphic(WIDTH, HEIGHT, FlxColor.TRANSPARENT, false, 'shop-card');
        // FlxSpriteUtil.drawRoundRect(card, 2, 2, WIDTH - 4, HEIGHT - 4, 16, 16, CARD_FILL, {color: CARD_EDGE, thickness: 4});
        // add(card);

        add(new FlxSprite(0, 0, AssetPaths.shopItemBox__png));

        // Art block, left.
        var artY = (HEIGHT - ART) / 2;

        var artPanel = new FlxSprite(PAD, artY);
        artPanel.makeGraphic(ART, ART, FlxColor.TRANSPARENT, false, 'shop-art-panel');
        FlxSpriteUtil.drawRoundRect(artPanel, 0, 0, ART, ART, 12, 12, ART_FILL);
        add(artPanel);

        var icon = new FlxSprite();
        if (type.image != null)
        {
            icon.loadGraphic(type.image);
            icon.setGraphicSize(ICON, ICON);
            icon.updateHitbox();
        }
        else
        {
            icon.makeGraphic(ICON, ICON, FlxColor.TRANSPARENT, false, 'shop-icon-${type.name}');
            FlxSpriteUtil.drawCircle(icon, -1, -1, -1, type.color);
        }
        icon.setPosition(PAD + (ART - icon.width) / 2, artY + (ART - icon.height) / 2);
        add(icon);

        // Label pills, right.
        var textX = PAD * 2 + ART;
        var rowY = 10.0;

        var name = new Pill(textX, rowY, type.name, 12);
        add(name);

        if (isMax)
            add(new Pill(textX + name.width + ROW_GAP, rowY, "MAX!", 12));

        rowY += name.height + ROW_GAP;

        var levelPill = new Pill(textX, rowY, 'LEVEL $level', 12);
        add(levelPill);

        rowY += levelPill.height + ROW_GAP;

        add(new Pill(textX, rowY, "COST: $" + type.price, 12));

        // Corner badge.
        add(new PriceBadge(WIDTH - PriceBadge.SIZE + BADGE_OVERHANG, -BADGE_OVERHANG, type.price));
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this))
            onBuy(type);
    }
}
