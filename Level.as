package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		//[Embed(source="images/bg.png")] public static const BgGfx: Class;
		
		public function Level ()
		{
			for (var starsx:int = 0; starsx < 9; starsx++)
			{
				for (var starsy:int = 0; starsy < 9; starsy++)
				{
					if (FP.rand(5) < 4)
					{
						add(new Star(50 + (FP.rand(30) - 15) + (starsx * 65), 50 + (FP.rand(30) - 15) + (starsy * 45)));
					}
				}
			}
		}
		
		public override function update (): void
		{
			super.update();
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

