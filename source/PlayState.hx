package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import fx.Coin;
import fx.MoneyPopup;
import ingredients.Ingredient;
import ingredients.IngredientType;
import logic.Economy;
import shop.ShopMenu;
import storefront.Customer;
import storefront.SignGuy;
import storefront.ui.UpgradeBar;
import upgrades.Upgrades;

class PlayState extends FlxState
{
	static inline var CAKE_RADIUS = 210;

	/** Margin between a screen-anchored UI sprite and the screen edge. */
	static inline var UI_PAD = 12;

	/** Seconds the camera takes to slide from one screen to the next. */
	static inline var PAN_TIME = 0.4;

	/** How many coins spray out of a single payment. */
	static inline var COINS_PER_PAYMENT = 4;

	// customer spawn interval
	static inline var SPAWN_INTERVAL = 1.5;

	var cake:FlxSprite;
	var ingredients:FlxTypedGroup<Ingredient>;

	var arrowRight:FlxSprite;
	var arrowLeft:FlxSprite;

	var signguy:SignGuy;
	var customers:FlxTypedGroup<Customer>;
	var popups:FlxTypedGroup<MoneyPopup>;
	var coins:FlxTypedGroup<Coin>;
	var hudCoin:FlxSprite;
	var spawnTimer = 0.0;
	var moneyText:FlxText;

	/** Which screen the camera is showing. 0 is the bakery. */
	var currentScreen = 0;
	var panning = false;

	override public function create()
	{
		super.create();

		Economy.reset();
		Upgrades.reset();

		bgColor = 0xFF1C1C1C;

		FlxG.mouse.load(AssetPaths.rollingPin__png);

		cake = new FlxSprite();
		cake.makeGraphic(420, 420, FlxColor.TRANSPARENT);
		cake.screenCenter(Y);
		cake.x = ShopMenu.WIDTH + (FlxG.width - ShopMenu.WIDTH - cake.width) / 2;
		FlxSpriteUtil.drawCircle(cake, -1, -1, -1, FlxColor.WHITE);
		add(cake);

		ingredients = new FlxTypedGroup<Ingredient>();
		add(ingredients);

		add(new ShopMenu(0, 0, buy));

		arrowRight = addArrow(0, true);
		arrowLeft = addArrow(1, false);

		customers = new FlxTypedGroup<Customer>();
		add(customers);

		signguy = new SignGuy(FlxG.width + 100, FlxG.height - 220 + Customer.HEIGHT - SignGuy.HEIGHT, spawnCustomer);
		add(signguy);

		popups = new FlxTypedGroup<MoneyPopup>();
		add(popups);

		hudCoin = new FlxSprite(FlxG.width - 90, UI_PAD - 6, AssetPaths.jerryCoin__png);
		hudCoin.scrollFactor.set(0, 0);
		add(hudCoin);

		add(new UpgradeBar());

		var coin = new FlxSprite(FlxG.width - 90, UI_PAD - 6, AssetPaths.jerryCoin__png);
		coin.scrollFactor.set(0, 0);
		add(coin);

		moneyText = new FlxText(FlxG.width - 55, UI_PAD, 0, "0", 16);
		moneyText.scrollFactor.set(0, 0);
		add(moneyText);

		coins = new FlxTypedGroup<Coin>();
		add(coins);
	}

	function spawnCustomer()
	{
		customers.recycle(Customer).start(FlxG.width * 1.5, FlxG.height - 220, Upgrades.priceHike.ticket, popMoney);
	}

	function popMoney(x:Float, y:Float, amount:Float)
	{
		popups.recycle(MoneyPopup).start(x, y, amount);

		var screenX = x - FlxG.camera.scroll.x;
		var screenY = y - FlxG.camera.scroll.y;
		var targetX = hudCoin.x + hudCoin.width / 2;
		var targetY = hudCoin.y + hudCoin.height / 2;

		for (i in 0...COINS_PER_PAYMENT)
			coins.recycle(Coin).start(screenX, screenY, targetX, targetY);
	}

	/** Puts an arrow in a bottom corner of the given screen, pointing out of it. */
	function addArrow(screenIndex:Int, pointsRight:Bool):FlxSprite
	{
		var arrow = new FlxSprite(0, 0, AssetPaths.arrow__png);
		arrow.flipX = !pointsRight;

		var screenLeft = screenIndex * FlxG.width;
		var x = pointsRight ? screenLeft + FlxG.width - arrow.width - UI_PAD : screenLeft + UI_PAD;
		arrow.setPosition(x, (FlxG.height - arrow.height) / 2);

		add(arrow);
		return arrow;
	}

	/** Slides the camera to the given screen. */
	function goToScreen(screenIndex:Int)
	{
		currentScreen = screenIndex;
		panning = true;

		FlxTween.num(FlxG.camera.scroll.x, screenIndex * FlxG.width, PAN_TIME,
			{ease: FlxEase.quadInOut, onComplete: onPanComplete}, setCameraX);
	}

	function setCameraX(value:Float)
	{
		FlxG.camera.scroll.x = value;
	}

	function onPanComplete(_:FlxTween)
	{
		panning = false;
	}

	function buy(type:IngredientType)
	{
		var reach = CAKE_RADIUS - Ingredient.RADIUS;
		var dist = reach * Math.sqrt(FlxG.random.float());
		var angle = FlxG.random.float(0, Math.PI * 2);

		var px = cake.x + cake.width / 2 + Math.cos(angle) * dist;
		var py = cake.y + cake.height / 2 + Math.sin(angle) * dist;

		ingredients.add(Ingredient.of(px - Ingredient.RADIUS, py - Ingredient.RADIUS, type));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		moneyText.text = "$" + Std.int(Economy.money);

		if (Upgrades.advertise.autoSpawn)
		{
			spawnTimer += elapsed;
			while (spawnTimer >= Upgrades.advertise.spawnInterval)
			{
				spawnTimer -= Upgrades.advertise.spawnInterval;
				spawnCustomer();
			}
		}

		if (FlxG.mouse.justPressed && !panning)
		{
			if (currentScreen == 0 && FlxG.mouse.overlaps(arrowRight))
				goToScreen(1);
			else if (currentScreen == 1 && FlxG.mouse.overlaps(arrowLeft))
				goToScreen(0);
		}

		if (FlxG.keys.justPressed.I)
		{
			var mouse = FlxG.mouse.getWorldPosition();
			add(Ingredient.random(mouse.x - Ingredient.RADIUS, mouse.y - Ingredient.RADIUS));
			mouse.put();
		}
	}
}
