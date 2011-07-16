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
		
		public var lines:Array = [];
		
		public var image:Image;
		
		public function Star(xPosition:int, yPosition:int) 
		{
			x = xPosition;
			y = yPosition;
			
			graphic = image = new Image(StarImage);
			
			type = "star";
			
			image.centerOO();
		}
		
		override public function update():void
		{
			
		}
	}

}
