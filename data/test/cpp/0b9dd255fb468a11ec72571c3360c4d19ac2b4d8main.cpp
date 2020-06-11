#include "mbed.h"

#include "MCSVM.hpp"
#include "./debug/debug.hpp"

LocalFileSystem local("local");

// SVMのテストルーチン
int main(void) {
  /*
  FILE* fp;
  const char* fname = "/local/iris.csv";
  char s[100];
  int ret;
  float f1, f2, f3, f4;

  set_new_handler(no_memory);

  float* sample = new float[150 * 4];
  int* sample_label = new int[150];

  fp = fopen( fname, "r" );
  if( fp == NULL ){
    fprintf( stderr, "[%s] File cannot opne \r \n", fname );
    return 1;
  }

  int cnt = 0;
  while( ( ret = fscanf( fp, "%f,%f,%f,%f,%s", &f1, &f2, &f3, &f4, s) ) != EOF ){
    //printf( "%f %f %f \n", f1, f2, f3 );
    sample[cnt * 4]     = f1;
    sample[cnt * 4 + 1] = f2;
    sample[cnt * 4 + 2] = f3;
    sample[cnt * 4 + 3] = f4;
    
    //printf("string : %s \n",s);
    //printf("strcmp : %d \n",strcmp(s,"Iris-setosa"));
    if ( !strcmp(s,"Iris-setosa") ) {
      sample_label[cnt] = 0;
    } else if ( !strcmp(s,"Iris-versicolor")) {
      sample_label[cnt] = 1;
    } else if ( !strcmp(s,"Iris-virginica")) {
      sample_label[cnt] = 2;
    }
    //printf("sample : %f %f %f %f %d\n", MATRIX_AT(sample,4,cnt,0), MATRIX_AT(sample,4,cnt,1), MATRIX_AT(sample,4,cnt,2), MATRIX_AT(sample,4,cnt,3), sample_label[cnt]);

    cnt++;
  }

  MCSVM mcsvm(3, 4, 150, sample, sample_label);
  mcsvm.learning();

  float *test = new float[4];
  for (int i = 0; i < 150; i++ ) {
    test[0] = sample[i * 4 + 0];
    test[1] = sample[i * 4 + 1];
    test[2] = sample[i * 4 + 2];
    test[3] = sample[i * 4 + 3];
    printf("<TEST No:%d> label : %d, answer : %d \r\n", i, mcsvm.predict_label(test), sample_label[i]);
  }
  fclose( fp );
  free( fp ); // required for mbed.
  */

  /* 簡単な例 : 2次元空間の象限 */
  // /*
  float* easy_sample = new float[2 * 12];
  int* easy_sample_label = new int[12];
  easy_sample[0] = 1;     easy_sample[1] = 1;     easy_sample_label[0] = 0; // 第一象限 : ラベル0
  easy_sample[2] = 0.5;   easy_sample[3] = 1;     easy_sample_label[1] = 0;
  easy_sample[4] = 1;     easy_sample[5] = 0.5;   easy_sample_label[2] = 0;
  easy_sample[6] = -1;    easy_sample[7] = 1;     easy_sample_label[3] = 1; // 第二象限 : ラベル1
  easy_sample[8] = -0.5;  easy_sample[9] = 1;     easy_sample_label[4] = 1;
  easy_sample[10] = -1;   easy_sample[11] = 0.5;  easy_sample_label[5] = 1;
  easy_sample[12] = 1;    easy_sample[13] = -1;   easy_sample_label[6] = 2; // 第四象限 : ラベル2
  easy_sample[14] = 0.5;  easy_sample[15] = -1;   easy_sample_label[7] = 2;
  easy_sample[16] = 1;    easy_sample[17] = -0.5; easy_sample_label[8] = 2;
  easy_sample[18] = -0.5; easy_sample[19] = -1;   easy_sample_label[9] = 3; // 第三象限 : ラベル3
  easy_sample[20] = -1;   easy_sample[21] = -0.5; easy_sample_label[10] = 3;
  easy_sample[22] = -1;   easy_sample[23] = -1;   easy_sample_label[11] = 3;

  MCSVM mcsvm(4, 2, 12, easy_sample, easy_sample_label);
  mcsvm.learning();

  float *test = new float[2];
  int ans;
  for (float i = -1; i <= 1; i += 0.2) {
    for (float j = -1; j <= 1; j += 0.2) {
      test[0] = i; test[1] = j; ans = 0;
      if ( i < 0 ) { ans += 1; }
      if ( j < 0 ) { ans += 2; }
      printf("<TEST> [%f,%f] label : %d prob : %f answer : %d \r\n", test[0], test[1], mcsvm.predict_label(test), mcsvm.predict_probability(test), ans);
    }
  }
  // */
  
  delete [] test;

  return 0;
}

