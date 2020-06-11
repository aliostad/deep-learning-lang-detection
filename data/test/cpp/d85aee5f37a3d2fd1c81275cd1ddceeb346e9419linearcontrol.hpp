#ifndef SYRUP_MATH_LINEAR_CONTROL
#define SYRUP_MATH_LINEAR_CONTROL

#include <syrup/math/matrixmath.hpp>

namespace syrup {
    template<typename T, int N, int I, int O>
    struct linear_model {
        Matrix<T, N, N> A;
        Matrix<T, N, I> B;
        Matrix<T, O, N> C;
        Matrix<T, N, 1> x;
        Matrix<T, I, 1> u;
    };

    template<typename T, int N, int I, int O>
    struct linear_filter {
        Matrix<T, N, N> P, Q;
        Matrix<T, N, O> K;
        linear_model<T, N, I, O> *model;
        linear_filter(linear_model<T, N, I, O>* const m) : model(m) {};
    };

    template<typename T, int N, int I, int O>
    struct linear_controller {
        Matrix<T, I, N> L;
        linear_model<T, N, I, O> *model;
        linear_controller(linear_model<T, N, I, O>* const m) : model(m) {};
    };

    template<typename T, int N, int I, int O>
    void lq(linear_controller<T, N, I, O>& c) {
        c.model->u = -c.L * c.model->x;
    }
    template<typename T, int N, int I, int O>
    void kalman(linear_filter<T, N, I, O>& f, const Matrix<T, O, 1>& y) {
        f.model->x += f.K*(y - f.model->C*f.model->x);
    }
    template<typename T, int N, int I, int O>
    void update(linear_filter<T, N, I, O>& f, T dT) {
        f.model->x += (f.model->A * f.model->x + f.model->B * f.model->u) * dT;
    }
    template<typename T, int N, int I, int O>
    void update(linear_filter<T, N, I, O>& f) {
        f.model->x += f.model->A * f.model->x + f.model->B * f.model->u;
    }
}
#endif
