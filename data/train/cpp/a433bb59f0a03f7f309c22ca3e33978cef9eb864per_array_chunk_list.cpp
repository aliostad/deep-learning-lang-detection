/*
 * per_array_chunk_list.cpp
 *
 *  Created on: Jul 21, 2015
 *      Author: basbas
 */

#include "per_array_chunk_list.h"

namespace sip {

std::ostream& operator<<(std::ostream& os, const Chunk& obj){
	os << "data_: " << obj.data_;
	os << ", file_offset_: " << obj.file_offset_;
	os << " num_allocated_doubles_: "<< obj.num_allocated_doubles_;
	os << " valid_on_disk_: " << obj. valid_on_disk_;
	os << std::endl;
	return os;
}


size_t ChunkManager::new_chunk() {

	double* chunk_data = new double[chunk_size_];
    int chunk_number = chunks_.size();
	SIPMPIAttr& mpi_attr = SIPMPIAttr::get_instance();
	int num_servers = mpi_attr.company_size();
	int rank = mpi_attr.company_rank();
	offset_val_t offset = (num_servers*chunk_number + rank) * chunk_size_;
	//if c++11, change to emplace version
	chunks_.push_back(Chunk(chunk_data, chunk_size_, offset, false));
	return chunk_size_;
}

size_t ChunkManager::assign_block_data_from_chunk(size_t num_doubles, bool initialize,
		int& chunk_number, size_t& offset){
	size_t num_newly_allocated = 0;
	//get current chunk
	chunks_t::reverse_iterator chunk_it = chunks_.rbegin();  //last iterator
	//if not enough space, allocate a new chunk and update chunk_it
	if (chunk_it == chunks_.rend() || (chunk_size_ - chunk_it->num_assigned_doubles_)) < num_doubles){
		num_newly_allocated = new_chunk();
		chunk_it = chunks_.rbegin();
	}
	//number of current chunk
	chunk_number = chunks_.size-1;  //chunks_.size > 0 here.
	//offset relative to beginning of chunk
	offset = chunk_it->num_assigned_doubles_;
	chunk_it->num_assigned_doubles_ += num_doubles;
	if (initialize){
		std::fill(chunk_it->data_+offset, chunk_it->data_+offset + num_doubles, 0);
	}
	return num_newly_allocated;
}

size_t ChunkManager::delete_chunk_data(Chunk& chunk){
	if(chunk.data_ != NULL){
		delete chunk.data_;
		chunk.data_ = NULL;
		return chunk_size_;
	}
	return 0;
}

size_t ChunkManager::delete_chunk_data_all(){
	size_t num_deleted = 0;
	chunks_t::iterator it;
	for(it = chunks_.begin(); it != chunks_.end(); ++it){
		num_deleted += delete_chunk_data(*it);
	}
	return num_deleted;
}

} /* namespace sip */
