#ifndef SAMPLE_HPP
#define SAMPLE_HPP

#include <QVector>

template < typename D, unsigned int n>
class Sample {
private:
    QVector< D > data;

public:
    typedef D value_type;

    Sample() {}
    Sample( const decltype(data) & rData ) : data( rData ) {}

    const decltype(data) & getData() const {
        return data;
    }

    decltype(data) & getData() {
        return data;
    }

    Sample( const Sample & rSample ) : data( rSample.getData() ) {}

    Sample & operator = ( const Sample & rSample ) {
        data = rSample.getData();
        return *this;
    }
};

#endif // SAMPLE_HPP
