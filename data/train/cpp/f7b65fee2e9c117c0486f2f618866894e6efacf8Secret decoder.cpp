#include <iostream>
#include <stack>
#include <string>
using namespace std;

int main(){
    
    string input;
    cin >> input;
    stack<char> num, chara, chara2;
    for(int i = input.length(); i >= 0; i--){
        if(input[i] >= 48 && input[i] <= 57){
            num.push(input[i]);
        }else if(input[i] >= 65 && input[i] <= 90){
            chara.push(input[i]);
        }
    }
    for(stack<char>dump = chara; !dump.empty(); dump.pop()){
        chara2.push(dump.top());
    }
    //cout << num.size() << endl;
    //cout << chara.size() << endl;
    for(stack<char>dump = num; !dump.empty(); dump.pop()){
        cout << dump.top();
    }
    for(stack<char>dump = chara2; !dump.empty(); dump.pop()){
        cout << dump.top();
    }
    cout << endl;
    
    return 0;
}