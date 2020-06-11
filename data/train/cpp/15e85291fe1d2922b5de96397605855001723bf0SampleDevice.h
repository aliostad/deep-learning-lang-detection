
# ifndef SAMPLE_DEVICE
# define SAMPLE_DEVICE

# include <nnt/Kernel/DriverApp.h>

# ifdef NNT_KERNEL_SPACE

NNTAPP_BEGIN

class Sample
    : public driver::App
{
public:

    Sample();
    ~Sample();

    int main();

};

class SampleWrite
    : public driver::feature::Write
{
public:

    SampleWrite();

    void main();

    pmp_inherit(SampleWrite);
    pmp_end;
};

class SampleRead
    : public driver::feature::Read
{
public:

    SampleRead();

    void main();

    pmp_inherit(SampleRead);
    pmp_end;
};

class SampleFunction
    : public driver::feature::CallIo<1>
{
public:

    SampleFunction();

    void main();

    pmp_inherit(SampleFunction);
    pmp_end;
};

NNTAPP_END

# endif

# endif
