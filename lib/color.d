module lib.color;
import lib.vec;

alias immutable(Color) IColor;

class Color: P {
    private this(double r, double g, double b) nothrow immutable pure {
        super(r, g, b);
    }

    static IColor fromRGB(double r, double g, double b) nothrow {
        return new immutable(Color)(r, g, b);
    }

    IColor opBinary(string op)(IColor that) nothrow immutable
    {
        static if (op == "+" || op == "-" || op == "*")
            return mixin(format("new IColor(x %s that.x, y %s that.y, z %s that.z)", op, op, op));
        else static assert(0, "Not implemented");
    }

    IColor scaleColor(double f) nothrow immutable {
        return new IColor(x*f, y*f, z*f);
    }

    @property double r() immutable nothrow { return x; }
    @property double g() immutable nothrow { return y; }
    @property double b() immutable nothrow { return z; }

    static {
        immutable zro  = Color.fromRGB(0, 0, 0);
        immutable one  = Color.fromRGB(1, 1, 1);
        immutable black= Color.fromRGB(0, 0, 0);
        immutable white= Color.fromRGB(.9, .9, .9);
        immutable red  = Color.fromRGB(.7, 0, 0);
        immutable green= Color.fromRGB(0, .7, 0);
        immutable blue = Color.fromRGB(0, 0, .7);

    }
    unittest {
        assert(zro + zro == zro);
    }
}

