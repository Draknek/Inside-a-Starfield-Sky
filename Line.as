package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	public class Line extends Entity
	{
		public var x1: Number;
		public var y1: Number;
		public var x2: Number;
		public var y2: Number;
		
		public var player:int;
		
		public var isStarter:Boolean = false;
		public var valid:Boolean = true;
				
		public var star1:Star;
		public var star2:Star;
		
		public static const MAX_LENGTH:Number = 75;
		
		public function Line (p:int, _star1:Star, _star2:Star)
		{
			player = p;
			star1 = _star1;
			star2 = _star2;
			updatePosition();
			
			type = "line";
		}
		
		public override function update ():void
		{
			updatePosition();
		}
		
		public override function render ():void
		{
			var color:uint = Main.color(player);
			
			if (! valid) {
				color = 0xAAAAAA;
			}
			
			Draw.linePlus(x1, y1, x2, y2, color, 1, isStarter ? 4 : 2);
		}
		
		public function updatePosition():void
		{
			x1 = star1.x;
			y1 = star1.y;
			
			if (star2) {
				x2 = star2.x;
				y2 = star2.y;
			} else {
				x2 = FP.world.mouseX;
				y2 = FP.world.mouseY;
			}
		}
		
		public function intersects (cd: Line): Boolean
		{
			var ab:Line = this;
			
			// Sign of areas correspond to which side of ab points c and d are
			var a1: Number = Signed2DTriArea(ab.x1, ab.y1, ab.x2, ab.y2, cd.x2, cd.y2); // Compute winding of abd (+ or -)
			var a2: Number = Signed2DTriArea(ab.x1, ab.y1, ab.x2, ab.y2, cd.x1, cd.y1); // To intersect, must have sign opposite of a1

			// If c and d are on different sides of ab, areas have different signs
			if (a1 != 0.0 && a2 != 0.0 && a1*a2 < 0.0) {
				// Compute signs for a and b with respect to segment cd
				var a3: Number = Signed2DTriArea(cd.x1, cd.y1, cd.x2, cd.y2, ab.x1, ab.y1); // Compute winding of cda (+ or -)
				// Since area is constant a1-a2 = a3-a4, or a4=a3+a2-a1
				//      float a4 = Signed2DTriArea(c, d, b); // Must have opposite sign of a3
				var a4: Number = a3 + a2 - a1;
				// Points a and b on different sides of cd if areas have different signs
				if (a3 * a4 < 0.0) {
					return true;
				}
			}

			// Segments not intersecting (or collinear)
			return false;
		}

		// Returns 2 times the signed triangle area. The result is positive if
		// abc is ccw, negative if abc is cw, zero if abc is degenerate.
		private static function Signed2DTriArea(ax: Number, ay: Number, bx: Number, by: Number, cx: Number, cy: Number): Number
		{
		return (ax - cx) * (by - cy) - (ay - cy) * (bx - cx);
		}
	}
	
}
