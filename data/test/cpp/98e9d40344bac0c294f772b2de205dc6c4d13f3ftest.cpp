#include "basic_traits.h"
#include "detect.h"
#include <iostream>
#include <vector>

struct o {};

struct A {
	void load(o&) {};
};

struct B {
};
void load(o&, B&) {};
void load(A&) {};
void load(B&) {};


template<class T, class A>
using has1_member_load = decltype(std::declval<T>().load(std::declval<A&>()));
template<class T, class A>
using has1_non_member_load = decltype(load(std::declval<A&>(),std::declval<T&>()));


using namespace aw;

template<class T, class A> using member_load = decltype(std::declval<T>().load(std::declval<A&>));
template<class T, class A> using non_member_load = decltype(load(std::declval<A&>,std::declval<T&>()));

template<class T, class A>
constexpr auto has_member_load = is_detected<member_load, T, A>;
template<class T, class A>
constexpr auto has_non_member_load = is_detected<non_member_load, T, A>;


template<class A>
using has_non_mem = decltype(load(std::declval<A&>()));


int main()
{
	std::cout << std::boolalpha;
	std::cout << has_member_load<A,o> << "\n";
	std::cout << has_non_member_load<A,o> << "\n";
	std::cout << has_member_load<B,o> << "\n";
	std::cout << has_non_member_load<B,o> << "\n";
	std::cout << is_detected<member_load,A,o> << "\n";
	std::cout << is_detected<non_member_load,A,o> << "\n";
	std::cout << is_detected<member_load,B,o> << "\n";
	std::cout << is_detected<non_member_load,B,o> << "\n";
	std::cout << is_detected<has1_member_load,A,o> << "\n";
	std::cout << is_detected<has1_non_member_load,A,o> << "\n";
	std::cout << is_detected<has1_member_load,B,o> << "\n";
	std::cout << is_detected<has1_non_member_load,B,o> << "\n";
	std::cout << is_detected<has_non_mem,A> << "\n";
	std::cout << is_detected<has_non_mem,B> << "\n";
}
