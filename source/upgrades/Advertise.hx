package upgrades;

class Advertise extends Upgrade
{
    static inline var START_INTERVAL = 1.5;
    static inline var MIN_INTERVAL = 0.12;
    static inline var STEP = 0.88;

    public var autoSpawn(default, null) = false;

    public var spawnInterval(default, null) = START_INTERVAL;

    public function new()
    {
        super("Advertise", AssetPaths.megaphone_icon__png, 25, 1.35);
    }

    override public function maxed():Bool
    {
        return autoSpawn && spawnInterval <= MIN_INTERVAL;
    }

    override function apply()
    {
        if (!autoSpawn)
            autoSpawn = true;
        else 
            spawnInterval = Math.max(MIN_INTERVAL, spawnInterval * STEP);
    }

    override public function reset()
    {
        super.reset();
        autoSpawn = true;
        spawnInterval = START_INTERVAL;
    }
}