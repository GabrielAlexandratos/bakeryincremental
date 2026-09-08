package upgrades;

class FamilyMeal extends Upgrade
{
    static inline var STEP = 0.04;
    static inline var MAX_CHANCE = 0.6;

    public var chance(default, null) = 0.0;

    public function new()
    {
		super("Family meal", AssetPaths.missingImage__png, 40, 1.5);
    }

    override public function maxed():Bool
    {
        return chance >= MAX_CHANCE;
    }

    override function apply()
    {
        chance = Math.min(MAX_CHANCE, chance + STEP);
    }

    override public function reset()
    {
        super.reset();
        chance = 0;
    }
}