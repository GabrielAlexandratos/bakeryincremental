package storefront.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import logic.Economy;
import logic.Upgrade;

class UpgradeCard extends FlxSpriteGroup
{
    public static inline var WIDTH = 110;
    public static inline var HEIGHT = 92;
    
    static inline var ICON = 32;
    static inline var PLATE_TINT = 0xFF3B3B44;
    static inline var DIMMED = 0.45;

    var upgrade:Upgrade;
    var costText:FlxText;

    public function new(upgrade:Upgrade)
    {
        super();
        this.upgrade = upgrade;
        directAlpha = true;

        var plate = new FlxSprite();
        plate.makeGraphic(WIDTH, HEIGHT, FlxColor.WHITE);
        plate.color = PLATE_TINT;
        add(plate);

        var art = new FlxSprite(0, 0, upgrade.icon);
        art.setGraphicSize(ICON, ICON);
        art.updateHitbox();
        art.setPosition((WIDTH - art.width) / 2, 8);
        add(art);

        var label = new FlxText(0, 46, WIDTH, upgrade.name.toUpperCase(), 10);
        label.alignment = CENTER;
        add(label);

        costText = new FlxText(0, 64, WIDTH, "", 12);
        costText.alignment = CENTER;
        add(costText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var cost = upgrade.cost();
        var affordable = Economy.money >= cost;

        costText.text = "$" + Std.int(cost);
        alpha = affordable ? 1.0 : DIMMED;

        if (affordable && FlxG.mouse.justPressed && FlxG.mouse.overlaps(this))
            upgrade.buy();
    }
}