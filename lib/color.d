module lib.color;
import std.string;
import lib.vec;

struct Color {
    double r, g, b;

    Color opBinary(string op)(Color that) nothrow
    {
        static if (op == "+" || op == "*")
            return mixin("Color(r %s that.r, g %s that.g, b %s that.b)".format(op, op, op));
        else static assert(0, "Not implemented");
    }

    Color amplify(double f) nothrow {
        return Color(r * f, g * f, b * f);
    }

    Color amplify(double f) immutable nothrow {
        return Color(r * f, g * f, b * f);
    }

    @property
    Color dup() immutable nothrow {
        return Color(r, g, b);
    }

    static {
        immutable zro  = Color(0, 0, 0);
        immutable one  = Color(1, 1, 1);
        immutable black= Color(0, 0, 0);
        immutable white= Color(.9, .9, .9);
        immutable red  = Color(.7, 0, 0);
        immutable green= Color(0, .7, 0);
        immutable blue = Color(0, 0, .7);

    }

    //unittest {
    //    assert(zro + zro == zro);
    //}
}

