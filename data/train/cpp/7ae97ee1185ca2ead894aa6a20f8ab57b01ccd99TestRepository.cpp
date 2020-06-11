//
//  TestRepository.cpp
//  Contest_CPP
//
//  Created by Victor Ursan on 4/6/15.
//  Copyright (c) 2015 Victor Ursan. All rights reserved.
//

#include "TestRepository.h"
#include "Repository.cpp"

void test_getAll(Repository<int> *repo) {
  //vector<T> getAll();
  repo->save(1);
  repo->save(2);
  repo->save(3);
  repo->save(4);

  static const int arr[] = {1, 2, 3, 4};
  vector<int> vec (arr, arr + sizeof(arr) / sizeof(arr[0]) );
  assert(repo->getAll() == vec);
}

void test_save(Repository<int> *repo) {
  //void save(T p);
  repo->save(5);
  static const int arr[] = {1, 2, 3, 4, 5};
  vector<int> vec (arr, arr + sizeof(arr) / sizeof(arr[0]) );
  assert(repo->getAll() == vec);
}

void test_insertAtPosition(Repository<int> *repo) {
  //void insertAtPosition(int id, T p);
  repo->insertAtPosition(2, 6);
  static const int arr[] = {1, 2, 6, 3, 4, 5};
  vector<int> vec (arr, arr + sizeof(arr) / sizeof(arr[0]) );
  assert(repo->getAll() == vec);
}

void test_update(Repository<int> *repo) {
  //void update(int id, T p);
  repo->update(2, 7);
  static const int arr[] = {1, 2, 7, 3, 4, 5};
  vector<int> vec (arr, arr + sizeof(arr) / sizeof(arr[0]) );
  assert(repo->getAll() == vec);
}

void test_remove(Repository<int> *repo) {
  //void remove(int id);
  repo->remove(2);
  static const int arr[] = {1, 2, 3, 4, 5};
  vector<int> vec (arr, arr + sizeof(arr) / sizeof(arr[0]) );
  assert(repo->getAll() == vec);
}

void test_findById(Repository<int> *repo) {
  //const T findById(int id);
  assert(3 == repo->findById(2));
}

void test_size(Repository<int> *repo) {
  //int size();
  assert(repo->size() == 5);
}

void test_repository() {
  Repository<int> *repo = new Repository<int>(NULL);
  test_getAll(repo);
  test_save(repo);
  test_insertAtPosition(repo);
  test_update(repo);
  test_remove(repo);
  test_findById(repo);
  test_size(repo);
}