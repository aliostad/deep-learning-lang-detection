void main(void);
#include "E:\School\Programming\tensor++\tensor.hpp"

void main(void)
{
  tensor A(3,3,2,3);
  tensor B(3,3,2,3);
  tensor C;
  tensor D(1,3), E(1,2), F(1,4);
  tensor G(2,3,2), H;

  char *dump;
  dump = NULL;

  int i, j, k;

  FILE *skippy;
  skippy = fopen("tensor_test.txt","w");

  A.Set(-19,1,1,1);
  A.print("A",&dump);
  fprintf(skippy,"A.Set(-19,1,1,1)\n");
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"A.max() = %g\n\n",A.max());

  A.ScalarMult(1.0/19.0);
  A.print("A",&dump);
  fprintf(skippy,"A.ScalarMult(1.0/19.0)\n");
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"A.max() = %g\n\n",A.max());

  for( i = 0; i < 3; i++) for( j = 0; j < 2; j++) for( k = 0; k < 3; k++)
        B.Set(1,i,j,k);

  for( i = 0; i < 3; i++) D.Set(sqrt(i),i);
  for( j = 0; j < 2; j++) E.Set(-1+j,j);
  for( k = 0; k < 4; k++) F.Set(2*k,k);

  B.print("B",&dump);
  fprintf(skippy,"B.Set(1,i,j,k)\n");
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"B.max() = %g\n\n",B.max());

  D.print("D",&dump);
  fprintf(skippy,"D.Set(sqrt(i),i)\n");
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"D.max() = %g\n\n",D.max());

  E.print("E",&dump);
  fprintf(skippy,"E.Set(-1+j,j)\n");
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"E.max() = %g\n\n",E.max());

  F.print("F",&dump);
  fprintf(skippy,"F.Set(2*k,k)\n");
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"F.max() = %g\n\n",F.max());

  C = A + B;
  C.print("C",&dump);
  fprintf(skippy,"C = A + B\n");
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"C.max() = %g\n\n",C.max());

  C = A + A + B;
  fprintf(skippy,"C = A + A + B\n");
  C.print("C",&dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"C.max() = %g\n\n",C.max());

  C = B - A;
  fprintf(skippy,"C = B - A\n");
  C.print("C",&dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"C.max() = %g\n\n",C.max());

  G = D*E;
  fprintf(skippy,"G = D*E\n");
  G.print("G",&dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"G.max() = %g\n\n",G.max());

  H = D*E*F;
  fprintf(skippy,"H = D*E*F\n");
  H.print("H",&dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"H.max() = %g\n\n",H.max());

  C = A.Contract(B,2,2);
  fprintf(skippy,"C = A.Contract(B,2,2)\n");
  C.print("C",&dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"C.max() = %g\n\n",C.max());

  A <= B;
  fprintf(skippy,"A <= B\n");
  A.print("A", &dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"A.max() = %g\n\n",A.max());

  B.ScalarMult(0.0);
  fprintf(skippy,"B.ScalarMult(0.0)\n");
  B.print("B", &dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"B.max() = %g\n\n",B.max());

  fprintf(skippy,"A <= B recheck\n");
  A.print("A", &dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"A.max() = %g\n\n",A.max());

  fprintf(skippy,"A has %d indices\n",A.NumIndices());
  int *range = A.Ranges();
  fprintf(skippy,"with ranges %d %d %d\n\n", range[0], range[1], range[2]);

  C = A*5.0;
  fprintf(skippy,"C = A*5.0\n");
  C.print("C", &dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"C.max() = %g\n\n",C.max());

  D <= C;
  fprintf(skippy,"D <= C\n");
  D.print("D", &dump);
  fprintf(skippy,"%s",dump);
  fprintf(skippy,"D.max() = %g\n\n",D.max());

  fclose(skippy);
}

