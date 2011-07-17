package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author 
	 */
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
			
		}
		
		public function IsConnectedTo(player:int, destination:Star):Boolean
		{
			if (destination == this) {
				return true;
			}
			
			var CheckedStars:Array = [];
			
			CheckedStars.push(this);
			
			if (CheckStarConnections(player, this, destination)) {
				return true;
			}
			
			/*for (var l:int; l < lines.length; l++) {
				if (lines[l].star1 == this) {
					if (CheckedStars.indexOf(lines[l].star2) == -1)
					{
						if (lines[l].star2.NestedIsConnectedTo(CheckedStars, player, destination))
						{
							return true;
						}
						CheckedStars.push(lines[l].star2);
					}
				}
				else
				{
					if (CheckedStars.indexOf(lines[l].star1) == -1)
					{
						if (lines[l].star1.NestedIsConnectedTo(CheckedStars, player, destination))
						{
							return true;
						}
						CheckedStars.push(lines[l].star1);
					}
				}
			} */
			
			return NestedIsConnectedTo(CheckedStars, player, destination);
		}
		
		public function NestedIsConnectedTo(checkedstars:Array, player:int, destination:Star):Boolean
		{
			if (CheckStarConnections(player, this, destination)) {
				return true;
			}
			
			for (var l:int; l < lines.length; l++) {
				if (lines[l].star1 == this) {
					if (checkedstars.indexOf(lines[l].star2) == -1)
					{
						checkedstars.push(lines[l].star2);
						if (lines[l].star2.NestedIsConnectedTo(checkedstars, player, destination))
						{
							return true;
						}
					}
				}
				else
				{
					if (checkedstars.indexOf(lines[l].star1) == -1)
					{
						checkedstars.push(lines[l].star1);
						if (lines[l].star1.NestedIsConnectedTo(checkedstars, player, destination))
						{
							return true;
						}
					}
				}
			}
			
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
