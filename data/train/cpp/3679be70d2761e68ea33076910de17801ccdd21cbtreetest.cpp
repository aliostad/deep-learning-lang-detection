#include <iostream>
#include <string>
using namespace std;
#include "btree.h"

int main(){
    BTree B;
    int key;
    string add;
    
    //YOU CAN UNCOMMENT BELOW TO BUILD A BTREE BASED ON COMMAND LINE INPUT
    cout << "Enter int(key) string(data) pair to insert (Control-D to quit) " << endl;
/*    while( cin >> key >> add ) {
        B.insert(key, add);
        //cout << "----printing tree----\n";
        //B.dump();
        //cout << "Enter int(key) string(data) pair to insert (Control-D to quit) " << endl;
    }*/
    B.dump();
     
    B.insert(1, "apple");
    cout << "----printing tree----\n";
    B.dump();
    
    
    B.insert(2, "baby");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(3, "carrot");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(4, "dog");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(5, "eat");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(6, "fly");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(7, "giggle");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(8, "hello");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(9, "island");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(10, "joy");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(11, "kind");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(12, "light");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(13, "merry");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(14, "nice");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(15, "orange");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(16, "puppy");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(17, "quite");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(18, "rose");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(19, "sandy");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(20, "tree");
    cout << "----printing tree----\n";
    B.dump();

    B.insert(21, "uncle");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(22, "viola");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(23, "wonderful");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(24, "xxoo");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(25, "young");
    cout << "----printing tree----\n";
    B.dump();
    
    B.insert(26, "zebra");
    cout << "----printing tree----\n";
    B.dump();
}


