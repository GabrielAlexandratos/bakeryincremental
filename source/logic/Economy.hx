package logic;

class Economy
{
    public static var money(default, null):Float = 0;

    public static function earn(amount:Float)
    {
        money += amount;
    }

    public static function spend(amount:Float):Bool
    {
        if (money < amount)
            return false;

        money -= amount;
        return true;
    }

    public static function reset()
    {
		money = 0;
    }
}