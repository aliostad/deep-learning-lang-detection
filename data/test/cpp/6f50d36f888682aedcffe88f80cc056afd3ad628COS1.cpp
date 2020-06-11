#include "../include/transform.h"
#include<iostream>

using namespace std;

int main(){
  COS model(64,0,0,true);
  cout<<model.N()<<endl
      <<"("<<model.LowerBound()<<","<<model.UpperBound()<<")"<<endl
      <<model.isValid()<<endl;

  model.LowerBound(2);

  cout<<"("<<model.LowerBound()<<","<<model.UpperBound()<<")"<<endl
      <<model.isValid()<<endl;

  model.UpperBound(3);
   cout<<"("<<model.LowerBound()<<","<<model.UpperBound()<<")"<<endl
      <<model.isValid()<<endl;

  model.Bounds(-1,-1);
   cout<<"("<<model.LowerBound()<<","<<model.UpperBound()<<")"<<endl
      <<model.isValid()<<endl;

  return 0;
  }
