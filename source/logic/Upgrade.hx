package logic;

typedef Upgrade = 
{
    var name:String;
    var icon:String;
    var cost:Void->Float;
    var buy:Void->Bool;
}