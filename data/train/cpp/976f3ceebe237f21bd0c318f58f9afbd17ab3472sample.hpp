
#ifndef SAMPLE_H
#define SAMPLE_H

#include "interval.hpp"
#include "point.hpp"
#include "gnuplot.hpp"
#include "plotBox.hpp"
#include <vector>

template <unsigned int N, typename T>
struct Sample {
  
    explicit Sample(const Interval<T> &interval, T x[] = nullptr, T y[] = nullptr);
    explicit Sample(const Interval<T> &interval, const std::function<Point<T>(unsigned int, Interval<T>)> &lambda);
    
    Sample(const Sample<N,T> &other);
    
    template <unsigned int P, unsigned int Q>
    explicit Sample(const Sample<P,T> &a, const Sample<Q,T> &b);

    virtual ~Sample();

    Interval<T> interval;

    Point<T> data[N];

    void operator+=(const Sample<N,T> &b);
    void operator+=(T b);
    
    void operator*=(const Sample<N,T> &b);
    void operator*=(T b);

    Point<T> operator[](unsigned int k);

    void plotPoints(Gnuplot &gp, const PlotBox<T> &box, unsigned int maxNumber = 0) const;
    void plotLine(Gnuplot &gp, const PlotBox<T> &box) const;

    T norm2() const;
    T norm() const;
    T normInf() const;
};
    
template <unsigned int N, typename T>
Sample<N,T>::Sample(const Interval<T> &interval, const std::function<Point<T>(unsigned int, Interval<T>)> &lambda) :
    interval(interval)
{
        for (unsigned int i = 0; i < N; i++) {
            Point<T> sample = lambda(i, interval);
            this->data[i] = sample;
        }
}

template <unsigned int N, typename T>
Sample<N,T>::Sample(const Interval<T> &interval, T _x[], T _y[]) :
    interval(interval) {
        for (unsigned int i = 0; i < N; i++) {
            this->data[i].x = (_x == nullptr ? T(0) : _x[i]);
            this->data[i].y = (_y == nullptr ? T(0) : _y[i]);
        }
}

template <unsigned int N, typename T>
Sample<N,T>::Sample(const Sample<N,T> &other) :
    interval(other.interval) {
}

template <unsigned int N, typename T>
template <unsigned int P, unsigned int Q>
Sample<N,T>::Sample(const Sample<P,T> &a, const Sample<Q,T> &b) {
    
    assert(P+Q == N);

    T inf = std::min(a.interval().inf, b.interval().inf);
    T sup = std::max(a.interval().max, b.interval().max);

    Sample<N,T> sample(Interval<T>(inf, sup));

    for (unsigned int i = 0; i < P; i++) {
        sample[i] = a[i];
    }

    for (unsigned int i = 0; i < Q; i++) {
        sample[P+i] = b[i];
    }
}
    

template <unsigned int N, typename T>
Sample<N,T>::~Sample() {
}

template <unsigned int N, typename T>
void Sample<N,T>::operator+=(const Sample<N,T> &b) {
    for(unsigned int i = 0; i < N; i++) {
        data[i].y += b.data[i].y;
    }
}

template <unsigned int N, typename T>
void Sample<N,T>::operator+=(T b) {
    for(unsigned int i = 0; i < N; i++) {
        data[i].y += b;
    }
}

template <unsigned int N, typename T>
void Sample<N,T>::operator*=(const Sample<N,T> &b) {
    for(unsigned int i = 0; i < N; i++) {
        data[i].y *= b.data[i].y;
    }
}

template <unsigned int N, typename T>
void Sample<N,T>::operator*=(T b) {
    for(unsigned int i = 0; i < N; i++) {
        data[i].y *= b;
    }
}

template <unsigned int N, typename T>
Sample<N,T> operator+(const Sample<N,T>&a, const Sample<N,T> &b) {
    Sample<N,T> sample(a);
    for(unsigned int i = 0; i < N; i++) {
        sample.data[i].x = a.data[i].x;
        sample.data[i].y = a.data[i].y + b.data[i].y;
    }
    return sample;
}

template <unsigned int N, typename T>
Sample<N,T> operator-(const Sample<N,T>&a, const Sample<N,T> &b) {
    Sample<N,T> sample(a);
    for(unsigned int i = 0; i < N; i++) {
        sample.data[i].x = a.data[i].x;
        sample.data[i].y = a.data[i].y - b.data[i].y;
    }
    return sample;
}

template <unsigned int N, typename T>
Sample<N,T> operator*(const Sample<N,T>&a, const Sample<N,T> &b) {
    Sample<N,T> sample(a);
    for(unsigned int i = 0; i < N; i++) {
        sample.data[i].x = a.data[i].x;
        sample.data[i].y = a.data[i].y * b.data[i].y;
    }
    return sample;
}

template <unsigned int N, typename T>
Sample<N,T> operator*(T a, const Sample<N,T> &b) {
    Sample<N,T> sample(a);
    for(unsigned int i = 0; i < N; i++) {
        sample.data[i].x = a.data[i].x;
        sample.data[i].y = a * b.data[i].y;
    }
    return sample;
}

template <unsigned int N, typename T>
Sample<N,T> operator*(const Sample<N,T>&a, T b) {
    Sample<N,T> sample(a);
    for(unsigned int i = 0; i < N; i++) {
        sample.data[i].x = a.data[i].x;
        sample.data[i].y = a.data[i].y * b;
    }
    return sample;
}
    
template <unsigned int N, typename T>
Point<T> Sample<N,T>::operator[](unsigned int k) {
    assert(k < N);
    return Point<T>(this->data[k]);
}

template <unsigned int N, typename T>
void Sample<N,T>::plotLine(Gnuplot &gp, const PlotBox<T> &box ) const {

    std::vector<std::tuple<float, float>> pts;

    Point<T> Xmin, Xmax;
    for (unsigned int i = 0; i < N; i++) {
        Point<T> X = this->data[i];
        Xmin.x = (X.x < Xmin.x ? X.x : Xmin.x);
        Xmin.y = (X.y < Xmin.y ? X.y : Xmin.y);
        Xmax.x = (X.x > Xmax.x ? X.x : Xmax.x);
        Xmax.y = (X.y > Xmax.y ? X.y : Xmax.y);
        pts.push_back(std::make_tuple(X.x,X.y));
    }

    std::sort(pts.begin(), pts.end());

    gp << box;
    gp << "set style line 1 lt rgb 'red' lw 1 pt 7\n";
    gp << "plot '-' with lines ls 1 notitle\n";
    gp.send1d(pts);
}

template <unsigned int N, typename T>
void Sample<N,T>::plotPoints(Gnuplot &gp, const PlotBox<T> &box, unsigned int maxNumber) const {

    std::vector<std::tuple<float, float>> pts;

    unsigned int maxPts;

    if(maxNumber == 0)
        maxPts = N;
    else 
        maxPts = std::min(N, maxNumber);

    for (unsigned int i = 0; i < maxPts; i++) {
        Point<T> X = this->data[i];
        pts.push_back(std::make_tuple(X.x,X.y));
    }

    gp << box;
    gp << "set style line 1 lt rgb '#0000FF' lw 1 pt 7\n";
    gp << "plot '-' with points ls 1 notitle\n";
    gp.send1d(pts);
}

template <unsigned int N, typename T>
T Sample<N,T>::norm2() const {
    T norm2 = T(0);
    for (unsigned int i = 0; i < N; i++) {
        norm2 += this->data[i].y*this->data[i].y;
    }
    return norm2;
}

template <unsigned int N, typename T>
T Sample<N,T>::norm() const {
    return std::pow<T>(this->norm2(), 0.5);
}

template <unsigned int N, typename T>
T Sample<N,T>::normInf() const {
    T normInf = T(0);
    for (unsigned int i = 0; i < N; i++) {
        T val = std::abs<T>(this->data[i].y);
        if(val > normInf) {
            normInf = val;
        }
    }
    return normInf;
}



#endif /* end of include guard: SAMPLE_H */
