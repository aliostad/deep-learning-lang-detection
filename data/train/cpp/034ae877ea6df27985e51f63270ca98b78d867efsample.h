#pragma once

#include <algorithm>

namespace graphics
{

// A floating-point sample in the range 0.0 to 1.0.
class sample
{
public:
    // Constructs a sample, clipping the given value into the correct
    // range.
    constexpr sample(double) noexcept;

    // Constructs the 0.0 sample
    constexpr sample() noexcept : sample{0.0} {}

    // The double value of a sample.
    constexpr double value() const noexcept { return value_; }
    explicit constexpr operator double() const noexcept { return value_; }

    constexpr sample operator*(sample other) const noexcept;
    constexpr sample& operator*=(sample) noexcept;

private:
    double value_;
    // INVARIANT: 0.0 ≤ value_ ≤ 1.0
};

constexpr sample interpolate(sample a, sample weight, sample b) noexcept;

constexpr bool operator==(sample a, sample b) noexcept;
constexpr bool operator!=(sample a, sample b) noexcept;
constexpr bool operator<(sample a, sample b) noexcept;
constexpr bool operator<=(sample a, sample b) noexcept;
constexpr bool operator>(sample a, sample b) noexcept;
constexpr bool operator>=(sample a, sample b) noexcept;

constexpr sample operator+(sample, sample) noexcept;
constexpr sample& operator+=(sample&, sample) noexcept;

constexpr sample operator-(sample, sample) noexcept;
constexpr sample& operator-=(sample&, sample) noexcept;

constexpr sample operator/(sample, sample) noexcept;
constexpr sample& operator/=(sample&, sample) noexcept;

namespace
{

constexpr double saturate(double value) noexcept
{
    if (value < 0.0) return 0.0;
    if (value > 1.0) return 1.0;
    return value;
}

}

constexpr sample::sample(double value) noexcept
        : value_{saturate(value)}
{}

constexpr sample interpolate(sample a, sample weight, sample b) noexcept
{
    return sample{(1 - weight.value()) * a.value() + weight.value() * b.value()};
}

constexpr sample sample::operator*(sample other) const noexcept
{
    sample result;
    result.value_ = value() * other.value(); // can't overflow
    return result;
}

constexpr sample& sample::operator*=(sample other) noexcept
{
    value_ *= other.value(); // cannot overflow
    return *this;
}

constexpr sample operator+(sample a, sample b) noexcept {
    return sample{a.value() + b.value()};
}

constexpr sample& operator+=(sample& target, sample other) noexcept {
    return target = target + other;
}

constexpr sample operator-(sample a, sample b) noexcept {
    return sample{a.value() - b.value()};
}

constexpr sample& operator-=(sample& target, sample other) noexcept {
    return target = target - other;
}

constexpr sample operator/(sample a, sample b) noexcept {
    return sample{a.value() / b.value()};
}

constexpr sample& operator/=(sample& target, sample other) noexcept {
    return target = target / other;
}

constexpr bool operator==(sample a, sample b) noexcept
{ return a.value() == b.value(); }

constexpr bool operator!=(sample a, sample b) noexcept
{ return a.value() != b.value(); }

constexpr bool operator<(sample a, sample b) noexcept
{ return a.value() < b.value(); }

constexpr bool operator<=(sample a, sample b) noexcept
{ return a.value() <= b.value(); }

constexpr bool operator>(sample a, sample b) noexcept
{ return a.value() > b.value(); }

constexpr bool operator>=(sample a, sample b) noexcept
{ return a.value() >= b.value(); }
} // namespace graphics
