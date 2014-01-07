import std.stdio;
import std.conv;
import std.string;
import std.algorithm;

import derelict.opengl3.gl3;
import derelict.opengl3.gl;
import derelict.freeglut.glut;

import lib.vec;
import lib.scene;
import lib.camera;
import lib.shape;
import lib.color;
import lib.light;
import lib.obj;

pragma(lib, "DerelictGL3");
pragma(lib, "DerelictFG");
pragma(lib, "DerelictUtil");
pragma(lib, "dl");

Scene scene;
int W = 640;
int H = 480;

void prepareScene() {
    string[] lines;
    string buf;
    while ((buf = stdin.readln()) !is null)
        lines ~= buf.strip();
    auto p = new ObjParser(lines);
    auto shapes = p.read();

    auto origin = V(0, 0, 0);
    auto position = V(50, 50, 80);
    auto up = V(0, 1, 0);
    double dist = 80, w = 40, h = 30;
    auto c = new Camera(position, up, dist, w, h, W, H);
    scene = new Scene(c, Color.white.amplify(0.1));

    foreach(s; shapes)
        scene.addShape(s);

    auto light1 = new LightSource(V(100, 0, 100), Color.white);
    auto light2 = new LightSource(V(-100, 0, 100), Color.white);
    scene.addLight(light1);
    scene.addLight(light2);
}

void main(string[] argv){
    prepareScene();
    init(argv);
    display();
    glutMainLoop();
}

void init(string[] argv){
    const w_width = W;
    const w_heigth = H;
    const w_title = "D-ray";
    DerelictGL3.load();
    DerelictFreeGLUT.load();

    int cargc = to!int(argv.length);
    char*[] cargv = [];
    cargv.length = argv.length;
    foreach(int i, string arg; argv) {
        cargv[i] = cast(char*) arg.ptr;
    }
    glutInit(&cargc, cargv.ptr);

    glutInitWindowSize(w_width, w_heigth);
    glutInitWindowPosition(0, 0);
    glutCreateWindow(w_title.ptr);

    DerelictGL3.reload();
    DerelictGL.load();
    glViewport(0, 0, w_width, w_heigth);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, w_width, 0, w_heigth, -100, 100);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glutDisplayFunc(&display);
}

extern (C) nothrow void display()
{
    double f(double x) nothrow {
        return max(0, min(1, x));
    }
    auto pixels = scene.render();
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glBegin(GL_POINTS);
    foreach(y, row; pixels)
        foreach(x, c; row) {
            glColor3f(f(c.r), f(c.g), f(c.b));
            glVertex2f(x+1, y);
        }
    glEnd();
    glFlush();
}
