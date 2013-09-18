module lib.shape;

import std.conv;
import std.algorithm;
import std.typecons;
import std.string;

import lib.color;
import lib.vec;
import lib.ray;
import lib.material;


abstract class Shape {
    Color colorAt(P p) nothrow;
    N normAt(P p) nothrow;
    IMaterial material() nothrow;
    double intersect(Ray r) nothrow;
}


class Sphere: Shape {
    P center;
    double radius;
    IMaterial material_;
    Color color;

    this(P center, double radius, Color color=Color.white) nothrow {
        this.center = center;
        this.radius = radius;
        this.color = color;
        material_ = Material.simple;
    }

    override Color colorAt(P p) nothrow {
        return this.color;
    }

    override N normAt(P p) nothrow {
        return (p - center).norm();
    }

    override IMaterial material() { return material_; }

    override string toString() {
        return "S(%s, %s)".format(to!string(center), radius);
    }

    override double intersect(Ray r) nothrow {
        auto co = center - r.origin;
        auto a  = r.direction & r.direction;
        auto b  = r.direction & co;
        auto c  = (co & co) - radius * radius;
        auto d  = b*b - a*c;
        auto none = 10^^6;
        if (d < 0)
            return none;

        auto rd = d ^^ 0.5;
        auto t1 = (b - rd) / a;
        auto t2 = (b + rd) / a;
        t1 = min(t1, t2);
        t2 = max(t1, t2);
        if (t2 < 0)
            return none;
        if (t1 < 0)
            return t2;
        return t1;
    }


    unittest {
        import std.math;

        auto center = V(0, 0, 0);
        auto radius = 1;
        auto s = new Sphere(center, radius);

        auto o = V(0, 0, 10);
        auto r = Ray.fromAtoB(o, center);
        auto i = s.intersect(r);
        assert(abs(i - 9) < V.EPS);

        auto d = V(1, 1, 1);
        r = Ray.fromAtoB(center, d);
        i = s.intersect(r);
        assert(abs(i - 1) < V.EPS);
    }

}


final class Triangle: Shape {
    P a, b, c;
    V  ab, ac, abXn, acXn;
    N n;
    immutable double abDacXn, acDabXn;
    IMaterial material_;
    Color color;
    this(P a, P b, P c, Color color=Color.white) {
        this.a = a;
        this.b = b;
        this.c = c;
        ab = b - a;
        ac = c - a;
        n = (ab % ac).norm();
        abXn = ab % n;
        acXn = ac % n;
        abDacXn = ab & (acXn);
        acDabXn = ac & (abXn);

        this.color = color;
        material_ = Material.simple;
    }

    override Color colorAt(P p) nothrow {
        return this.color;
    }

    override N normAt(P p) nothrow {
        return n;
    }

    override IMaterial material() { return material_; }

    override double intersect(Ray r) pure nothrow {
        auto none = 10^^6;
        auto denom = r.direction & n;
        if (denom * denom < 0.00001)
            return none;

        auto ao = a - r.origin;
        auto t = (ao & n) / denom;

        if (t < 0)
            return none;

        auto tdo = r.direction.scale(t) - ao;
        auto p = (tdo & acXn) / abDacXn;
        if (p < 0 || p > 1)
            return none;

        auto q = (tdo & abXn) / acDabXn;
        if (q < 0 || q > 1 || (p + q) > 1)
            return none;
        return t;
    }
}
