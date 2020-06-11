#include <iostream>
#include <queue>
using namespace std;

int enQueue(int curLoad, int level);
int maxLoadFunc();


int w[5] = {3,5,4,3,2};
int num = 5;
int boatMax = 9;

int main()
{
    cout <<maxLoadFunc()<<endl;
}

queue<int> que;
int curLoad = 0;
int maxLoad = 0;
int level = 0;

int maxLoadFunc()
{
    que.push(-1);

    while(1){

        enQueue(curLoad, level);

        if(curLoad+w[level] <= boatMax){
            enQueue(curLoad+w[level], level);
        }

        curLoad = que.front();
        que.pop();

        if(curLoad == -1 && que.empty()){
            return maxLoad;
        }else if(curLoad == -1 && !que.empty()){
            //3 things
            level++;
            que.push(-1);
            curLoad = que.front();
            que.pop();

        }else if(curLoad != -1){
            //nothing to do and continue;
        }
    }
}

int enQueue(int curLoad, int level)
{
    if(level+1 == num){

        if(curLoad > maxLoad){
            maxLoad = curLoad;
        }
    }else{
        que.push(curLoad);
    }
}
