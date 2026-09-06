package upgrades;

class PriceHike extends Upgrade
{
    static inline var START_TICKET = 1;
    static inline var STEP = 1.25;

    public var ticket(default, null) = START_TICKET;

    public function new()
    {
        super("Price Hike", AssetPaths.cash_icon__png, 20, 1.35);
    }

    override function apply()
    {
        ticket = Math.ceil(ticket * STEP);
    }

    override public function reset()
    {
        super.reset();
        ticket = START_TICKET;
    }

}