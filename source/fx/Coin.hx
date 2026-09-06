package fx;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;

/**
 * A coin that shoots out of a payment, then sweeps along a curve onto the money
 * counter. It lives in screen space, so panning to another screen mid-flight
 * can't drag it off course.
 */
class Coin extends FlxSprite
{
    static inline var BURST_SPEED_MIN = 160;
    static inline var BURST_SPEED_MAX = 320;

    /** Slows the initial kick so the coin visibly hangs before the curve takes over. */
    static inline var BURST_DRAG = 600;

    /** Seconds of free physics flight before the curve is laid out. */
    static inline var FREE_FLIGHT = 0.12;

    /**
     * How far the curve bows away from the straight line, as a fraction of the
     * distance left to travel. The path bulges by half this much at its widest,
     * so 0.7 over a 480px trip swings about 170px wide.
     */
    static inline var CURVE_STRENGTH = 0.25;

    /** Pixels per second along the trip, used to pick a duration. */
    static inline var TRAVEL_SPEED = 1150;

    /** Shortest a trip may take, so close-range coins don't snap instantly. */
    static inline var MIN_TRAVEL = 0.22;

    var age = 0.0;
    var targetX = 0.0;
    var targetY = 0.0;

    var curving = false;
    var curveAge = 0.0;
    var curveTime = 0.0;

    /** Start and control point of the quadratic curve; the counter is the end. */
    var fromX = 0.0;
    var fromY = 0.0;
    var controlX = 0.0;
    var controlY = 0.0;

    public function new()
    {
        super(0, 0, AssetPaths.smallCoin__png);
        scrollFactor.set(0, 0);
    }

    /** Both points are screen-space centres. */
    public function start(fromX:Float, fromY:Float, toX:Float, toY:Float)
    {
        targetX = toX;
        targetY = toY;

        age = 0;
        alpha = 1;

        curving = false;
        curveAge = 0;

        setPosition(fromX - width / 2, fromY - height / 2);

        var dir = FlxG.random.float(0, Math.PI * 2);
        var speed = FlxG.random.float(BURST_SPEED_MIN, BURST_SPEED_MAX);
        velocity.set(Math.cos(dir) * speed, Math.sin(dir) * speed);

        drag.set(BURST_DRAG, BURST_DRAG);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        age += elapsed;

        if (!curving)
        {
            if (age < FREE_FLIGHT)
                return;

            beginCurve();
        }

        curveAge += elapsed;

        var u = curveAge / curveTime;

        if (u >= 1)
        {
            kill();
            return;
        }

        // Accelerate into the counter rather than arriving at a constant crawl.
        var t = FlxEase.quadIn(u);
        var inv = 1 - t;

        // Quadratic Bezier. Steering can't produce this shape: any controller
        // that converges is pointing straight at the target by the time it has
        // covered much ground, so the long leg always comes out flat. Laying the
        // whole path down in advance keeps the bow all the way to the counter.
        setPosition(inv * inv * fromX + 2 * inv * t * controlX + t * t * targetX - width / 2,
            inv * inv * fromY + 2 * inv * t * controlY + t * t * targetY - height / 2);
    }

    /** Fixes the curve from wherever the burst left the coin. */
    function beginCurve()
    {
        curving = true;
        curveAge = 0;

        fromX = x + width / 2;
        fromY = y + height / 2;

        var chordX = targetX - fromX;
        var chordY = targetY - fromY;
        var distance = Math.sqrt(chordX * chordX + chordY * chordY);

        if (distance < 1)
            distance = 1;

        // Unit perpendicular to the chord, flipped to whichever side the coin is
        // already drifting, so the curve flows out of the burst instead of
        // fighting it.
        var perpX = -chordY / distance;
        var perpY = chordX / distance;

        if (velocity.x * perpX + velocity.y * perpY < 0)
        {
            perpX = -perpX;
            perpY = -perpY;
        }

        var bulge = distance * CURVE_STRENGTH;
        controlX = fromX + chordX / 2 + perpX * bulge;
        controlY = fromY + chordY / 2 + perpY * bulge;

        curveTime = distance / TRAVEL_SPEED;

        if (curveTime < MIN_TRAVEL)
            curveTime = MIN_TRAVEL;

        // The curve drives position directly from here on.
        velocity.set(0, 0);
        drag.set(0, 0);
    }
}
