#include <cstdio>
#include <cstdlib>
#include <iostream>

#include <ScoreStream.h>

#include "DualStageAccumulator.h"

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
	

	
	NEW_DualStageAccumulator(4,x1,z);

	STREAM_WRITE_DOUBLE(x1, 1.0);
	STREAM_WRITE_DOUBLE(x1, 2.0);
	STREAM_WRITE_DOUBLE(x1, 3.0);
	STREAM_WRITE_DOUBLE(x1, 4.0);
	

	STREAM_WRITE_DOUBLE(x1, 5.0);
	STREAM_WRITE_DOUBLE(x1, 6.0);
	STREAM_WRITE_DOUBLE(x1, 7.0);
	STREAM_WRITE_DOUBLE(x1, 8.0);
	FRAME_CLOSE(x1);

       cout<<"About to get Result"<<endl;
	bool done=false;
	while(!done) {
		done=STREAM_EOS(z);
		cout << "z=" << STREAM_READ_DOUBLE(z) << endl;

	}

	
	score_exit();
}
