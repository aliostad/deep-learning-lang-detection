#include <iostream>
#include <string>
#include "rbbst.h"

using namespace std;

int main(int argc, char const *argv[])
{
	RedBlackTree<int, string> sample;
	sample.insert(make_pair(10,"haha"));
	sample.insert(make_pair(20,"haha"));
	sample.insert(make_pair(30,"haha"));
	sample.insert(make_pair(15,"haha"));
	sample.insert(make_pair(25,"haha"));
	sample.insert(make_pair(12,"haha"));
	sample.insert(make_pair(5,"haha"));
	sample.insert(make_pair(3,"haha"));
	sample.insert(make_pair(8,"haha"));
	sample.insert(make_pair(27,"haha"));
	sample.insert(make_pair(40,"haha"));
	sample.insert(make_pair(50,"haha"));
	sample.insert(make_pair(45,"haha"));
	sample.insert(make_pair(9,"haha"));


	sample.print();
	return 0;
}