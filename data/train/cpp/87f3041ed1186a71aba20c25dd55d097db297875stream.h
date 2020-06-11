#include <iostream>

class Stream
{
public:
    virtual ~Stream() {}
    virtual Stream* clone() const = 0;

    virtual Stream& operator>>(size_t&) = 0;
    virtual Stream& operator>>(std::ostream&) = 0;
    friend size_t operator+(Stream&, Stream&);
    friend size_t operator^(Stream&, Stream&);
};

size_t operator+(Stream& s1, Stream& s2)
{
    size_t a, b;
    s1 >> a;
    s2 >> b;
    return a + b;
}

size_t operator^(Stream& s1, Stream& s2)
{
    size_t a, b;
    Stream* s1c = s1.clone();
    Stream* s2c = s2.clone();
    (*s1c) >> a;
    (*s2c) >> b;
    delete s1c;
    delete s2c;
    return a + b;
}

