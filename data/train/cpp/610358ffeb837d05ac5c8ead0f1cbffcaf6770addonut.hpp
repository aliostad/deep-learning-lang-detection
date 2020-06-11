// ------------------------------------------------- File:  "donut.hpp"
#ifndef DONUT_H
#define DONUT_H
#include <iostream>
#include <iomanip>
using namespace std;
class A { //----------------------------------------- Grandparent Class		
	public:
		double x; 
		A(): x(11.1) {}
		void dump(){ cerr <<"    A::x = " << x <<"\n"; }
}; 

class B: virtual public A { //----------------------- First Parent of D
	public:
		int a; 
		double x; 
		B(): a(20), x(22.2) {}
		void dump(){
			A::dump(); 
			cerr <<"    B::x = " << x <<"   "<<"B::a = " << a <<"\n";
		}
}; 

class C: virtual private A { //--------------------- Second Parent of D
	public:
		int a; 
		C(): a(30) {}
		void dump(){ A::dump(); cerr <<"    C::a = " << a <<"\n"; }
}; 

class D: public B, public C { //---------------------- Grandchild Class
		float f;
	public:
		D(): f(44.4) {}
		void dump(){
			A::dump();
			B::dump(); 
			C::dump();
			cerr <<"    D::f = " << f <<"\n";
		}
}; 
#endif
