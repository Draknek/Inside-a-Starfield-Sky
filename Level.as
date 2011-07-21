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
		public var winningPlayer:int = -1;
		
		public var lastLine:Line;
		public var activeLine:Line;
		
		public var drawing:Boolean = false;
		
		public var playerStart:Array = [];
		public var playerEnd:Array = [];
		
		public var info:InfoText;
		
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
					if ((starsx == 0 || starsx == 8) && (starsy == 0 || starsy == 8)) continue;
					
					var newstar:Star = new Star(50 + (FP.rand(30) - 15) + (starsx * 45), 50 + (FP.rand(30) - 15) + (starsy * 45));
					
					var mustUse:Boolean = false;
				
					if (starsx == 0) {
						LeftStars.push(newstar);
						mustUse = true;
					}
					else if (starsx == 8) {
						RightStars.push(newstar);
						mustUse = true;
					}
					
					if (starsy == 0) {
						TopStars.push(newstar);
						mustUse = true;
					}
					else if (starsy == 8) {
						BottomStars.push(newstar);
						mustUse = true;
					}
					
					if (mustUse || FP.rand(5) < 4) {
						add(newstar);
					}
				}
			}
			
			playerStart[0] = LeftStars[0]; // Player 1 start / end stars.
			playerEnd[0] = RightStars[0];
			playerStart[1] = TopStars[0]; // Player 2 start / end stars.
			playerEnd[1] = BottomStars[0];
			
			var stars:int;
			
			for (stars = 0; stars < LeftStars.length - 1; stars++) {
				connectStarter(LeftStars[stars], LeftStars[stars + 1], 0);
			}
			
			for (stars = 0; stars < RightStars.length - 1; stars++) {
				connectStarter(RightStars[stars], RightStars[stars + 1], 0);
			}
			
			for (stars = 0; stars < TopStars.length - 1; stars++) {
				connectStarter(TopStars[stars], TopStars[stars + 1], 1);
			}
			
			for (stars = 0; stars < BottomStars.length - 1; stars++) {
				connectStarter(BottomStars[stars], BottomStars[stars + 1], 1);
			}
			
			info = new InfoText();
			add(info);
			info.UpdatePlayer(activePlayer);
		}
		
		public function connectStarter (a:Star, b:Star, player:int):void
		{
			var l:Line = new Line(player, a, b);
			l.isStarter = true;
			
			add(l);
			a.lines.push(l);
			b.lines.push(l);
			
			a.isStarter = true;
			b.isStarter = true;
		}
		
		public override function update (): void
		{
			var nearStar:Star = getNearStar();
			
			if (nearStar && Input.mousePressed) {
				activeLine = new Line(activePlayer, nearStar, null);
			} else if (activeLine && Input.mouseReleased) {
				if (nearStar) {
					activeLine.star2 = nearStar;
				
					if (validLine() && winningPlayer == -1) {
						if (nearStar.getPlayer() != activePlayer) {
							nearStar.removeAllLines();
						}
						
						activeLine.star1.lines.push(activeLine);
						activeLine.star2.lines.push(activeLine);
						
						lastLine = activeLine;
						
						add(activeLine);
						
						var connectedstars:Array;
						
						if ((connectedstars = playerStart[activePlayer].IsConnectedTo(activePlayer, playerEnd[activePlayer])) != null)
						{
							winningPlayer = activePlayer;
							//trace("Player " + activePlayer + " wins!");
							info.Winner(activePlayer);
							
							for (var star:int = 0; star < connectedstars.length - 1; ++star)
							{
								connectStarter(connectedstars[star], connectedstars[star + 1], winningPlayer);
							}
						}
						else
						{
							info.UpdatePlayer(int(!activePlayer));
						}
					
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
			
			if (activeLine && FP.distance(nearStar.x, nearStar.y, activeLine.star1.x, activeLine.star1.y) > Line.MAX_LENGTH) return null;
			
			if (starPlayer == -1 || starPlayer == activePlayer) {
				return nearStar;
			} else if (activeLine) {
				if (nearStar.isStarter) return null;
				
				if (nearStar.getPower() >= activeLine.star1.getPower()) return null;
				
				if (lastLine && (lastLine.star1 == nearStar || lastLine.star2 == nearStar)) return null;
				
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
			
			if (nearStar) {
				Draw.circlePlus(nearStar.x, nearStar.y, 7, 0x00FF00, 0.75, false);
			}
			
			if (activeLine || nearStar) {
				var center:Entity = activeLine ? activeLine.star1 : nearStar;
				Draw.circlePlus(center.x, center.y, Line.MAX_LENGTH, 0xFFFFFF, 0.25, false);
			}
			
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

