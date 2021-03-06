package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	
	public class Star extends Entity 
	{
		[Embed(source = 'star.png')]
		private const StarImage:Class;
		
		public var lines:Array = [];
		
		public var image:Image;
		
		public var isStarter:Boolean = false;
		
		public function Star(xPosition:int, yPosition:int) 
		{
			x = xPosition;
			y = yPosition;
			
			graphic = image = new Image(StarImage);
			
			type = "star";
			
			image.centerOO();
		}
		
		public function getPlayer ():int
		{
			if (lines.length) {
				return lines[0].player;
			} else {
				return -1;
			}
		}
		
		public function getPower ():int
		{
			return lines.length;
		}
		
		public function removeAllLines ():void
		{
			for each (var l:Line in lines) {
				if (l.star1 == this) FP.remove(l.star2.lines, l);
				if (l.star2 == this) FP.remove(l.star1.lines, l);
				l.world.remove(l);
			}
			
			lines.length = 0;
		}
		
		override public function update():void
		{
			image.color = 0xFFFFFF;
			
			var checkLine:Line = Level(world).lastLine;
			
			if (checkLine && (checkLine.star1 == this || checkLine.star2 == this)) {
				image.color = 0x808080;
			}
		}
		
		public function IsConnectedTo(player:int, destination:Star):Array
		{
			var usedStars:Array = [];
			var checkedStars:Array = [ this ];
			
			if (destination == this) {
				return usedStars;
			}
			
			if (CheckStarConnections(player, this, destination)) {
				usedStars.push(this);
				return usedStars;
			}
			
			if (NestedIsConnectedTo(checkedStars, usedStars, player, destination))
			{
				usedStars.push(this);
				return usedStars;
			}
			
			return null;
		}
		
		private function NestedIsConnectedTo(checkedstars:Array, usedstars:Array, player:int, destination:Star):Boolean
		{
			if (CheckStarConnections(player, this, destination)) {
				checkedstars.push(destination);
				//usedstars.push(this);
				return true;
			}
			
			for (var l:int; l < lines.length; l++) {
				if (lines[l].star1 == this) {
					if (checkedstars.indexOf(lines[l].star2) == -1)
					{
						checkedstars.push(lines[l].star2);
						if (lines[l].star2.NestedIsConnectedTo(checkedstars, usedstars, player, destination))
						{
							usedstars.push(this);
							//usedstars.push(destination);
							return true;
						}
					}
				}
				else
				{
					if (checkedstars.indexOf(lines[l].star1) == -1)
					{
						checkedstars.push(lines[l].star1);
						if (lines[l].star1.NestedIsConnectedTo(checkedstars, usedstars, player, destination))
						{
							usedstars.push(this);
							//usedstars.push(destination);
							return true;
						}
					}
				}
			}
			
			usedstars.pop();
			
			return false;
		}
		
		private function CheckStarConnections(player:int, source:Star, destination:Star):Boolean
		{
			for (var l:int; l < lines.length; l++) {
				if ((source.lines[l].star1 == destination || source.lines[l].star2 == destination) && source.lines[l].player == player)
				{
					return true;
				}
			}
			
			return false;
		}
	}

}
