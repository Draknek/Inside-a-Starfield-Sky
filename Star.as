package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author 
	 */
	public class Star extends Entity 
	{
		[Embed(source = 'star.png')]
		private const StarImage:Class;
		
		public function Star(xPosition:int, yPosition:int) 
		{
			x = xPosition;
			y = yPosition;
			
			graphic = new Image(StarImage);
		}
		
		override public function update():void
		{
			
		}
	}

}