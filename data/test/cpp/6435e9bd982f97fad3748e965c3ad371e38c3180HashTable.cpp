/*
 * HashTable.cpp
 *
 *  Created on: 2013-8-29
 *      Author: casa
 */

#include "HashTable.h"

HashTable::HashTable(unsigned n_buckets,unsigned bucket_size,unsigned tuple_size)
:n_buckets(n_buckets),bucket_size(bucket_size),tuple_size(tuple_size){
	//首先，申请指针空间，指向hashtable中的某一块
	buckets_start=(void **)malloc(sizeof(void *)*n_buckets);
	//先用block大小来对齐cache line的空间，再来申请内存
	repo_size=n_buckets*get_cacheline_aligned_space(bucket_size);
	//申请内存
	char *cur_repo=(char*)malloc(repo_size);
	repo_start=cur_repo;
	//内存清零
	memset(cur_repo,0,repo_size);
	//将这个内存仓库装进仓库list中，因为HashTable构造的时候是先分配一部分，
	//然后再插入的时候，可能hash表中一个hash值的bucket的个数不够，或者已
	//经仓库中的内存用完，就再要申请一些内存来分配
	repo_list.push_back(cur_repo);
	//已经从cur_repo中分出去的内存是0
	cur_repo_dis=0;

	for(unsigned i=0;i<n_buckets;i++){
		//如果剩下的空间不足cache line对齐的一块，再申请一个内存仓库
		if(get_cacheline_aligned_space(bucket_size)>(repo_size-cur_repo_dis)){
			cur_repo=(char*)malloc(repo_size);
			memset(cur_repo,0,repo_size);
			repo_list.push_back(cur_repo);
			cur_repo_dis=0;
		}
		//这里是以一个get_cacheline_aligned_space(bucket_size)的大小，而
		//并不是bucket_size的大小来分配的
		buckets_start[i]=(void *)(cur_repo+cur_repo_dis);
		cur_repo_dis+=get_cacheline_aligned_space(bucket_size);
		//一个bucket中的“最后一位和倒数第二位”是指向指针的指针
		//分别指向的是next(下一块)记录和free记录
		void **free=(void **)((char *)buckets_start[i]+bucket_size);
		void **next=(void **)((char *)buckets_start[i]+bucket_size+sizeof(void *));
		*free=buckets_start[i];
		*next=0;
	}
}

HashTable::~HashTable() {
	for(unsigned i=0;i<repo_list.size();i++){
		free(repo_list.at(i));
	}
	free(buckets_start);
}

//这个函数给tuple分配内存，参数是key经过hash之后应该放在hashtable中的哪个块中，
//然后返回的是分配之后的地址
void * HashTable::allocate(unsigned offset){
	//得到指向第offset块的指针
	void *data=(char *)repo_start+get_cacheline_aligned_space(bucket_size);
	//找到free的指针
	void **free_p=(void **)((char *)data+bucket_size);
	//定义一个返回的指针ret
	void *ret;
	//如果还能存下一块的话，就他妈存
	if((*free_p)<(char *)data+bucket_size-tuple_size){
		ret=*free_p;
		//更新那个free_p的值，因为你的free改变了
		*free_p=(char *)(*free_p)+tuple_size;
		return ret;
	}

	/*如果到这里了，证明相应的key所对应的bucket没有空间了，所以现在就是要再在内存仓
	库中申请内存，如果内存仓库中也没有了，那就再申请一个内存仓库*/

	//首先获取到现在的repo的地址
	char *cur_repo_=repo_list.at(repo_list.size()-1);

	if(get_cacheline_aligned_space(bucket_size)>(repo_size-cur_repo_dis)){
		cur_repo_=(char *)malloc(repo_size);
		memset(cur_repo_,0,repo_size);
		repo_list.push_back(cur_repo_);
		cur_repo_dis=0;
	}

	ret=cur_repo_+cur_repo_dis;
	cur_repo_dis+=get_cacheline_aligned_space(bucket_size);

	//将下一块的地址填入相应的位置
	void **next_p=(void **)((char *)data+bucket_size+sizeof(void *));
	*next_p=ret;

	//设置新申请的块的最后两个标志
	free_p=(void **)((char *)ret+bucket_size);
	*free_p=ret;
	next_p=(void **)((char *)ret+bucket_size-sizeof(void *));
	//最后一块
	*next_p=0;

	return ret;
}
