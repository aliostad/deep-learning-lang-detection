#include "7_1_1_InputStream.h"
#include "7_1_2_ArrayStream.h"
#include <iostream>
using namespace std;


//Show関数はアップキャストのおかげで2つのクラスのどちらのオブジェクトでも渡せる。
void Show(const Stream& stream){
	cout << stream.Get() << endl;
}

int main(){
	// InputStream stream;
	// cout << "> " << flush;
	// stream.Set();

	// const Stream& ref = stream;
	// *******************
	// ref.Set();
	//  ‘const class Stream’ has no member named ‘Set’
	// ************************
	// cout << ref.Get() << endl;
	//InputStream stream; 
	//Stream& refl
	//の2つは参照範囲が異なる。streamは派生クラスのオブジェクトなので、
	//基底クラスの参照に渡すことができる（アップキャスト）
	//逆はできない。

	InputStream istream;
	cout << " > " << flush;
	istream.Set();
	Show(istream);

	static const double ARRAY[] = {6,4,4,5,-1};
	ArrayStream astream(ARRAY);

	astream.Set();
	Show(astream);
}