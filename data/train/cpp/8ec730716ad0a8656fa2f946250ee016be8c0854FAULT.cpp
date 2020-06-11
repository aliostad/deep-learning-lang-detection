#include<iostream>
#include<limits.h>
using namespace std;

int chunk[200][1000];

int main()
{
	int n,s;
	cin>>n>>s;
	
	for(int i=0;i<s;i++)
	{
		int c;
		cin>>c;
		for(int j=0;j<c;j++)
		{
			int x;
			cin>>x;
			
			chunk[x][0]++;
			
			chunk[x][chunk[x][0]]=i;	
		}
	}
	int min=INT_MAX;
	int minpos=-1;
	for(int i=0;i<n;i++)
	{
		if(min>chunk[i][0])
		{
			min=chunk[i][0];
			minpos=i;
		}
	}
	/*
	for(int i=0;i<n;i++)
	{
		cout<<"Servers =>" <<chunk[i][0]<<"\t";
		for(int j=1;j<=chunk[i][0];j++)
		{
			cout<<chunk[i][j];
		}
		cout<<endl;
	}
	
	cin.get();*/
	cout<<chunk[minpos][0]<<endl;
	for(int i=1;i<=chunk[minpos][0];i++)
	{
		cout<<chunk[minpos][i]<<endl;
	}
	return 0;
}
