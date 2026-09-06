package logic;

class Economy
{
    public static var money(default, null):Float = 0;

    public static var customerSpawnInterval(default, null):Float = 1.5;
    public static var customerFlowLevel(default, null):Int = 0;

    public static var ticket(default, null):Int = 1;
    public static var ticketLevel(default, null):Int = 0;

    static inline var CUSTOMER_FLOW_BASE_COST = 10.0;
    static inline var CUSTOMER_FLOW_COST_GROWTH = 1.35;
    static inline var CUSTOMER_FLOW_STEP = 0.88;
    static inline var MIN_INTERVAL = 0.12;

    static inline var TICKET_BASE_COST = 20.0;
    static inline var TICKET_COST_GROWTH = 1.35;
    static inline var TICKET_STEP = 1.25;

    public static var customerFlowCost(get, never):Float;
    static function get_customerFlowCost():Float
    {
        return Math.fceil(CUSTOMER_FLOW_BASE_COST * Math.pow(CUSTOMER_FLOW_COST_GROWTH, customerFlowLevel));
    }

    public static var ticketCost(get, never):Float;
    static function get_ticketCost():Float
    {
        return Math.fceil(TICKET_BASE_COST * Math.pow(TICKET_COST_GROWTH, ticketLevel));
    }

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

    public static function buyFlow():Bool
    {
        if (!spend(customerFlowCost))
            return false;

        customerFlowLevel++;
        customerSpawnInterval = Math.max(MIN_INTERVAL, customerSpawnInterval * CUSTOMER_FLOW_STEP);
        return true;
    }

    public static function buyTicket():Bool
    {
        if (!spend(ticketCost))
            return false;

        ticketLevel++;
        ticket = Math.ceil(ticket * TICKET_STEP);
        return true;
    }

    public static function reset()
    {
        money = 0;
        customerSpawnInterval = 1.5;
        customerFlowLevel = 0;
        ticket = 1;
        ticketLevel = 0;
    }
}