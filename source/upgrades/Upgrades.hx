package upgrades;

class Upgrades
{
    public static var advertise = new Advertise();
    public static var priceHike = new PriceHike();
    public static var familyMeal = new FamilyMeal();

    public static var all:Array<Upgrade> = [advertise, priceHike, familyMeal];

    public static function reset()
    {
        for (upgrade in all)
            upgrade.reset();
    }
}