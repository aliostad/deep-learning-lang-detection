//
// Created by Timothy Shull on 12/20/15.
//

#ifndef CPPCOOKBOOK_SAMPLE_CLASS_H
#define CPPCOOKBOOK_SAMPLE_CLASS_H

template<typename T>
class SampleClass {
    T m, n;
public:
    SampleClass() { }

    SampleClass(T n) : n(n) { }

    SampleClass(T m, T n) : m(m), n(n) { }

    T getM() const {
        return m;
    }

    void setM(T m) {
        SampleClass::m = m;
    }

    T getN() const {
        return n;
    }

    void setN(T n) {
        SampleClass::n = n;
    }
};

#endif //CPPCOOKBOOK_SAMPLE_CLASS_H
