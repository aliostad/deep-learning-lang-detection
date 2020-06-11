#include <iostream>
#include <cstdlib>
#include <cstdio>
using namespace std;

class Sample{
public:
	int x;
	Sample(){cout << "Sample()" << endl;}
	~Sample(){cout << "~Sample()" << endl;}
	void* operator new(size_t sz) {
		cout << "operator new(" << sz << ")" << endl;
		return malloc(sz);
	}
	void operator delete(void* p) {
		cout << "operator delete" << endl;
		free(p);
	}	
};
int main() {
	Sample *s = new Sample;
	delete s;
	printf("-----------\n");
	Sample *s2 = (Sample*)malloc(sizeof(Sample));
	free(s2);
}

