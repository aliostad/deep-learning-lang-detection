#include<iostream>
#include<vector>
#include<cstdio>
#include<algorithm>
using namespace std;

int main (void)
{
    int n;
    while(scanf("%d", &n) == 1 && n)
    {
        vector<int> load;
        for(int i = 0; i < n; ++i)
        {
            int element;
            scanf("%d", &element);
            load.push_back(element);
        }

        sort(load.begin(), load.end());

        int cost = 0;
        if(n == 1) printf("%d\n", load[0]);
        else if(n == 2)printf("%d\n", load[0]+load[1]);
        else{
            while(1)
            {
                if(n == 1) break;
                int a = load[0];
                load.erase(load.begin());
                int b = load[0];
                load.erase(load.begin());
                load.insert(load.begin(), a+b);
                cost += (a+b);
                sort(load.begin(), load.end());
                n--;
            }

            printf("%d\n", cost);
        }


    }

    return 0;


}
