package upgrades;

class Upgrades
{
    public static var advertise = new Advertise();
    public static var priceHike = new PriceHike();
    public static var familyMeal = new FamilyMeal();
	public static var extraTill = new ExtraTill();

	public static var all:Array<Upgrade> = [advertise, priceHike, familyMeal, extraTill];

    public static function reset()
    {
        for (upgrade in all)
            upgrade.reset();
    }
}