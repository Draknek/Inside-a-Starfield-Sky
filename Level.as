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
			var LeftStars:Array = [];
			var RightStars:Array = [];
			var TopStars:Array = [];
			var BottomStars:Array = [];
			
			for (var starsx:int = 0; starsx < 9; starsx++)
			{
				for (var starsy:int = 0; starsy < 9; starsy++)
				{
					var newstar:Star = new Star(50 + (FP.rand(30) - 15) + (starsx * 65), 50 + (FP.rand(30) - 15) + (starsy * 45));
					
					if (FP.rand(5) < 4) {
						if (starsx == 0) {
							LeftStars.push(newstar);
						}
						else if (starsx == 8) {
							RightStars.push(newstar);
						}
						
						if (starsy == 0) {
							TopStars.push(newstar);
						}
						else if (starsy == 8) {
							BottomStars.push(newstar);
						}
						
						add(newstar);
					}
				}
			}
			
			
			
			var stars:int;
			
			trace("Building LeftStar lines...");
			
			for (stars = 0; stars < LeftStars.length - 1; stars++) {
				add(new Line(0, LeftStars[stars], LeftStars[stars + 1]));
			}
			
			trace("Building RightStar lines...");
			
			for (stars = 0; stars < RightStars.length - 1; stars++) {
				add(new Line(0, RightStars[stars], RightStars[stars + 1]));
			}
			
			trace("Building TopStar lines...");
			
			for (stars = 0; stars < TopStars.length - 1; stars++) {
				add(new Line(1, TopStars[stars], TopStars[stars + 1]));
			}
			
			trace("Building BottomStar lines...");
			
			for (stars = 0; stars < BottomStars.length - 1; stars++) {
				add(new Line(1, BottomStars[stars], BottomStars[stars + 1]));
			}
			
			trace("Connection check...");
			
			if (LeftStars[0].IsConnectedTo(0, LeftStars[2])) {
				trace("Is Connected!");
			}
			else {
				trace("Isn't connected.");
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
			
			return nearStar;
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

