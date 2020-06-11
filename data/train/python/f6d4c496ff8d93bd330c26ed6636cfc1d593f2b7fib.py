from typedispatch import *


@dispatch(inside(0, 1))
def fib(n):
    return 1

@dispatch(int)
def fib(n):
    return fib(n - 1) + fib(n - 2)

@dispatch(long)
def fib(n):
    # Faster fib implementation
    n += 1
    a, b = 1, 0
    c, d = 0, 1
    while n > 0:
        if n % 2:
            c, d =  a * (c + d) + b * c, a * c + b * d
            n -= 1
        n >>= 1
        a, b =  a ** 2 + ((a * b) << 1), a ** 2 + b ** 2
    return c

@dispatch(basestring)
def fib(n):
    return fib(long(n))


for i in range(20):
    print i, fib(i)
