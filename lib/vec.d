module lib.vec;
import std.stdio;
import std.string: format;
import std.math: abs;

alias immutable(Vec!double) V;
alias V P;
alias immutable(NVec!double) NV;

immutable struct Vec(T) {
    alias immutable(Vec!T) IV;
    static immutable double EPS = 1e-6;
    T x, y, z;

    @property
    T length() {
        return (x*x + y*y  + z*z)^^0.5;
    }

    public static IV create(T x, T y, T z) pure nothrow {
        IV ret = {x:x, y:y, z:z};
        return ret;
    }

    string toString() {
        return format("(%s, %s, %s)", x, y, z);
    }

    IV opUnary(string op)() nothrow {
        static if (op == "+")
            return this;
        else static if (op == "-")
            return IV.create(-x, -y, -z);
        else static assert(0, op~"Not implemented");
    }

    IV opBinary(string op)(IV that) nothrow
    if (op != "&" && op != "%") {
        static if (op == "+" || op == "-")
            return mixin(format("IV.create(x %s that.x, y %s that.y, z %s that.z)", op, op, op));
        else static if (op == "%")
            return this.cross(that);
        else static assert(0, "Not implemented");
    }

    T opBinary(string op)(IV that) nothrow
    if (op == "&") {
        return this.dot(that);
    }

    IV opBinary(string op)(IV that) nothrow
    if (op == "%") {
        return this.cross(that);
    }

    bool opEquals(IV that) nothrow {
        return (that - this).length < this.EPS;
    }

    T dot(IV other) nothrow {
        return x*other.x + y*other.y + z*other.z;
    }

    IV cross(IV other) nothrow {
        auto u = other.x,
             v = other.y,
             t = other.z;
        // cx cy cz
        // x  y  z
        // u  v  t
        auto cx = y*t - v*z,
             cy = u*z - x*t,
             cz = x*v - u*y;
        return IV.create(cx, cy, cz);
    }

    IV scale(T f) nothrow {
        return IV.create(x*f, y*f, z*f);
    }

    final immutable(NVec!T) norm() nothrow {
        immutable(NVec!T) ret = { v: IV.create(x/length, y/length, z/length) };
        return ret;
    }
}

immutable struct NVec(T) {
    immutable(Vec!T) v;
    alias v this;
    invariant() {
        assert(abs(v.length - 1) < v.EPS);
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
