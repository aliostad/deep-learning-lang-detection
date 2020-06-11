#include <iostream>

#define __TESTING_NODES

#include "../lvec/node.cpp"

using namespace SAGE;
using namespace std;

int main()
{
  node n[11];

  cout << "Initial Nodes:" << endl;
  for(int i = 0; i < 11; ++i)
  {
    n[i].dump(cout,i);
  }

  edge e[10];

  cout << "\nInitial Edges:" << endl;
  for(int i = 0; i < 10; ++i)
  {
    if(i != 2) e[i] = edge(i, make_pair(i+1, i+2));
    else       e[2] = edge(i, make_pair(2,2));

    e[i].dump(cout);
  }
  cout << endl;

  n[0].add_edge(e[0], 0);
  n[1].add_edge(e[0], 1);

  cout << "TEST 1" << endl
       << "======" << endl;
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  e[0].dump(cout);
  cout << endl;

  cout << "TEST 2" << endl
       << "======" << endl;
  n[0].add_edge(e[1], 0);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  e[0].dump(cout);
  e[1].dump(cout); 
  cout << endl;

  cout << "TEST 3" << endl
       << "======" << endl;
  n[2].add_edge(e[1], 1);

  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  cout << endl;
 
  // Try something that's simply not right.
  cout << "TEST 4" << endl
       << "======" << endl;
  cout << (n[0].add_edge(e[4],0)) << endl;

  e[2] = edge(2, make_pair(2,1));

  cout << (n[1].add_edge(e[2],0)) << endl;
  cout << (n[2].add_edge(e[2],1)) << endl;

  n[2].remove_edge();
  n[1].remove_edge();

  e[2].dump(cout);

  cout << endl;

  cout << "TEST 5" << endl
       << "======" << endl;

  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  cout << endl;

  cout << "TEST 6" << endl
       << "======" << endl;
  // Remove the edge, see what happens.
  n[2].remove_edge();
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  cout << endl;
 
  cout << "TEST 7" << endl
       << "======" << endl;
  n[0].remove_edge();

  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  cout << endl;

  cout << "TEST 8" << endl
       << "======" << endl;
  e[1] = edge(1, make_pair(2,1));

  n[0].add_edge(e[1],0);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  cout << endl;

  cout << "TEST 9" << endl
       << "======" << endl;
  n[2].add_edge(e[1],1);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout); 
  cout << endl;

  cout << "TEST 9.1" << endl
       << "========" << endl;
  n[2].add_edge(e[2],0);
  n[1].add_edge(e[2],1);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout); 
  cout << endl;

  e[3] = edge(3, make_pair(2,2));

  cout << "TEST 9.2" << endl
       << "========" << endl;
  cout << n[1].add_edge(e[3],0) << endl << endl;
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout); 

  n[2].remove_edge();
  n[1].remove_edge();

  cout << "\nTEST 10" << endl
       << "=======" << endl;
  e[2] = edge(2, make_pair(2,2));

  n[2].add_edge(e[2],0);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  cout << endl;

  cout << "TEST 11" << endl
       << "=======" << endl;
  n[2].remove_edge();
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  cout << endl;

  cout << "TEST 12" << endl
       << "=======" << endl;
  e[4] = edge(4, make_pair(2,1));
  e[5] = edge(5, make_pair(2,1));

  n[2].add_edge(e[3],0);
  n[3].add_edge(e[3],1);
  n[4].add_edge(e[4],0);
  n[0].add_edge(e[4],1);
  n[1].add_edge(e[5],0);
  n[5].add_edge(e[5],1);

  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  n[5].remove_edge();
  n[1].remove_edge();
  n[0].remove_edge();
  n[4].remove_edge();
  n[3].remove_edge();
  n[2].remove_edge();

  cout << "TEST 12.1" << endl
       << "=========" << endl;
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  cout << "TEST 12.5" << endl
       << "=========" << endl;
  e[3] = edge(3, make_pair(2,1));
  e[4] = edge(4, make_pair(2,1));
  e[5] = edge(5, make_pair(2,1));

  n[2].add_edge(e[3],0);
  n[3].add_edge(e[3],1);
  n[4].add_edge(e[4],0);
  n[0].add_edge(e[4],1);
  n[1].add_edge(e[5],0);
  n[5].add_edge(e[5],1);

  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  //Test to see if fixing one of them works correctly
  cout << "TEST 12.6" << endl
       << "=========" << endl;
  n[2].fix(0);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  n[2].unfix();
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  n[2].fix(1);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  n[2].unfix();
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  cout << "TEST 13" << endl
       << "=======" << endl;
  n[2].add_edge(e[2],0);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  cout << "TEST 14" << endl
       << "=======" << endl;
  n[2].remove_edge();
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  cout << "TEST 15" << endl
       << "=======" << endl;
  n[5].add_edge(e[2],0);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  cout << "TEST 16" << endl
       << "=======" << endl;
  n[0].add_edge(e[2],0);
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  cout << "TEST 17" << endl
       << "=======" << endl;
  n[0].remove_edge();
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  cout << "TEST 18" << endl
       << "=======" << endl;
  cout << n[2].add_edge(e[2],0) << endl << endl;
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  cout << endl;

  cout << "TEST 19" << endl
       << "=======" << endl;
  n[6].add_edge(e[6],0);
  n[7].add_edge(e[6],1);

  e[7] = edge(7, make_pair(7,8));

  n[7].add_edge(e[7],0);
  n[8].add_edge(e[7],1);

  n[9].add_edge(e[8],0);
  n[10].add_edge(e[8],1);

  n[6].dump(cout,0);
  n[7].dump(cout,1);
  n[8].dump(cout,2);
  n[9].dump(cout,3);
  n[10].dump(cout,4);
  e[6].dump(cout);
  e[7].dump(cout); 
  e[8].dump(cout);
  cout << endl;

  cout << "TEST 20" << endl
       << "=======" << endl;
  e[9] = edge(9, make_pair(7,10));

  n[8].add_edge(e[9],0);

  n[6].dump(cout,0);
  n[7].dump(cout,1);
  n[8].dump(cout,2);
  n[9].dump(cout,3);
  n[10].dump(cout,4);
  e[6].dump(cout);
  e[7].dump(cout); 
  e[8].dump(cout);
  cout << endl;

  cout << "TEST 21" << endl
       << "=======" << endl;
  n[10].add_edge(e[9],1);
  n[6].dump(cout,0);
  n[7].dump(cout,1);
  n[8].dump(cout,2);
  n[9].dump(cout,3);
  n[10].dump(cout,4);
  e[6].dump(cout);
  e[7].dump(cout); 
  e[8].dump(cout);
  cout << endl;

  cout << "TEST 22" << endl
       << "=======" << endl;
  n[10].remove_edge();
  n[8].remove_edge();
  n[0].dump(cout,0);
  n[1].dump(cout,1);
  n[2].dump(cout,2);
  n[3].dump(cout,3);
  n[4].dump(cout,4);
  n[5].dump(cout,5);
  n[6].dump(cout,0);
  n[7].dump(cout,1);
  n[8].dump(cout,2);
  n[9].dump(cout,3);
  n[10].dump(cout,4);
  e[0].dump(cout);
  e[1].dump(cout); 
  e[2].dump(cout);
  e[3].dump(cout);
  e[4].dump(cout); 
  e[5].dump(cout);
  e[6].dump(cout);
  e[7].dump(cout); 
  e[8].dump(cout);
  cout << endl;

}
