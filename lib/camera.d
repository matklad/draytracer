module lib.camera;

import lib.vec;
import lib.ray;
import lib.utils;

class Camera {
    immutable int resW, resH;
    immutable double screenW, screenH, screenDist;

    P position, view, screenCenter;
    V up, right;

    this(P position, V up, double screenDist, double screenW, double screenH,
         int resW=640, int resH=480, P view=P.create(0, 0, 0)) {

        this.position = position;
        this.view = view;

        auto u = up.norm();
        auto dir = (view - position).norm();
        this.right = (dir % u).norm();
        this.up = (right % dir).norm();

        this.resW = resW;
        this.resH = resH;
        this.screenH = screenH;
        this.screenW = screenW;
        this.screenDist = screenDist;

        this.screenCenter = (Ray.fromDir(position, dir)).apply(screenDist);
    }

    Ray apply(int x, int y) nothrow {
        assert(0 <= x && x < resW);
        assert(0 <= y && y < resH);
        double mx = resW - 1,
               my = resH - 1;

        auto shup = (y - my / 2) / my * screenH;
        auto shr  = (x - mx / 2) / mx * screenW;

        auto pointOnScreen = screenCenter + up.scale(shup) + right.scale(shr);

        return Ray.fromAtoB(position, pointOnScreen);
    }

}
