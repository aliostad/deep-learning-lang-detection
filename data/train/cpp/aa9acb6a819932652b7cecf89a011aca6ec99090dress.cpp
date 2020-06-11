#include <map>
#include <vector>
#include <iostream>
#include <sstream>
#include <boost/algorithm/string/replace.hpp>

using namespace std;


static std::string dress(string s)
{
    boost::replace_all(s , string("'"), string("''")); 
}


int main(int argc,char *argv[])
{

    string sample = "sample's";
    cout << "sample  " << sample << endl;
    boost::replace_all(sample , string("'"), string("''")); 
    cout << "becomes " << sample << endl;
    cout << "sample  " << sample << endl;
    boost::replace_all(sample , string("''"), string("'")); 
    cout << "becomes " << sample << endl;
 
}
