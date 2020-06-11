#include <sstream>
#include <iostream>
#include <string>
using namespace std;

int main(){
    char *p_str = "(1 , 2 , 3 , 4 , 5)";
    string s(p_str);
    int i[5];
    char c;
    stringstream stream;
    stream << s;
    stream >> c;
    stream >> i[0];
    stream >> c;
    stream >> i[1];
    stream >> c;
    stream >> i[2];
    stream >> c;
    stream >> i[3];
    stream >> c;
    stream >> i[4];
    for(int j=0;j<5;++j) cout<<i[j]<<endl;
    cout<<stream.str()<<endl;

    cout << endl;
    int k;
    stream.str("");
    stream.clear();
    stream << "1";
    stream >> k;
    cout << k << " : " << stream.str() << endl;
    stream.str("");
    stream.clear();
    stream << " 2";
    stream >> k;
    cout << k << " : " << stream.str() << endl;
    stream.str("");
    stream.clear();
    stream << " 3";
    stream >> k;
    cout << k << " : " << stream.str() << endl;
    stream.str("");
    stream.clear();
    stream << " 4";
    stream >> k;
    cout << k << " : " << stream.str() << endl;
}
