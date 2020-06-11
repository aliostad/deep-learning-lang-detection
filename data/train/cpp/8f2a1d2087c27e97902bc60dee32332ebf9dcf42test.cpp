#include "btree.h"

int test2() {
	BTree *root = BTree::getInstance();
	root->reset();
	root->insert("mmm","mmm");
	root->dump();
	root->insert("fff","fff");
	root->dump();
	root->insert("ccc","ccc");
	root->dump();
	root->insert("aaa","aaa");
	root->dump();
	root->insert("qqq","qqq");
	root->dump();
	root->insert("www","www");
	root->dump();
}

int test1() {
	BTree *root = BTree::getInstance();
	root->insert("aaa","aaa");
	root->dump();
	root->insert("ccc","ccc");
	root->dump();
	root->insert("fff","fff");
	root->dump();
	root->insert("mmm","mmm");
	root->dump();
	root->insert("qqq","qqq");
	root->dump();
	root->insert("www","www");
	root->dump();
}

int main( int argc, char**args ) {
	test1();
	test2();
	return 0;
}


