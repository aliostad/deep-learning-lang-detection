#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

#define FOR(i,a,b) for(int i=(a);i<(b);++i)
#define REP(i,n)  FOR(i,0,n)
#define dump(x)  cerr << #x << " = " << (x) << endl;

int a = 4, b = 11;

int extgcd(int a, int b, int& x, int& y) {
    cerr << " (a=" << a << ",b=" << b << ")" << endl;
    int d = a;
    if (b == 0) {
        x = 1;
        y = 0;
        cerr << "x: " << x << ", y; " << y << endl;
    } else {
        d = extgcd(b, a % b, x, y);
        int preX = x;
        x = y;
        y = preX - (a / b) * y;
        cerr << "x: " << x << ", y; " << y << endl;
    }
    return d;
}

int main() {
    int x, y;
    int gcd = extgcd(b, a, x, y);
    cerr << "////// result //////" << endl;
    dump(a);
    dump(b);
    dump(x);
    dump(y);
    dump(gcd);
}

