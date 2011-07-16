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
			for (var starsx:int = 0; starsx < 10; starsx++)
			{
				for (var starsy:int = 0; starsy < 10; starsy++)
				{
					if (FP.rand(5) < 4)
					{
						add(new Star(20 + (FP.rand(16) - 8) + (starsx * 60), 20 + (FP.rand(16) - 8) + (starsy * 40)));
					}
				}
			}
		}
		
		public override function update (): void
		{
			var nearStar:Star = nearestToPoint("star", mouseX, mouseY) as Star;
			
			if (Input.mousePressed) {
				activeLine = new Line(activePlayer, nearStar, null);
			} else if (activeLine && Input.mouseReleased) {
				if (activeLine.star1 != nearStar) {
					activeLine.star2 = nearStar;
					add(activeLine);
					
					activePlayer = int(!activePlayer);
				}
				
				activeLine = null;
			}
			
			if (activeLine) {
				activeLine.update();
			}
			
			super.update();
		}
		
		public override function render (): void
		{
			super.render();
			
			var nearStar:Star = nearestToPoint("star", mouseX, mouseY) as Star;
			
			Draw.circlePlus(nearStar.x, nearStar.y, 7, 0x00FF00, 0.75, false);
			
			if (activeLine) {
				activeLine.render();
			}
		}
	}
}

