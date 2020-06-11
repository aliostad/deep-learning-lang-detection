#include <iostream>
#include <vector>
#include <algorithm>
 
using namespace std;
 
static const int MAX_WEIGHT = 3000, MAX_LOAD = 3000;
 
int main()
{
    int N;
    while (cin >> N, N != 0) {
        vector<int> W(N + 1), L(N + 1);
        for (int i = 1; i <= N; ++i)
            cin >> W[i] >> L[i];
 
        vector<int> dp(MAX_WEIGHT + MAX_LOAD + 1, 0);
        for (int box = N; box >= 1; --box)
        {
            for (int load = L[box]; load >= 0; --load)
            {
                if (dp[load])
                    dp[load + W[box]] = max(dp[load + W[box]],
                                            dp[load] + 1);
            }
            if (dp[W[box]] == 0)
                dp[W[box]] = 1;
        }
        cout << *max_element(dp.begin(), dp.end()) << endl;
    }
    return 0;
}
