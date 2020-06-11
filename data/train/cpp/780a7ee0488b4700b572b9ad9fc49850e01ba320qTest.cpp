#include <iostream>
#include "queue.h"

using namespace std;

int main() {
 
  Queue q(8);
  cout << "Tester: " << endl;
  q.dump();
  q.enqueue(10);
  q.enqueue(20);
  q.dump();
  q.dequeue();
  q.dump();
  q.enqueue(30);
  q.enqueue(40);
  q.enqueue(50);
  q.enqueue(60);
  q.dequeue();
  q.dump();
  q.dequeue();
  q.dump();
  q.dequeue();
  q.dump();
  q.dequeue();
  q.dump();
  q.enqueue(70);
  q.dump();
  q.enqueue(80);
  q.dump();
  q.enqueue(90);
  q.dump();
  q.dequeue();
  q.dequeue();
  q.dequeue();
  q.dequeue();
  q.dequeue();
  q.dequeue();
  q.dequeue();
  q.dequeue();

  cout << "Capacity of the Queue is: " << q.capacity() << endl;
  cout << "Out of Tester" << endl;
 
  return 0;
}
