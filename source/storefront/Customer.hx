package storefront;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import logic.Economy;
import logic.Tills;
import upgrades.Upgrades;

enum CustomerState
{
    Entering;
	Waiting;
    Paying;
    Leaving;
}

class Customer extends FlxSprite
{
	public static inline var WIDTH = 15;
	public static inline var HEIGHT = 45;
    
    static inline var WALK_SPEED = 220;
    static inline var WALK_DISTANCE = 420;
    static inline var PAY_TIME = 0.3;

	static inline var REPEAT_DELAY = 0.2;

	static inline var FLASH_TIME = 0.21;
	static inline var FLASH_STRETCH = 0.1;
    static inline var FLASH_SQUEEZE = 0.12;
    static inline var FLASH_HOP = 4;

	var purchaseSpinAngle = 0;

	// step animation
	static inline var STEP_RATE = 10.0;
	static inline var SWAY = 1.5;
	static inline var BOB = 2.0;
	static inline var LEAN = 4.0;
	static inline var SQUASH = 0.06;

	// shadow vars
	static inline var shadowWidth = 45;
	static inline var shadowHeight = 14;
	static inline var shadowAlpha = 0.22;

    var counterX = 0.0;
	var stopX = 0.0;

	static inline var STOP_SPREAD = 22.0;

	var hasTill = false;
    var ticket = 0.0;
    var onPay:(Float, Float, Float)->Void = null;
    var state = Leaving;
    var payTimer = 0.0;
	var payDelay = 0.0;
	var purchases = 1;

    var tint = FlxColor.WHITE;
    var baseY = 0.0;
	var offsetY = 0.0;
    var flashTimer = 0.0;
	var walkTimer = 0.0;
	var walkBlend = 0.0;
	var baseOffsetX = 0.0;
	var baseOffsetY = 0.0;

	// shadow
	var customerShadow = new FlxSprite();


    public function new()
    {
        super();
		loadGraphic(AssetPaths.customer__png);
		scale.set(2, 2);
		updateHitbox();

		// pin origin to the feet of the sprite
		origin.set(frameWidth / 2, frameHeight);
		offset.y -= frameHeight * (scale.y - 1) / 2;

		baseOffsetX = offset.x;
		baseOffsetY = offset.y;

		customerShadow.makeGraphic(shadowWidth, shadowHeight, FlxColor.TRANSPARENT, false, 'customershadow');
		FlxSpriteUtil.drawEllipse(customerShadow, 0, 0, shadowWidth, shadowHeight, FlxColor.BLACK);
		customerShadow.alpha = shadowAlpha;
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
		offsetY = y + (FlxG.random.int(-85, -20));
		purchaseSpinAngle = FlxG.random.int(-10, 10);

		stopX = counterX + FlxG.random.float(-STOP_SPREAD, STOP_SPREAD);
		hasTill = false;

		setPosition(counterX - (WALK_DISTANCE - FlxG.random.int(-10, 10)), offsetY);
        velocity.x = WALK_SPEED;
		// slight randomness in step animation
		walkTimer = FlxG.random.float(0, Math.PI * 2);
		walkBlend = 0;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        switch (state)
        {
            case Entering:
				if (x >= stopX)
                {
					x = stopX;
                    velocity.x = 0;
					state = Waiting;
				}

			case Waiting:
				if (Tills.claim())
				{
					hasTill = true;
					payTimer = 0;
					payDelay = PAY_TIME;
                    state = Paying;
                }

            case Paying:
                payTimer += elapsed;
				if (payTimer >= payDelay)
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
						releaseTill();
						velocity.x = WALK_SPEED;
						state = Leaving;
					}
                }

            case Leaving:
                if (x > counterX + WALK_DISTANCE)
                    kill();
        }

		updateVisuals(elapsed);
	}

	function releaseTill()
	{
		if (hasTill)
		{
			hasTill = false;
			Tills.release();
		}
	}

	override public function kill()
	{
		releaseTill();
		super.kill();
	}

	function updateVisuals(elapsed:Float)
	{
		// flash fires on each purchase and automatically fades out over FLASH_TIME
		var flash = 0.0;

		if (flashTimer > 0)
		{
			flashTimer -= elapsed;

			var t = flashTimer / FLASH_TIME;
			if (t < 0)
				t = 0;

			color = FlxColor.interpolate(tint, FlxColor.WHITE, t * t);
			flash = Math.sin(t * Math.PI);
		}

		// step cycle - one full cycle is two steps
		var moving = velocity.x != 0;

		if (moving)
			walkTimer += elapsed * STEP_RATE;

		walkBlend += ((moving ? 1.0 : 0.0) - walkBlend) * Math.min(1, elapsed * 12);

		var sway = Math.sin(walkTimer) * walkBlend;
		var lift = Math.abs(Math.cos(walkTimer)) * walkBlend;

		// body - the walk cycle and the purchase pop share one scale
		var step = SQUASH * (lift * 2 - 1) * walkBlend;
		var stretch = step + FLASH_STRETCH * flash;
		var squeeze = -step - FLASH_SQUEEZE * flash;

		offset.x = baseOffsetX - SWAY * sway;
		offset.y = baseOffsetY + BOB * lift + FLASH_HOP * flash;
		angle = LEAN * sway;
		scale.set(2 * (1 + squeeze), 2 * (1 + stretch));
		angle += purchaseSpinAngle * flash;

		// shadow shrinks as customer hops
		var shrink = 1 - 0.15 * lift;
		customerShadow.scale.set(shrink, shrink);
		customerShadow.alpha = shadowAlpha * (1 - 0.1 * lift);
		customerShadow.setPosition(x + width / 2 - shadowWidth / 2 - SWAY * sway * 0.4, y + height - shadowHeight / 2);
	}

	override public function draw()
	{
		customerShadow.cameras = cameras;
		customerShadow.draw();
		super.draw();
    }

}