module lib.ray;
import lib.vec;
import std.conv;

class Ray {
    static immutable eps = 1e-4;
    P origin;
    N direction;

    private this(P origin, N direction, bool do_shift) nothrow {
        this.origin = do_shift?origin + direction.scale(eps):origin;
        this.direction = direction;
    }

    static Ray fromDir(P origin, N direction, bool do_shift=false) nothrow {
        return new Ray(origin, direction, do_shift);
    }

    static Ray fromAtoB(P a, P b, bool do_shift=false) nothrow {
        return new Ray(a, (b - a).norm(), do_shift);
    }

    P apply(double t) nothrow {
        return origin + direction.scale(t);
    }

    override string toString() {
        return to!string(origin)~" + t"~to!string(direction);
    }
}
