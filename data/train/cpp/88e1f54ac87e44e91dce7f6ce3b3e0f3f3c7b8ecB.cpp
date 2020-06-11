#include <iostream>
#include <cstdio>
#include <vector>
#include <algorithm>
#include <stack>
#include <queue>
#include <map>
#define DEBUG(x) cout<<"line:"<<__LINE__<<", "<<#x" == "<<x<<endl;
using namespace std;

const int MAX_C = 36, MAX_D = 28, MAX_N = 100;
int T, C, D, N;
map<string, string> repl;
string clear[MAX_D];
string invoke;

void solve() {
  for (map<string, string>::iterator i = repl.begin(); i != repl.end(); i++) {
    string::size_type i1, i2;
    while (1) {
      i1 = invoke.find((*i).first);
      string tmp = (*i).first;
      reverse(tmp.begin(), tmp.end());
      i2 = invoke.find(tmp);
      if (i1 != string::npos && i2 != string::npos) {
        invoke = invoke.replace(min(i1,i2), 2, (*i).second);
      } else if (i1 != string::npos) {
        invoke = invoke.replace(i1, 2, (*i).second);
      } else if (i2 != string::npos) {
        invoke = invoke.replace(i2, 2, (*i).second);
      } else {
        break;
      }
    }
  }

  for (int i = 0; i < D; i++) {
    string::size_type index;
    while ((index = invoke.find(clear[i])) != string::npos) {
      invoke = invoke.replace(index, 2, "");
    }
  }
}

int main(int argc, char *argv[]) {
  scanf("%d", &T);
  for (int x = 1; x <= T; x++) {
    scanf(" %d", &C);
    repl.clear();
    for (int i = 0; i < C; i++) {
      char c1,c2,c3;
      scanf(" %c%c%c", &c1, &c2, &c3);
      string key, val;
      key += c1; key += c2;
      val += c3;
      repl.insert(map<string, string>::value_type(key, val));
    }

    scanf("%d", &D);
    for (int i = 0; i < D; i++) {
      char c1,c2;
      scanf(" %c%c", &c1, &c2);
      clear[i] = "";
      clear[i] += c1; clear[i]+=c2;
    }

    scanf("%d", &N);
    getc(stdin);
    invoke = "";
    for (int i = 0; i < N; i++) {
      invoke += getc(stdin);
    }

    solve();

    printf("Case #%d: [", x);
    for (unsigned int y = 0; y < invoke.length(); y++) {
      if (y == 0) printf("%c", invoke[y]);
      else printf(", %c", invoke[y]);
    }
    printf("]\n");
  }
  return 0;
}
