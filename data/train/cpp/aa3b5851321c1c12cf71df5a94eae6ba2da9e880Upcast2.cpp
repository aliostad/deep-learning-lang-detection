#include "InputStream.h"
#include "ArrayStream.h"
#include <iostream>
using namespace std;

void Show(const Stream& stream){     // InputStreamの基底クラスであることに注意(upcast)
	cout << stream.Get() << endl;
}

/* 
 * 上記のようにアップキャストされたShow()関数を準備するだけで、以下のように２種類のメソッドを準備する必要がなくなります。
 */
/*
void Show(const InputStream& stream){
	cout << stream.Get() << endl;
}

void Show(const ArrayStream& stream){
	cout << stream.Get() << endl;
}
 */

int main(){
	InputStream istream;
	cout << "> " << flush;
	istream.Set();
	Show(istream);                            // Upcasting. istream is InputStream. 

	static const double ARRAY[] = { 3, -1 };
	ArrayStream astream(ARRAY);

	astream.Set();
	Show(astream);                            /// Upcasting. astream is ArrayStream.
}
