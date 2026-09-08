package storefront.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import logic.Economy;
import upgrades.Upgrade;
import upgrades.Upgrades;

class UpgradeBar extends FlxSpriteGroup
{
    public static inline var HEIGHT = 116;

    // tab buttons
    public static inline var TAB_SIZE = 44;

    static inline var FILL = 0xFF1B1B22;
    static inline var EDGE = 0xFF3B3B44;
    static inline var EDGE_HEIGHT = 3;

    static inline var TAB_PAD = 16;
    static inline var TAB_GAP = 6;
    static inline var TAB_RAISE = 5;

    static inline var CARD_PAD = 16;
    static inline var CARD_GAP = 8;

    public var selectedTab(default, null) = 0;

    var tabs:Array<Tab> = [];
    var cards:Array<UpgradeCard> = [];

    public function new()
    {
        super(FlxG.width, FlxG.height - HEIGHT);

        var panel = new FlxSprite();
        panel.makeGraphic(FlxG.width, HEIGHT, FILL);
        add(panel);

        var edge = new FlxSprite();
        edge.makeGraphic(FlxG.width, EDGE_HEIGHT, EDGE);
        add(edge);

		addTab(AssetPaths.missingImage__png);
		addTab(AssetPaths.missingImage__png);
		addTab(AssetPaths.missingImage__png);

		for (upgrade in Upgrades.all)
			addCard(upgrade);

        selectTab(0);
    }

    function addTab(icon:String)
    {
        var tab = new Tab(tabs.length, icon);
        tabs.push(tab);
        add(tab);
    }

    public function selectTab(index:Int)
    {
        selectedTab = index;

        for (tab in tabs)
        {
            var selected = tab.index == index;
            tab.setSelected(selected);

            tab.x = x + TAB_PAD + tab.index * (TAB_SIZE + TAB_GAP);
            tab.y = y + EDGE_HEIGHT - TAB_SIZE - (selected ? TAB_RAISE : 0);
        }
    }

    function addCard(upgrade:Upgrade)
    {
        var card = new UpgradeCard(upgrade);
        add(card);

        card.x = x + CARD_PAD + cards.length * (UpgradeCard.WIDTH + CARD_GAP);
        card.y = y + (HEIGHT - UpgradeCard.HEIGHT) / 2;

        cards.push(card);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (!FlxG.mouse.justPressed)
            return;

        for (tab in tabs)
        {
            if (FlxG.mouse.overlaps(tab))
                selectTab(tab.index);
        }
    }
}