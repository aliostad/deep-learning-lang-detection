#include <stdio.h>
#include <set>
using namespace std;

int T, TC=1, C, D, N, i;
int li, lj, lk, ret;
char combine[37][4], oppose[29][3], invoke[101];

int attempt_combine(int i)
{
	if(i==0) return 0;
	for(li=0; li < C; li++)
	{
		if((combine[li][0] == invoke[i] && combine[li][1] == invoke[i-1])
			||(combine[li][1] == invoke[i] && combine[li][0] == invoke[i-1]))
		{
			invoke[i-1] = combine[li][2];
			for(lj=i; lj < N; lj++)
				invoke[lj] = invoke[lj+1];
			N--;
			return i-1;
		}
	}
	return i;
}

int attempt_oppose(int i)
{
	if(i==0) return 0;
	for(li=0; li < D; li++)
	{
		if(oppose[li][0] == invoke[i])
		{
			lj = i - 1;
			while(lj >= 0)
			{
				if(invoke[lj] == oppose[li][1])
				{
					int ii = i+1;
					for(lk = 0; ii <= N; lk++, ii++)
						invoke[lk] = invoke[ii];
					N = N - i - 1;
					return 0;
				}
				else
					lj--;
			}
		}
		else if(oppose[li][1] == invoke[i])
		{
			lj = i - 1;
			while(lj >= 0)
			{
				if(invoke[lj] == oppose[li][0])
				{
					int ii = i+1;
					for(lk = 0; ii <= N; lk++, ii++)
						invoke[lk] = invoke[ii];
					N = N - i - 1;
					return 0;
				}
				else
					lj--;
			}
		}
	}
	return i;
}
int main ()
{
    for (scanf ("%d", &T); TC <= T; TC++)
    {
		scanf("%d", &C);
		for(i=0; i<C; i++)
			scanf(" %s", combine[i]);
		scanf(" %d", &D);
		for(i=0; i<D; i++)
			scanf(" %s", oppose[i]);
		scanf(" %d", &N);
		if(N)
		{
			memset(invoke, 0, 101);
			scanf(" %s", invoke);
			
			for(i=1; i<N; i++)
			{
				ret = attempt_combine(i);
				if(i == ret) //no change
					i = attempt_oppose(i);
				else
					i = ret;
			}
		}		
		printf ("Case #%d: [", TC);
		if(N>0)
		{
			printf("%c",invoke[0]);
			for(i=1; i<N; i++)
				printf(", %c",invoke[i]);
		}
		printf("]\n");
    }

    return 0;
}
