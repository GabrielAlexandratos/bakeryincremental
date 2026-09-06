package storefront.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Tab extends FlxSpriteGroup
{
    static inline var ICON = 28;

    static inline var IDLE_TINT = 0xFF3B3B44;
    static inline var SELECTED_TINT = 0xFF8F8F99;

    public var index(default, null):Int;

    var plate:FlxSprite;

    public function new(index:Int, icon:String)
    {
        super();
        this.index = index;

        plate = new FlxSprite();
        plate.makeGraphic(UpgradeBar.TAB_SIZE, UpgradeBar.TAB_SIZE, FlxColor.WHITE);
        add(plate);

        var art = new FlxSprite(0, 0, icon);
        art.setGraphicSize(ICON, ICON);
        art.updateHitbox();
        art.setPosition((UpgradeBar.TAB_SIZE - art.width) / 2, (UpgradeBar.TAB_SIZE - art.height) / 2);
        add(art);
    }

    public function setSelected(selected:Bool)
    {
        plate.color = selected ? SELECTED_TINT : IDLE_TINT;
    }
}