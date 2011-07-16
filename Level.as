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
		
		//var StarGrid:Array;
		
		public function Level ()
		{
			nearStar = new Entity(320, 240);
			
			//StarGrid = new Array();
			
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
			if (Input.mousePressed) {
				activeLine = new Line(activePlayer, nearStar, null);
			} else if (Input.mouseDown) {
			
			} else if (Input.mouseReleased) {
				activeLine = null
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

