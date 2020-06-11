#include "SingletonSample.h"
#include <stdio.h>
#include <iostream>
using namespace std;

// 静态成员初始化
SingletonSample* SingletonSample::m_instance_ptr = NULL;

SingletonSample::SingletonSample() {
	cout << "Singleton::Singleton" << endl;
}

SingletonSample* SingletonSample::get_instance() {
	if (m_instance_ptr == NULL) {
		m_instance_ptr = new SingletonSample();
		if (m_instance_ptr == NULL) {
			cout << "new Singleton error!" << endl;
		}
	}

	return m_instance_ptr;
}

void SingletonSample::operation() {
	cout << "SingletonSample operation" << endl;
}