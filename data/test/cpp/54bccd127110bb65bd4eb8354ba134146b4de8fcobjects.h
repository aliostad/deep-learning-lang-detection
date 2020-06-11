class Point {
public:
    double x, y;
    Point(): x(1), y(1){}
    Point(double a1, double b2): x(a1), y(b2){}
};
class Line {
public:
    Point a, b;
    Line(): a(0, 0), b(1, 1) {}
    Line(int a1, double b1, int a2, double b2): 
        a(a1, b1), b(a2, b2) {}
};

namespace excentury {

XC_DUMP_DATATYPE(Point, p) {
    XC_DUMP(p.x, "x");
    XC_DUMP(p.y, "y");
}
XC_LOAD_DATATYPE(Point, p) {
    XC_LOAD(p.x);
    XC_LOAD(p.y);
}

XC_DUMP_DATATYPE(Line, l) {
    XC_DUMP(l.a, "a");
    XC_DUMP(l.b, "b");
}
XC_LOAD_DATATYPE(Line, l) {
    XC_LOAD(l.a);
    XC_LOAD(l.b);
}

}
