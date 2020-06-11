#include"poly_array_version.h"
#include<iostream>

//函数实现部分	
	//构造函数
poly::poly(){
	a=0;
	x=0;
}
	//输出
	void display(poly* sample ){
	for (int i=0;i<MAX;i++){
	//	if ((sample+i)->x==0)
	//		continue;
		std::cout<<"a:"<<sample[i].a<<"   "<<"x:"<<sample[i].x<<std::endl;
	}
	}
	//设置单项式
	void set(poly* poly_s,int x,double a){
		poly_s->a=a;
		poly_s->x=x;
	}
	//查找
	poly* search(poly* sample,int x)
	{
		for(int i=0;i<=MAX;i++)
		{
			if (sample[i].x==x)
				return sample+i;
		}
		return NULL;
	}
	//插入
	void insert(poly* sample,int x,double a){
		for (int i = 0; i < MAX; i++)
			if ((sample+i)->a==0){
				(sample+i)->a=a;
				(sample+i)->x=x;
				break;
			}
	}
	//删除
	void godie(poly*sample,int x){
		poly *index;
		do{
			index=search(sample,x);
			for(int i=0;(index-sample+i)<=MAX;i++)
			{
				if (!index) break;
				//防止数组越界
				if((index-sample+i+1)==MAX)
					{index[i].a=0;
					index[i].x=0;
					break;
					}
				index[i].a=index[i+1].a;
				index[i].x=index[i+1].x;
			}
		}while(index!=NULL);
	}
	//修改(按指数查找)
	void change(poly*  sample,int x,double a)
	{
		search(sample,x)->a=a;
	}
	//排序
	void sort(poly* sample)
	{
		double a;int x;
		for (int i = 0; i < MAX-1; i++)
		{
			for (int j = i+1; j < MAX; j++)
			{
				if(((sample+i)->x)<((sample+j)->x))
				{
					a=(sample+i)->a;
					x=(sample+i)->x;
					(sample+i)->x=(sample+j)->x;
					(sample+i)->a=(sample+j)->a;
					(sample+j)->a=a;
					(sample+j)->x=x;
				}
			}
		}
	}