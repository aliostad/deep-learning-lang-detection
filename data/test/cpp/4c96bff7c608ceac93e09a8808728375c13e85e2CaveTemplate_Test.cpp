//============================================================================
// Name        : TemplateTest.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================


#include "../Cave.h"
using namespace std;

int main() {
	cout << "!!!Program Start!!!" << endl; // prints !!!Hello World!!!

	Cave cave;

	int * intP = new int[100];
	int * intP2 =new int[101];

	int arr[10];

	int a =4;
	int b =5;
	float f = 4.8f;
	intP[0]= 1;


	cave.Invoke(a,intP,100,b,intP2,101,f); // Pointer
//
//	cave.Invoke(arr);  //Array
//
//	cave.Invoke(a);
//
//	cave.Invoke(f);


//	string reqeustName ="A.Hello()";
//
//	cave.Invoke("A.Hello()",b,a);
//	cave.Invoke("B.Hello()");
	return 0;
}
