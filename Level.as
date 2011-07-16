package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		//[Embed(source="images/bg.png")] public static const BgGfx: Class;
		
		public var activePlayer:int = 0;
		
		public var activeLine:Line;
		
		public var drawing:Boolean = false;
		
		public function Level ()
		{
			var spacing:Number = 40;
			
			for (var starsx:int = 0; starsx < 10; starsx++)
			{
				for (var starsy:int = 0; starsy < 10; starsy++)
				{
					if (FP.rand(5) < 4)
					{
						add(new Star(20 + (FP.rand(16) - 8) + (starsx * spacing), 20 + (FP.rand(16) - 8) + (starsy * spacing)));
					}
				}
			}
		}
		
		public override function update (): void
		{
			var nearStar:Star = getNearStar();
			
			if (nearStar && Input.mousePressed) {
				activeLine = new Line(activePlayer, nearStar, null);
			} else if (activeLine && Input.mouseReleased) {
				if (nearStar) {
					activeLine.star2 = nearStar;
				
					if (validLine()) {
						activeLine.star1.lines.push(activeLine);
						activeLine.star2.lines.push(activeLine);
						
						add(activeLine);
					
						activePlayer = int(!activePlayer);
					}
				}
				
				activeLine = null;
			}
			
			if (activeLine) {
				activeLine.update();
			}
			
			super.update();
		}
		
		private function getNearStar (): Star
		{
			var nearStar:Star = nearestToPoint("star", mouseX, mouseY) as Star;
			
			var dist:Number = FP.distance(nearStar.x, nearStar.y, mouseX, mouseY);
			
			if (dist > 12) return null;
			
			var starPlayer:int = nearStar.getPlayer();
			
			if (starPlayer == -1 || starPlayer == activePlayer) {
				return nearStar;
			} else {
				return null;
			}
		}
		
		private function validLine ():Boolean
		{
			activeLine.update();
			
			if (activeLine.star1 == activeLine.star2) {
				return false;
			}
			
			var lines:Array = [];
			
			getType("line", lines);
			
			for each (var l:Line in lines) {
				if (l.star1 == activeLine.star1 && l.star2 == activeLine.star2) return false;
				if (l.star1 == activeLine.star2 && l.star2 == activeLine.star1) return false;
				
				if (l.intersects(activeLine)) {
					return false;
				}
			}
			
			return true;
		}
		
		public override function render (): void
		{
			super.render();
			
			var nearStar:Star = getNearStar();
			
			if (nearStar) Draw.circlePlus(nearStar.x, nearStar.y, 7, 0x00FF00, 0.75, false);
			
			if (activeLine) {
				if (nearStar) {
					activeLine.star2 = nearStar;
					activeLine.valid = validLine();
				} else {
					activeLine.valid = false;
				}
				
				activeLine.star2 = null;
				activeLine.updatePosition();
				activeLine.render();
			}
		}
	}
}

