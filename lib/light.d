module lib.light;

import lib.vec;
import lib.color;
import std.algorithm;

struct Light {
    N direction;
    immutable(Color) color;
    double power;
    double distance;
}

class LightSource {
    immutable(Color) color;
    P position;

    this(V position, immutable(Color) color) nothrow {
        this.position = position;
        this.color = color;
    }

    Light shade(P point, N normal) nothrow {
        auto path = position - point;
        auto direction = path.norm();
        Light l = {
            direction: direction,
            color: this.color,
            power: max(0, direction & normal),
            distance: path.length
        };

        return l;
    }
}
