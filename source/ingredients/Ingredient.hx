package ingredients;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;

class Ingredient extends FlxSprite
{
    public static inline var RADIUS = 32;

    public static final TYPES:Array<IngredientType> = [
        {name: "strawberry", color: 0xFFFF5656, price: 2, image: AssetPaths.strawberry__png},
        {name: "blueberry", color: 0xFF397BFF, price: 3 },
        {name: "chocolate", color: 0xFF150804, price: 5}
    ];

    static var held:Ingredient = null;

    public var ingredientName(default, null):String;

    var grabOffset:FlxPoint = FlxPoint.get();
    var mousePos:FlxPoint = FlxPoint.get();

    public static function of(x:Float, y:Float, type:IngredientType):Ingredient
    {
        return new Ingredient(x, y, type);
    }

    public static function random(x:Float, y:Float):Ingredient
    {
        return of(x, y, FlxG.random.getObject(TYPES));
    }
    
    public function new(x:Float, y:Float, type:IngredientType)
    {
        super(x, y);
        this.ingredientName = type.name;
        angle = FlxG.random.float(0, 360);

        if (type.image != null)
        {
            loadGraphic(type.image);
            setGraphicSize(RADIUS * 2, RADIUS * 2);
            updateHitbox();
        }
        else
        {
            makeGraphic(RADIUS * 2, RADIUS * 2, FlxColor.TRANSPARENT, false, 'ingredient-${type.name}');
            FlxSpriteUtil.drawCircle(this, -1, -1, -1, type.color);
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        FlxG.mouse.getWorldPosition(camera, mousePos);

        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this))
        {
            held = this;
            grabOffset.set(x - mousePos.x, y - mousePos.y);
        }

        if (held == this)
        {
            if (FlxG.mouse.pressed)
                setPosition(mousePos.x + grabOffset.x, mousePos.y + grabOffset.y);
            else
                held = null;
        }
    }

    override public function destroy()
    {
        if (held == this)
            held = null;

        grabOffset = FlxDestroyUtil.put(grabOffset);
        mousePos = FlxDestroyUtil.put(mousePos);

        super.destroy();
    }
}
