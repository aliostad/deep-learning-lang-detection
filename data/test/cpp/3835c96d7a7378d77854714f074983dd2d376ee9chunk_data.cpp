/*
 * chunk.cpp
 *
 *  Created on: Jul 18, 2008
 *      Author: vjeko
 */

#include "chunk_data.hpp"

namespace colony {

namespace storage {

chunk_data::chunk_data() :
    chunk_metadata(),
    data_ptr_(new data_type) {

}

chunk_data::chunk_data(std::string s) :
    chunk_metadata(),
    data_ptr_( new data_type ) {

  data_ptr_->assign( s.begin(), s.end() );

}

chunk_data::chunk_data(
    chunk_metadata::uid_type         uid,
    chunk_metadata::cuid_type        cuid) :

      chunk_metadata(uid, cuid),
      data_ptr_(new data_type) {}


chunk_data::chunk_data(key_type key) :

    chunk_metadata(key),
    data_ptr_(new data_type) {}

chunk_data::chunk_data(
    chunk_metadata::uid_type         uid,
    chunk_metadata::cuid_type        cuid,
    boost::shared_ptr<data_type>     data_ptr) :

      chunk_metadata(uid, cuid),
          data_ptr_(new data_type){

  (*data_ptr_) = (*data_ptr);

}

chunk_data::chunk_data(
    chunk_metadata                  metadata,
    boost::shared_ptr<data_type>    data_ptr) :

      chunk_metadata(metadata),
      data_ptr_(new data_type){

  (*data_ptr_) = (*data_ptr);

}

chunk_data::~chunk_data() {
	// TODO Auto-generated destructor stub
}

} // namespace storage

} // namespace colony
