#include "InputStream.h"
#include <iostream>
using namespace std;

// constructor
// 派生クラスのコンストラクタが呼ばれると、その前に基底クラスのコンストラクタが呼ばれる。
// 今回の場合だと基底クラスStreamのコンストラクタは引数を必ず必要とするので、
// 以下のように明示的にコンストラクタに対する引数を指定しなければなりません。
InputStream::InputStream(double n) : Stream(100){
	cout << "InputStream Constructor. arg = " << n << endl;
}

InputStream::~InputStream(){
	cout << "InputStream Destructor" << endl;
}
