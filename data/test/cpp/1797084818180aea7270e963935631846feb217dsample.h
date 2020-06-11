/// sample.w 21
//@ @(sample.h@>=
#ifndef GONZO_SAMPLE_H
/// sample.w 22
#define GONZO_SAMPLE_H
/// sample.w 23
#include "coloralpha.h"
/// sample.w 24
#include "point2.h"
/// sample.w 25
namespace gonzo {
/// sample.w 26
/// sample.w 27
//@ @<Sample Class@>
/// sample.book 2
class Sample {
public:
//@ @<Sample Public Members@>
/// sample.book 6
Point2 position;

/// sample.book 8
ColorAlpha value;

/// sample.book 3
//@ @<Sample Public Methods@>
/// sample.book 10
Sample();

/// sample.book 12
~Sample() {}

/// sample.book 4
};

/// sample.w 28
/// sample.w 29
//@ @<Sample Operators@>
/// sample.book 16
std::ostream & operator<<( std::ostream & out, const Sample & sample );

/// sample.w 30
}
/// sample.w 31
#endif
/// sample.w 32

/// sample.w 33
