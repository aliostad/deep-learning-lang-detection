#include <iostream>
using namespace std;

int maxLoad(int *w, int num, int boatMax, int level);

int curLoad;
int FinalLoad;
int main()
{
    int w[5] = {3,5,4,3,2};
    int boatMax = 9;

    cout <<maxLoad(w, 5, boatMax, 0)<<endl;
}


int maxLoad(int *w, int num, int boatMax, int level)
{
    //1 lefe-node: end condition
    if(level >= num){

        if(FinalLoad < curLoad){
            FinalLoad = curLoad;
        }

        return FinalLoad;
    }

    //2 nonleaf-node: deal detail
    //2.1 case 0
    //2.1.1 set(none)
    //2.1.2 recursion(level+1)
    maxLoad(w, num, boatMax, level+1);
    //2.1.3 repeal(none)

    //2.2 case 1
    if(curLoad + w[level] <= boatMax){
        //2.2.1 set
        curLoad += w[level];
        //2.2.2 recursion(level+1)
        maxLoad(w, num, boatMax, level+1);
        //2.2.3 repeal
        curLoad -= w[level];
    }

    //3 return
    return FinalLoad;
}
