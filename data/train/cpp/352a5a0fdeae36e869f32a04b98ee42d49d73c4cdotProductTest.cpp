#include <cstdio>
#include <cstdlib>
#include <iostream>

#include <ScoreStream.h>

#include "ddot.h"

using namespace std;

int main() {
	score_init();
	
        DOUBLE_SCORE_STREAM x1=NEW_DOUBLE_SCORE_STREAM();
        DOUBLE_SCORE_STREAM x2=NEW_DOUBLE_SCORE_STREAM();
        DOUBLE_SCORE_STREAM x3=NEW_DOUBLE_SCORE_STREAM();
        DOUBLE_SCORE_STREAM x4=NEW_DOUBLE_SCORE_STREAM();
	DOUBLE_SCORE_STREAM y1=NEW_DOUBLE_SCORE_STREAM();
	DOUBLE_SCORE_STREAM y2=NEW_DOUBLE_SCORE_STREAM();
	DOUBLE_SCORE_STREAM y3=NEW_DOUBLE_SCORE_STREAM();
	DOUBLE_SCORE_STREAM y4=NEW_DOUBLE_SCORE_STREAM();

	DOUBLE_SCORE_STREAM z=NEW_DOUBLE_SCORE_STREAM();
	

	
	NEW_ddot(x1,y1,x2,y2,z);

	STREAM_WRITE_DOUBLE(x1, 1.0);
	STREAM_WRITE_DOUBLE(x2, 2.0);
	STREAM_WRITE_DOUBLE(x3, 3.0);
	STREAM_WRITE_DOUBLE(x4, 3.0);
	
	STREAM_WRITE_DOUBLE(y1, 1.0);
	STREAM_WRITE_DOUBLE(y2, 2.0);
	STREAM_WRITE_DOUBLE(y3, 3.0);
	STREAM_WRITE_DOUBLE(y4, 3.0);
	

       cout<<"About to get Result"<<endl;
	bool done=false;
	while(!done) {
		done=STREAM_EOS(z);
		cout << "z=" << STREAM_READ_DOUBLE(z) << endl;

	}

	
	score_exit();
}
