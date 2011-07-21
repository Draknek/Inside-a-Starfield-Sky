package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;

	public class InfoText extends Entity 
	{
		private var info:Text;
		
		public function InfoText()
		{
			graphic = info = new Text("", 0, 0);
			info.size = 20;
		}
		
		
		public function UpdatePlayer(player:int):void
		{
			info.text = "Player " + (player + 1) + "'s turn.";
			info.color = Main.color(player);
		}
		
		public function Winner(player:int):void
		{
			info.text = "Player " + (player + 1) + " wins!";
			info.color = 0xFFFFFF;
		}
	}

}