// Array initilization,
// In case of the dynamic array allocation, initilization logic shall be with expressed with mathematic express, with help of static or global elements.

#include <iostream>

using namespace std;
int const_i = 1 ;
class sample
{
    private :
        int i;
        float f;
    public:
        static int static_i;
    public:
        sample(int ii, float ff)
        {
            i = ii;
            f = ff;
            cout << "Constructor with ("<<i<<","<<f<<")"<<endl;
        }
        sample()
        {
            i = const_i;
            f = const_i++ + 1.5f;
            cout << "Constructor with ("<<i<<","<<f<<")"<<endl;
        }

        sample(int ii)
        {
            i = static_i;
            f = static_i++ + 1.5f;
            cout << "Constructor with ("<<i<<","<<f<<")"<<endl;
        }
    
        ~sample()
        {        
            cout << "Destructor with ("<<i<<","<<f<<")"<<endl;
        }

};
int sample :: static_i = 0;

int main()
{
    sample p[5] = {
        sample (1,2.5f),
        sample (2,3.5f),
        sample (3,4.5f),
        sample (4,5.5f),
        sample (5,6.5f)                    
    };

    sample *s  = new sample [10];

    delete []s;
  //  sample *s1 = new sample [] (120);

}

/*
 *  Need to check new operator with array allocation without default constructor
 *
 * */



