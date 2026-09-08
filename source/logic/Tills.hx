package logic;

import upgrades.Upgrades;

class Tills
{
    static var busy = 0;

    public static function tillsCount():Int
    {
        return Upgrades.extraTill.tills;
    }

    public static function claim():Bool
    {
        if (busy >= tillsCount())
            return false;

        busy ++;
        return true;
    }

    public static function release()
    {
        if (busy > 0)
            busy--;
    }

    public static function reset()
    {
        busy = 0;
    }
}