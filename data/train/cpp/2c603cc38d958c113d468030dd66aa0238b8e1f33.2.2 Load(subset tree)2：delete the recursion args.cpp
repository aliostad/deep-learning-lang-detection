#include <iostream>
using namespace std;



int maxLoad(int level);

//用全局变量来记录递归数据
int curLoad;//记录每次当前负载
int FinalLoad;//记录遍历到当前船最终最重负载
int w[5] = {3,5,4,3,2};
int num = 5;
int boatMax = 9;

int main()
{


    cout <<maxLoad(0)<<endl;
}

int maxLoad(int level)
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
    maxLoad(level+1);
    //2.1.3 repeal(none)

    //2.2 case 1
    if(curLoad + w[level] <= boatMax){
        //2.2.1 set
        curLoad += w[level];
        //2.2.2 recursion(level+1)
        maxLoad(level+1);
        //2.2.3 repeal
        curLoad -= w[level];
    }

    //3 return
    return FinalLoad;
}
