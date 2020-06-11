#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* malloc, free, rand */
#include <assert.h>
#include <math.h>
#include <iostream>
using namespace std;

unsigned lfsr;
#define MASK 0xd0000001u
#define rand (lfsr = (lfsr>>1)^(unsigned int)(0-(lfsr & 1u) & MASK))

unsigned int footprint_size=0;
unsigned int dump[100];

#define r (rand%footprint_size)

int main(int argc, char** argv)
{
	unsigned int* data_chunk;
	lfsr=11;

    int level = 5;
    bool infinite;
    if (argc >=2){
        sscanf(argv[1], "%d", &level);
    }else{
        cerr<<"warning: default level = 5"<<endl;
    }
    if (argc >=3){
        infinite = true;
    }

    footprint_size = 1024*256*level;
	//footprint_size=256*6144;//1M-->4M keep smashing 4MB data
	//printf("smash 4*256*6144B space\n");

	unsigned long x;
	x = powl(2,32);

	data_chunk = (unsigned *)malloc(x*sizeof(unsigned int));
    assert(data_chunk);


    for (int i = 0; i<15000000 || infinite; i++){
		dump[0]+=data_chunk[r]++;
		dump[1]+=data_chunk[r]++;
		dump[2]+=data_chunk[r]++;
		dump[3]+=data_chunk[r]++;
		dump[4]+=data_chunk[r]++;
		dump[5]+=data_chunk[r]++;
		dump[6]+=data_chunk[r]++;
		dump[7]+=data_chunk[r]++;
		dump[8]+=data_chunk[r]++;
		dump[9]+=data_chunk[r]++;

		dump[10]+=data_chunk[r]++;
		dump[11]+=data_chunk[r]++;
		dump[12]+=data_chunk[r]++;
		dump[13]+=data_chunk[r]++;
		dump[14]+=data_chunk[r]++;
		dump[15]+=data_chunk[r]++;
		dump[16]+=data_chunk[r]++;
		dump[17]+=data_chunk[r]++;
		dump[18]+=data_chunk[r]++;
		dump[19]+=data_chunk[r]++;

		dump[20]+=data_chunk[r]++;
		dump[21]+=data_chunk[r]++;
		dump[22]+=data_chunk[r]++;
		dump[23]+=data_chunk[r]++;
		dump[24]+=data_chunk[r]++;
		dump[25]+=data_chunk[r]++;
		dump[26]+=data_chunk[r]++;
		dump[27]+=data_chunk[r]++;
		dump[28]+=data_chunk[r]++;
		dump[29]+=data_chunk[r]++;

		dump[30]+=data_chunk[r]++;
		dump[31]+=data_chunk[r]++;
		dump[32]+=data_chunk[r]++;
		dump[33]+=data_chunk[r]++;
		dump[34]+=data_chunk[r]++;
		dump[35]+=data_chunk[r]++;
		dump[36]+=data_chunk[r]++;
		dump[37]+=data_chunk[r]++;
		dump[38]+=data_chunk[r]++;
		dump[39]+=data_chunk[r]++;

		dump[40]+=data_chunk[r]++;
		dump[41]+=data_chunk[r]++;
		dump[42]+=data_chunk[r]++;
		dump[43]+=data_chunk[r]++;
		dump[44]+=data_chunk[r]++;
		dump[45]+=data_chunk[r]++;
		dump[46]+=data_chunk[r]++;
		dump[47]+=data_chunk[r]++;
		dump[48]+=data_chunk[r]++;
		dump[49]+=data_chunk[r]++;

		dump[50]+=data_chunk[r]++;
		dump[51]+=data_chunk[r]++;
		dump[52]+=data_chunk[r]++;
		dump[53]+=data_chunk[r]++;
		dump[54]+=data_chunk[r]++;
		dump[55]+=data_chunk[r]++;
		dump[56]+=data_chunk[r]++;
		dump[57]+=data_chunk[r]++;
		dump[58]+=data_chunk[r]++;
		dump[59]+=data_chunk[r]++;

		dump[60]+=data_chunk[r]++;
		dump[61]+=data_chunk[r]++;
		dump[62]+=data_chunk[r]++;
		dump[63]+=data_chunk[r]++;
		dump[64]+=data_chunk[r]++;
		dump[65]+=data_chunk[r]++;
		dump[66]+=data_chunk[r]++;
		dump[67]+=data_chunk[r]++;
		dump[68]+=data_chunk[r]++;
		dump[69]+=data_chunk[r]++;

		dump[70]+=data_chunk[r]++;
		dump[71]+=data_chunk[r]++;
		dump[72]+=data_chunk[r]++;
		dump[73]+=data_chunk[r]++;
		dump[74]+=data_chunk[r]++;
		dump[75]+=data_chunk[r]++;
		dump[76]+=data_chunk[r]++;
		dump[77]+=data_chunk[r]++;
		dump[78]+=data_chunk[r]++;
		dump[79]+=data_chunk[r]++;

		dump[80]+=data_chunk[r]++;
		dump[81]+=data_chunk[r]++;
		dump[82]+=data_chunk[r]++;
		dump[83]+=data_chunk[r]++;
		dump[84]+=data_chunk[r]++;
		dump[85]+=data_chunk[r]++;
		dump[86]+=data_chunk[r]++;
		dump[87]+=data_chunk[r]++;
		dump[88]+=data_chunk[r]++;
		dump[89]+=data_chunk[r]++;

		dump[90]+=data_chunk[r]++;
		dump[91]+=data_chunk[r]++;
		dump[92]+=data_chunk[r]++;
		dump[93]+=data_chunk[r]++;
		dump[94]+=data_chunk[r]++;
		dump[95]+=data_chunk[r]++;
		dump[96]+=data_chunk[r]++;
		dump[97]+=data_chunk[r]++;
		dump[98]+=data_chunk[r]++;
		dump[99]+=data_chunk[r]++;

		//printf("size of the unsigned int is %d\n",sizeof(dump[10]));
		//printf("lfsr now is : %d\n",(int)lfsr);
		//printf("rand now is : %d\n",(int)rand);
		//printf("r now is %d\n",r);
	}
	/*while(1)
	{
		double *mid=bw_data+(bw_stream_size/2);
		for(int i=0; i<bw_stream_size/2; i++)
		{bw_data[i]=scalar*mid[i];}

		for(int i=0; i<bw_stream_size/2;i++)
		{mid[i]=scalar*bw_data[i];}

	}*/
    delete[] data_chunk;
	return 0;
}
