package ingredients;

import flixel.util.FlxColor;

typedef IngredientType =
{
    var name:String;
    var color:FlxColor;
    var price:Int;

    /** Optional art. Falls back to a flat circle of `color` when null. */
    var ?image:String;
}