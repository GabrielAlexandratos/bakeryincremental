package upgrades;

class ExtraTill extends Upgrade
{
    static inline var startingTillsCount = 1;
    static inline var maxTillsCount = 3;

    public var tills(default, null) = startingTillsCount;

    public function new()
    {
        super("Extra Till", AssetPaths.missingImage__png, 60, 1.6);
    }

    override public function maxed():Bool
    {
        return tills >= maxTillsCount;
    }

    override function apply()
    {
        tills++;
    }

    override public function reset()
    {
        super.reset();
        tills = startingTillsCount;
    }
}