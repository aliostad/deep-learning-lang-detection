//
// Created by Mikhail Usvyatsov on 31.10.15.
//

#include "chunk.h"
#include "storage.h"
#include "exceptions.h"

Chunk::Chunk() {
    id_ = -1;
    data_ = nullptr;
}

Chunk::~Chunk() {
    delete[] data_;
}

long long int Chunk::get_id() {
    return id_;
}

void Chunk::set_id(long long int id) {
    id_ = id;
}

void Chunk::set_length(unsigned long int length) {
    length_ = length;
}

Chunk* Chunk::load(long long int bin_id, long long int chunk_id) {
    return Storage::get_instance()->read(bin_id, chunk_id);
};

char* Chunk::get_data() {
 return data_;
}

unsigned long int Chunk::get_length() {
    return length_;
}

void Chunk::set_data(char* chunk_data, unsigned long int data_length) {
    if (data_ != nullptr) {
        throw BrokenOrderException();
    }

    data_ = chunk_data;

    length_ = data_length;
}
