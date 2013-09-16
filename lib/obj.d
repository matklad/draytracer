module lib.obj;
import std.string;
import std.conv;
import std.stdio;

import lib.shape;
import lib.vec;
import lib.color;

class ObjParser {
    string[] lines;

    this(string[] lines) {
        this.lines = lines;
    }

    Shape[] read() {
        V[] points;
        Shape[] shapes;
        foreach(l; lines) {
            if(l.strip().length < 2)
                continue;

            auto s = l[2..$];
            switch(l[0..2]) {
                case "v ":
                    auto ns = to!(double[])(split(s));
                    points ~= V(ns[0], ns[1], ns[2]);
                    break;
                case "f ":
                    auto blocks = split(s);
                    auto a = points[parse!int(blocks[0]) - 1];
                    auto b = points[parse!int(blocks[1]) - 1];
                    auto c = points[parse!int(blocks[2]) - 1];
                    shapes ~= new Triangle(a, b, c, Color.red);
                default:
                    break;
            }

        }
        return shapes;
    }
}
