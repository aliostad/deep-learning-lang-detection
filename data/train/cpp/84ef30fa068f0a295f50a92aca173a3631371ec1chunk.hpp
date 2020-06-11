#pragma once
#include "types.hpp"
#include "chunk_array.hpp"
#include <memory>

namespace lexov {

using chunk = array_chunk<chunk_width, chunk_height, chunk_depth>;

using chunk_ptr = std::shared_ptr<chunk>;
using weak_chunk_ptr = std::weak_ptr<chunk>;

template <class Function>
inline void for_each_voxel(chunk &c, const Function &f) {
  for (auto z = 0; z < chunk::depth; ++z) {
    for (auto y = 0; y < chunk::height; ++y) {
      for (auto x = 0; x < chunk::width; ++x) {
        f(c, x, y, z);
      }
    }
  }
}

} // namespace lexov
