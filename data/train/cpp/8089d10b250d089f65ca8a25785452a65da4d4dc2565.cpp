#include <iostream>
#include <algorithm>
#include <string>
#define INF 1000010000
using namespace std;

int ston(string s){
    int ret=0;
    int i,j;
    if(s[0] == '-'){
        for(i=s.size()-1, j=1;i>=1;i--,j*=10){
            ret += -int(s[i]-'0')*j;
        }
    }else{
        for(i=s.size()-1, j=1;i>=0;i--,j*=10){
            ret += int(s[i]-'0')*j;
        }
    }
    return ret;
}

int main(){
    while(1){
        int n;
        int sample[1002];
        cin >> n;
        if(n == 0) break;
        for(int i=1;i<=n;i++){
            string s;
            cin >> s;
            if(s == "x"){
                if(i%2 == 0){
                    sample[i] = INF;
                }else{
                    sample[i] = -INF;
                }
            }else{
                sample[i] = ston(s);
            }
            //cout << sample[i] << ' ';
        }
        //cout << '\n';
        sample[0] = INF;
        if(n%2 == 0){
            sample[n+1] = -INF;
        }else{
            sample[n+1] = INF;
        }

        int mmin = -INF;
        int mmax = INF;
        bool nonef = false;
        for(int i=1;i<=n;i++){
            if(sample[i] == INF){
                mmin = max(max(sample[i-1],sample[i+1]) + 1,mmin);
                sample[i] = mmin;
            }
            if(sample[i] == -INF){
                mmax = min(min(sample[i-1],sample[i+1]) - 1,mmax);
                sample[i] = mmax;
            }
            if(i%2 == 0) if(sample[i] <= max(sample[i-1],sample[i+1])) nonef = true;
            if(i%2 == 1) if(sample[i] >= min(sample[i-1],sample[i+1])) nonef = true;
        }
        //cout << mmin << ' ' << mmax << '\n';
        if(mmin > mmax) nonef = true;
        if(nonef){
            cout << "none";
        }else{
            if(mmin == mmax){
                cout << mmin;
            }else if(mmin < mmax){
                cout << "ambiguous";
            }
        }
        cout << '\n';
    }
    return 0;
}
