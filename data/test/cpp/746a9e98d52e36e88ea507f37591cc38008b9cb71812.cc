#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <utility>

using namespace std;

struct Group {
    int t, m;
};

struct State {
    int n;
    Group v[20];
};

void compact(State& s, int invoke) {
    if (s.v[invoke].m >= 3) {
        int i;
        for(i = 1; invoke-i >= 0 && invoke+i < s.n; i++) {
            if (s.v[invoke-i].t != s.v[invoke+i].t ||
                s.v[invoke-i].m + s.v[invoke+i].m < 3)
                break;
        }
        if (invoke-i < 0 && invoke+i >= s.n) {
            s.n = 0;
        }
        else if (invoke-i >= 0) {
            s.n = invoke-i+1;
        }
        else {
            int pos = invoke+i;
            for(int j = 0; j < s.n-pos; j++)
                s.v[j] = s.v[pos+j];
            s.n = s.n - pos;
        }
    }
}

void search(int depth, const State& s, const vector<int>& h, int lim) {
    if (s.empty())
        throw lim;
    State t;
    for(int i = 0; i < s.n; i++) {
        
    }
}

int main() {

    int nCases;
    cin >> nCases;

    for(int iCase = 0; iCase < nCases; iCase++) {

        int n, k;
        cin >> n >> k;
        vector<int> v(n), h(k);
        {
            const char S[] = "RYBGW";
            string s, t;
            cin >> s >> t;
            for(int i = 0; i < n; i++)
                v[i] = (find(S, S+5, s[i]) - S);
            for(int i = 0; i < k; i++)
                h[i] = (find(S, S+5, t[i]) - S);
        }

        State s;
        s.n = 0;
        for(int i = 0; i < n; ) {
            int j;
            for(j = i+1; j < n; j++)
                if (v[j] != v[i])
                    break;
            s.v[s.n].t = v[i];
            s.v[s.n].m = j-i;
            s.n++;
            i = j;
        }

        try {
            for(int lim = 1; lim <= k; lim++)
                search(0, s, h, lim);
            printf("lose\n");
        }
        catch(int lim) {
            printf("%d\n", lim);
        }

    }

    return 0;
}

