#ifndef SAMPLE_H
#define SAMPLE_H 
#include <cstdint>
#include <ostream>
class Sample {
    int16_t sample_;
public:
    typedef int16_t underlying;
    constexpr Sample(): sample_{} {}
    constexpr Sample(underlying sample_init): sample_{} {}
    underlying value() const;
    static Sample max_intensity();
    bool operator==(const Sample& other) const;
    bool operator<(const Sample& other) const;
    bool operator>(const Sample& other) const;
    Sample operator+(const Sample& other) const;
    Sample& operator+=(const Sample& other);
    Sample operator/(const underlying& other) const;
};
std::ostream& operator<<(std::ostream& stream, const Sample& sample);
#endif /* SAMPLE_H */
