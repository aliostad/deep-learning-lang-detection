#ifndef __SAMPLES_H__
#define __SAMPLES_H__

#include <string>
#include <memory>

class Sample {
    std::string name;        // the name of this sample

public:
    Sample(const std::string& aName) : name(aName) {}
    virtual ~Sample() {};
    virtual void run() = 0;
    std::string getName() { return name; }
};

typedef std::shared_ptr<Sample> SamplePtr;


class BitsSample : public Sample {
public:
    BitsSample();
    virtual void run();
};


class ForEachSample : public Sample {
public:
    ForEachSample();
    virtual void run();
};


class InitializerSample : public Sample {
public:
    InitializerSample();
    virtual void run();
};


class OutputSample : public Sample {
public:
    OutputSample();
    virtual void run();
};


class ShapeOperatorSample : public Sample {
public:
    ShapeOperatorSample();
    virtual void run();
};


class VTableSample : public Sample {
public:
    VTableSample();
    virtual void run();
};


class EnumSample : public Sample {
public:
    EnumSample();
    virtual void run();
};


class SizeofSample : public Sample {
public:
    SizeofSample();
    virtual void run();
};


class MapSample : public Sample {
public:
    MapSample();
    virtual void run();
};


#endif // __SAMPLES_H__
