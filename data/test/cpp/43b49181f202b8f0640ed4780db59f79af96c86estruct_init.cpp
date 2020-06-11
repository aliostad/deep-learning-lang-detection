#include <iostream>

using namespace std;
struct haha {
    haha():i(1),j(3){}
    int i;
    int j;
    virtual void dump() {
        cout << "i:" << i << ",j" << j << endl;
    }
};

struct xiaohaha : haha {
    int k;
    xiaohaha():k(10) {i=3;}
    virtual void dump() {
        haha::dump();
        cout << "x:i:" << i << endl;
        cout << "x:j:" << j << endl;
        cout << "K:" << k << endl;
    }
};


int main() {
    struct haha h;
    h.i = 1;
    h.j = 2;

    struct haha b = h;
    cout << "dumpH:" << endl;
    h.dump();
    cout << "dumpB:" << endl;
    b.dump();

    struct xiaohaha x;
    cout << "dumpX:" << endl;
    x.dump();

    struct haha &p = b;
    cout << "dumpP:" << endl;
    p.dump();
}
