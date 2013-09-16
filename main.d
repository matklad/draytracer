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

void main(string[] argv){
    string[] lines;
    string buf;
    while ((buf = stdin.readln()) !is null)
        lines ~= buf.strip();

    auto p = new ObjParser(lines);
    auto shapes = p.read();


    //init(argv);
    auto origin = V.create(0, 0, 0);
    auto position = V.create(50, 50, 80);
    auto up = V.create(0, 1, 0);
    double dist = 80, w = 40, h = 30;
    //6.6 seconds
    auto c = new Camera(position, up, dist, w, h, 160, 120);
    scene = new Scene(c, Color.white.scaleColor(0.1));

    foreach(s; shapes)
        scene.addShape(s);

    auto light1 = new LightSource(V.create(100, 0, 100), Color.white);
    auto light2 = new LightSource(V.create(-100, 0, 100), Color.white);
    scene.addLight(light1);
    scene.addLight(light2);
    display();
    //glutMainLoop();
}

void init(string[] argv){
    const w_width = 120;
    const w_heigth = 90;
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
    //glutDisplayFunc(&display);

}

//extern (C) nothrow void display()
void display()
{
    double f(double x) nothrow {
        return max(0, min(1, x));
    }
    auto pixels = scene.render();
    //glClearColor(0.0, 0.0, 0.0, 0.0);
    //glClear(GL_COLOR_BUFFER_BIT);
    //glBegin(GL_POINTS);
    auto total = 0;
    foreach(y, row; pixels)
        foreach(x, c; row) {
            total += c.r;
            //glColor3f(f(c.r), f(c.g), f(c.b));
            //glVertex2f(x+1, y);
        }
    writeln(total);
    //glEnd();
    //glFlush();
}
