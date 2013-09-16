module lib.vec;
import std.stdio;
import std.string;
import std.math;

alias immutable(Vec!double) V;
alias V P;
alias V N;

immutable struct Vec(T) {
    alias immutable(Vec!T) IV;
    static immutable double EPS = 1e-6;
    T x, y, z;

    @property
    T length() pure {
        return (x*x + y*y  + z*z)^^0.5;
    }

    string toString() {
        return "(%s, %s, %s)".format(x, y, z);
    }

    IV opUnary(string op)() nothrow {
        static if (op == "+")
            return this;
        else static if (op == "-")
            return IV(-x, -y, -z);
        else static assert(0, op~" Not implemented");
    }

    IV opBinary(string op)(auto ref IV that) pure nothrow
    if (op != "&" && op != "%") {
        static if (op == "+" || op == "-")
            return mixin("IV(x"~op~"that.x, y"~op~"that.y, z"~op~"that.z)");
        else static assert(0, "Not implemented");
    }

    T opBinary(string op)(auto ref IV that) pure nothrow
    if (op == "&") {
        return this.dot(that);
    }

    IV opBinary(string op)(auto ref IV that) pure nothrow
    if (op == "%") {
        return this.cross(that);
    }

    bool opEquals(IV that) nothrow {
        return (that - this).length < this.EPS;
    }

    T dot(ref IV other) pure nothrow {
        return x*other.x + y*other.y + z*other.z;
    }

    IV cross(ref IV other) pure nothrow {
        auto u = other.x,
             v = other.y,
             t = other.z;
        auto cx = y*t - v*z,
             cy = u*z - x*t,
             cz = x*v - u*y;
        return IV(cx, cy, cz);
    }

    IV scale(T f) pure nothrow {
        return IV(x*f, y*f, z*f);
    }

    final immutable(Vec!T) norm() nothrow {
        return IV(x/length, y/length, z/length);
    }
}

//immutable struct NVec(T) {
//    immutable(Vec!T) v;
//    alias v this;
//    invariant() {
//        assert(abs(v.length - 1) < v.EPS);
//    }
//}

unittest {
    V a = V( 1, 1, 1);
    V b = V(-1, 0, 1);
    auto dot = a & b;
    assert(abs(dot) < V.EPS);
    auto cross = a % b;
    auto c = V(1, -2, 1);
    assert(cross == c);
}
