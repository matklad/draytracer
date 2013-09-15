module lib.vec;
import std.stdio;
import std.string: format;
import std.math: abs;

alias Vec!double V;
alias V P;
alias NVec!double N;

class Vec(T) {
    static immutable double EPS = 1e-6;
    immutable T x, y, z;

    @property
    immutable(T) length() const nothrow {
        return (x*x + y*y  + z*z)^^0.5;
    }

    public this(T x, T y, T z) nothrow pure {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    override string toString() {
        return format("(%s, %s, %s)", x, y, z);
    }

    Vec!T opUnary(string op)() nothrow {
        static if (op == "+")
            return this;
        else static if (op == "-")
            return new Vec!T(-x, -y, -z);
        else static assert(0, op~"Not implemented");
    }

    Vec!T opBinary(string op)(Vec!T that) nothrow
    if (op != "&" && op != "%") {
        static if (op == "+" || op == "-")
            return mixin(format("new Vec!T(x %s that.x, y %s that.y, z %s that.z)", op, op, op));
        else static if (op == "%")
            return this.cross(that);
        else static assert(0, "Not implemented");
    }

    T opBinary(string op)(Vec!T that) nothrow
    if (op == "&") {
        return this.dot(that);
    }

    Vec!T opBinary(string op)(Vec!T that) nothrow
    if (op == "%") {
        return this.cross(that);
    }

    override bool opEquals(Object rhs) nothrow {
        auto that = cast(Vec!T) rhs;
        if (!that)
            return false;
        return (that - this).length < this.EPS;
    }

    T dot(Vec!T other) nothrow {
        return x*other.x + y*other.y + z*other.z;
    }

    Vec!T cross(Vec!T other) nothrow {
        auto u = other.x,
             v = other.y,
             t = other.z;
        // cx cy cz
        // x  y  z
        // u  v  t
        auto cx = y*t - v*z,
             cy = u*z - x*t,
             cz = x*v - u*y;
        return new Vec!T(cx, cy, cz);
    }

    Vec!T scale(T f) nothrow {
        return new Vec!T(x*f, y*f, z*f);
    }

    final NVec!T norm() nothrow {
        return new NVec!T(x/length, y/length, z/length);
    }

    static Vec!T create(T x, T y, T z) nothrow{
        return new Vec!T(x, y, z);
    }
}


class NVec(T): Vec!T {
    invariant() {
        assert(abs(this.length - 1) < Vec!T.EPS);
    }

    private this(T x, T y, T z) {
        super(x, y, z);
    }
}

unittest {
    V a = V.create( 1, 1, 1);
    V b = V.create(-1, 0, 1);
    auto dot = a & b;
    assert(abs(dot) < V.EPS);
    auto cross = a % b;
    assert(cross == V.create(1, -2, 1));
}
