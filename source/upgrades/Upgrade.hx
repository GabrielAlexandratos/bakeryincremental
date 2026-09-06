package upgrades;

import logic.Economy;

class Upgrade
{
    public var name(default, null):String;
    public var icon(default, null):String;
    public var level(default, null) = 0;

    var baseCost:Float;
    var costGrowth:Float;

    public function new(name:String, icon:String, baseCost:Float, costGrowth:Float)
    {
        this.name = name;
        this.icon = icon;
        this.baseCost = baseCost;
        this.costGrowth = costGrowth;
    }

    public function cost():Float
    {
        return Math.fceil(baseCost * Math.pow(costGrowth, level));
    }

    public function maxed():Bool
    {
        return false;
    }

    public function buy():Bool
    {
        if (maxed() || !Economy.spend(cost()))
            return false;

        level++;
        apply();
        return true;
    }

    function apply() {}

    public function reset()
    {
        level = 0;
    }
}