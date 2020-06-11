#include "dort/filter.hpp"
#include "dort/sampled_filter.hpp"

namespace dort {
  SampledFilter::SampledFilter(std::shared_ptr<Filter> filter,
      Vec2i sample_radius):
    sample_radius(sample_radius),
    filter_to_sample_radius(Vec2(sample_radius) * filter->inv_radius),
    samples(sample_radius.x * sample_radius.y),
    radius(filter->radius)
  {
    Vec2 inv_sample_radius = 1.f / Vec2(this->sample_radius);
    for(int32_t y = 0; y < this->sample_radius.y; ++y) {
      for(int32_t x = 0; x < this->sample_radius.x; ++x) {
        uint32_t idx = y * this->sample_radius.x + x;
        float filter_x = float(x) * inv_sample_radius.x * filter->radius.x;
        float filter_y = float(y) * inv_sample_radius.y * filter->radius.y;
        this->samples.at(idx) = filter->evaluate(Vec2(filter_x, filter_y));
      }
    }
  }

  float SampledFilter::evaluate(Vec2 p) const {
    Vec2i sample_p = floor_vec2i(abs(p) * this->filter_to_sample_radius);
    if(sample_p.x >= this->sample_radius.x) {
      return 0.f;
    }
    if(sample_p.y >= this->sample_radius.y) {
      return 0.f;
    }
    uint32_t idx = sample_p.y * this->sample_radius.x + sample_p.x;
    return this->samples.at(idx);
  }
}
