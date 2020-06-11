/*
	1/8BIT(grayscale) pixel chunk
	Author :  Dimitris Vlachos (DimitrisV22@gmail.com @ github.com/DimitrisVlachos)
*/
#ifndef __pixel_chunk_hpp__
#define __pixel_chunk_hpp__
#include "types.hpp"

struct partition_entry_t {
	const uint8_t* base;
	uint32_t w,h;
};

struct pixel_chunk_t {
	uint32_t w,h,bpp,stride,angle,compressed;
	uint8_t* pixels ;
};

pixel_chunk_t* pixel_chunk_new(const std::string& path);
pixel_chunk_t* pixel_chunk_new_mapped(const std::string& path);
pixel_chunk_t* pixel_chunk_upscale(pixel_chunk_t* in_chunk,const uint32_t factor);
pixel_chunk_t* pixel_chunk_upscale_mt(pixel_chunk_t* in_chunk,const uint32_t factor);
pixel_chunk_t* pixel_chunk_compress(pixel_chunk_t* in_chunk);
pixel_chunk_t* pixel_chunk_duplicate(pixel_chunk_t* in_chunk);
void pixel_chunk_rotate(pixel_chunk_t* in_chunk,const uint32_t angle,std::vector<uint32_t>& res);
void pixel_chunk_delete(pixel_chunk_t* chunk);
bool pixel_chunk_dump(pixel_chunk_t* in_chunk,const std::string& path);
#endif

