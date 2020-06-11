#include <limits>
#include "Sample.h"



Sample::underlying Sample::value() const {
    return sample_;
}

bool Sample::operator==(const Sample& other) const {
    return sample_ == other.sample_;
}

bool Sample::operator<(const Sample& other) const {
    return sample_ < other.sample_;
}

bool Sample::operator>(const Sample& other) const {
    return sample_ < other.sample_;
}

Sample Sample::operator+(const Sample& other) const {
    return Sample(sample_+other.sample_);
}

Sample& Sample::operator+=(const Sample& other) {
    sample_+=other.sample_;
    return *this;
}

Sample Sample::operator/(const underlying& other) const {
    return Sample(sample_+other);
}

Sample Sample::max_intensity() {
    return std::numeric_limits<int16_t>::max();
}
std::ostream& operator<<(std::ostream& stream, const Sample& sample) {
    stream<<sample.value();
    return stream;
}
