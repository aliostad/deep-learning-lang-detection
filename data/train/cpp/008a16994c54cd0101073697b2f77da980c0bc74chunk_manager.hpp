#pragma once
#include "types.hpp"
#include "chunk.hpp"
#include "utility.hpp"
#include <future>
#include <cstdint>
#include <list>
#include <memory>
#include <tuple>
#include <map>

namespace lexov {

class chunk_renderer;

class chunk_manager {
public:
  chunk_manager(chunk_renderer &cr);
  void update(const world_size_t x, const world_size_t y, const world_size_t z);
  auto get_total_number_of_solid_blocks() const -> decltype(chunk::volume);
private:
  void insert_chunk(const chunk_key &key, chunk_ptr ptr); 
  void remove_chunk(const chunk_key &key);
  chunk_renderer &renderer;

  using chunk_map = std::map<chunk_key, chunk_ptr>;
  using weak_chunk_map = std::map<chunk_key, weak_chunk_ptr>;
  chunk_map all_chunks{};
};
} // namespace
