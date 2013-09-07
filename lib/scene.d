module lib.scene;

import std.typecons;
import std.algorithm;

import lib.camera;
import lib.shape;
import lib.color;
import lib.utils;
import lib.ray;
import lib.vec;
import lib.light;


class Scene {
    Camera camera;
    Shape[] shapes = [];
    LightSource[] lights = [];
    IColor background;
    IColor light;

    this(Camera camera, IColor light=Color.white, IColor background=Color.black) {
        this.camera = camera;
        this.background = background;
        this.light = light;
    }

    Scene addShape(Shape shape) {
        this.shapes ~= shape;
        return this;
    }

    Scene addLight(LightSource light) {
        this.lights ~= light;
        return this;
    }

    immutable(Color)[][] render() nothrow {
        auto h = camera.resH,
             w = camera.resW;
        alias RC = Rebindable!(IColor);
        auto colors = new RC[][](h, w);
        foreach(y; 0..h)
            foreach(x; 0..w)
                colors[y][x] = render(x, y);
        return cast(IColor[][])colors;
    }

    IColor render(int x, int y) nothrow {
        auto ray = camera.apply(x, y);
        auto i = intersect(ray);
        if (i.isNull()) {
            return background;
        } else {
            auto s = i[0];
            auto t = i[1];
            auto p = ray.apply(t);
            return shade(ray, s, p);
        }
    }

    IColor shade(Ray view, Shape s, P p) nothrow {
        bool isVisible(Light l) nothrow {
            auto ret = intersect(Ray.fromDir(p, l.direction, true));
            return ret.isNull() || ret[1] > l.distance;
        }

        auto baseColor = s.colorAt(p);
        auto n = s.normAt(p);
        auto m = s.material();
        auto rView = reflect(view.direction, n);

        auto visible = filter!(isVisible)(map!(l => l.shade(p, n))(lights));

        Rebindable!(IColor) ambient  = Color.zro,
                            diffuse  = Color.zro,
                            specular = Color.zro;

        ambient = baseColor * m.ambient * light;
        foreach(l; visible){
            diffuse  = diffuse + (baseColor * l.color * m.diffuse).scaleColor(l.power);
            auto k = max(0, (rView & l.direction)) ^^ m.phong;
            specular = specular + (l.color * m.specular).scaleColor(k);
        }
        return ambient + diffuse + specular;
    }

    static N reflect(N v, N n) nothrow {
        auto nproj = n.scale(v & (-n));
        auto d = v + nproj;
        return (nproj + d).norm();
    }

    Nullable!(Tuple!(Shape, double)) intersect(Ray ray) nothrow {
        Nullable!(Tuple!(Shape, double)) ret;
        foreach(s; shapes){
            auto t = s.intersect(ray);
            if(!t.isNull()){
                if(ret.isNull()) {
                    ret = Tuple!(Shape, double)(s, t);
                } else {
                    if(ret[1] > t) {
                        ret[0] = s;
                        ret[1] = t;
                    }
                }
            }
        }
        return ret;
    }
}
