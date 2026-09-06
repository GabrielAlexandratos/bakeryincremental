package storefront;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import logic.Economy;
import upgrades.Upgrades;

enum CustomerState
{
    Entering;
    Paying;
    Leaving;
}

class Customer extends FlxSprite
{
    public static inline var WIDTH = 24;
    public static inline var HEIGHT = 48;
    
    static inline var WALK_SPEED = 220;
    static inline var WALK_DISTANCE = 420;
    static inline var PAY_TIME = 0.3;

	static inline var REPEAT_DELAY = 0.2;

    static inline var FLASH_TIME = 0.14;
    static inline var FLASH_STRETCH = 0.3;
    static inline var FLASH_SQUEEZE = 0.12;
    static inline var FLASH_HOP = 4;

    var counterX = 0.0;
    var ticket = 0.0;
    var onPay:(Float, Float, Float)->Void = null;
    var state = Leaving;
    var payTimer = 0.0;
	var payDelay = 0.0;
	var purchases = 1;


    var tint = FlxColor.WHITE;
    var baseY = 0.0;
    var flashTimer = 0.0;

    public function new()
    {
        super();
        makeGraphic(WIDTH, HEIGHT, FlxColor.WHITE);
    }

    public function start(counterX:Float, y:Float, ticket:Float, onPay:(Float, Float, Float)->Void)
    {
        this.counterX = counterX;
        this.ticket = ticket;
        this.onPay = onPay;

        state = Entering;
        payTimer = 0;
		payDelay = PAY_TIME;
		purchases = FlxG.random.bool(Upgrades.familyMeal.chance * 100) ? 2 : 1;

        tint = FlxColor.fromHSB(FlxG.random.float(0, 360), 0.35, 0.95);
        color = tint;

        flashTimer = 0;
        baseY = y;

        setPosition(counterX - WALK_DISTANCE, y);
        velocity.x = WALK_SPEED;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        switch (state)
        {
            case Entering:
                if (x >= counterX)
                {
                    x = counterX;
                    velocity.x = 0;
                    state = Paying;
                }

            case Paying:
                payTimer += elapsed;
                if (payTimer >= PAY_TIME)
                {
                    Economy.earn(ticket);
                    onPay(x + WIDTH / 2, y, ticket);
                    flashTimer = FLASH_TIME;
					purchases--;

					if (purchases > 0)
					{
						payTimer = 0;
						payDelay = REPEAT_DELAY;
					}
					else
					{
						velocity.x = WALK_SPEED;
						state = Leaving;
					}
                }

            case Leaving:
                if (x > counterX + WALK_DISTANCE)
                    kill();
        }

        updateFlash(elapsed);
    }

    function updateFlash(elapsed:Float)
    {
        if (flashTimer <= 0)
            return;

        flashTimer -= elapsed;

        var t = flashTimer / FLASH_TIME;
        if (t < 0)
            t = 0;

        color = FlxColor.interpolate(tint, FlxColor.WHITE, t * t);
        y = baseY - FLASH_HOP * Math.sin(t * Math.PI);
    }

}