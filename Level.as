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
		
		public var nearStar:Entity;
		public var activeLine:Line;
		
		public function Level ()
		{
			nearStar = new Entity(320, 240);
			var LeftStars:Array = [];
			var TopStars:Array = [];
			var BottomStars:Array = [];
			var RightStars:Array = [];
			
			for (var starsx:int = 0; starsx < 9; starsx++) {
				for (var starsy:int = 0; starsy < 9; starsy++) {
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
			
			for (stars = 0; stars < LeftStars.length - 1; stars++) {
				add(new Line(0, LeftStars[stars], LeftStars[stars + 1]));
			}
			
			for (stars = 0; stars < RightStars.length - 1; stars++) {
				add(new Line(0, RightStars[stars], RightStars[stars + 1]));
			}
			
			for (stars = 0; stars < TopStars.length - 1; stars++) {
				add(new Line(1, TopStars[stars], TopStars[stars + 1]));
			}
			
			for (stars = 0; stars < BottomStars.length - 1; stars++) {
				add(new Line(1, BottomStars[stars], BottomStars[stars + 1]));
			}
		}
		
		public override function update (): void
		{
			if (Input.mousePressed) {
				activeLine = new Line(activePlayer, nearStar, null);
			} else if (Input.mouseDown) {
			
			} else if (Input.mouseReleased) {
				activeLine = null
			}
			
			if (activeLine) {
				activeLine.update();
			}
			
			super.update();
		}
		
		public override function render (): void
		{
			super.render();
			
			if (activeLine) {
				activeLine.render();
			}
		}
	}
}

