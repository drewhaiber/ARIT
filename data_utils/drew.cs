	public static double det(double a, double b, double c, double d){
		return (a*d) - (b*c);
	}
	
	public static bool ccw(double ax, double ay, double bx, double by, double cx, double cy){
		return (cy-ay)*(bx-ax) > (by-ay) * (cx-ax);
	}
	
	public static bool doesIntersect(double ax, double ay, double bx, double by, double cx, double cy, double dx, double dy){
		return (ccw(ax, ay, cx, cy, dx, dy) != ccw(bx, by, cx, cy, dx, dy)) &&  (ccw(ax, ay, bx, by, cx, cy) != ccw(ax, ay, bx, by, dx, dy));
	}
	
	public static double[] intersect(double l1sx, double l1sy, double l1ex, double l1ey, double l2sx, double l2sy, double l2ex, double l2ey){
		double dl1 = det(l1sx, l1sy, l1ex, l1ey);
		double dl2 = det(l2sx, l2sy, l2ex, l2ey);
		double denom = det(l1sx - l1ex,  l2sx - l2ex, l1sy - l1ey, l2sy - l2ey);
		double x = det(dl1, dl2, l1sx - l1ex,  l2sx - l2ex);
		double y = det(dl1, dl2, l1sy - l1ey,  l2sy - l2ey);
		double[] toReturn = new double[2];
		toReturn[0] = x/denom;
		toReturn[1] = y/denom;
		return toReturn;
	}