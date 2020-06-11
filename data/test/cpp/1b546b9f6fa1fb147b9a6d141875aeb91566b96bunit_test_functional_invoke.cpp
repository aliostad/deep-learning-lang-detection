/**
 *	@file	unit_test_functional_invoke.cpp
 *
 *	@brief	invokeのテスト
 *
 *	@author	myoukaku
 */

#include <bksge/foundation/functional/invoke.hpp>
#include <gtest/gtest.h>
#include "constexpr_test.hpp"

namespace invoke_test
{

BKSGE_CONSTEXPR int function1()
{
	return 0;
}

BKSGE_CONSTEXPR int function2(float)
{
	return 1;
}

BKSGE_CONSTEXPR int function3(int, float)
{
	return 2;
}

struct Foo
{
	BKSGE_CONSTEXPR int operator()() const
	{
		return 3;
	}

	BKSGE_CONSTEXPR int member_func() const
	{
		return 4;
	}
};

struct Base
{
	BKSGE_CONSTEXPR int nonvirtual_func(int) const
	{
		return 5;
	}

	virtual int virtual_func() const
	{
		return 6;
	}
};

struct Derived : public Base
{
	BKSGE_CONSTEXPR int nonvirtual_func(int, int) const
	{
		return 7;
	}

	virtual int virtual_func() const
	{
		return 8;
	}
};

struct Bar
{
	int f1()
	{
		return 9;
	}

	int f2() const
	{
		return 10;
	}

	int f3() volatile
	{
		return 11;
	}

	int f4() const volatile
	{
		return 12;
	}

	Bar()
		: x(17)
		, y(18)
		, z(19)
		, w(20)
	{}

	int x;
	const int y;
	volatile int z;
	const volatile int w;

private:
	Bar& operator=(const Bar&);
};

GTEST_TEST(FunctionalTest, InvokeTest)
{
	BKSGE_CONSTEXPR Foo f{};
	BKSGE_CONSTEXPR Base b{};
	BKSGE_CONSTEXPR Derived d{};

	BKSGE_CONSTEXPR_EXPECT_EQ(0, bksge::invoke(function1));
	BKSGE_CONSTEXPR_EXPECT_EQ(1, bksge::invoke(function2, 0.0f));
	BKSGE_CONSTEXPR_EXPECT_EQ(2, bksge::invoke(function3, 0, 0.0f));
	BKSGE_CONSTEXPR_EXPECT_EQ(3, bksge::invoke(f));
	BKSGE_CONSTEXPR_EXPECT_EQ(4, bksge::invoke(&Foo::member_func, f));
	BKSGE_CONSTEXPR_EXPECT_EQ(4, bksge::invoke(&Foo::member_func, &f));
	BKSGE_CONSTEXPR_EXPECT_EQ(5, bksge::invoke(&Base::nonvirtual_func, b, 0));
	BKSGE_CONSTEXPR_EXPECT_EQ(5, bksge::invoke(&Base::nonvirtual_func, &b, 0));
	BKSGE_CONSTEXPR_EXPECT_EQ(5, bksge::invoke(&Base::nonvirtual_func, d, 0));
	BKSGE_CONSTEXPR_EXPECT_EQ(5, bksge::invoke(&Base::nonvirtual_func, &d, 0));
	                EXPECT_EQ(6, bksge::invoke(&Base::virtual_func, b));
	                EXPECT_EQ(6, bksge::invoke(&Base::virtual_func, &b));
	                EXPECT_EQ(8, bksge::invoke(&Base::virtual_func, d));
	                EXPECT_EQ(8, bksge::invoke(&Base::virtual_func, &d));
	BKSGE_CONSTEXPR_EXPECT_EQ(7, bksge::invoke(&Derived::nonvirtual_func, d, 0, 0));
	BKSGE_CONSTEXPR_EXPECT_EQ(7, bksge::invoke(&Derived::nonvirtual_func, &d, 0, 0));
	                EXPECT_EQ(8, bksge::invoke(&Derived::virtual_func, d));
	                EXPECT_EQ(8, bksge::invoke(&Derived::virtual_func, &d));
	{
		Bar bar;
		EXPECT_EQ( 9, bksge::invoke(&Bar::f1, bar));
		EXPECT_EQ(10, bksge::invoke(&Bar::f2, bar));
		EXPECT_EQ(11, bksge::invoke(&Bar::f3, bar));
		EXPECT_EQ(12, bksge::invoke(&Bar::f4, bar));

		EXPECT_EQ(17, bksge::invoke(&Bar::x, bar));
		EXPECT_EQ(17, bksge::invoke(&Bar::x, &bar));
		EXPECT_EQ(18, bksge::invoke(&Bar::y, bar));
		EXPECT_EQ(18, bksge::invoke(&Bar::y, &bar));
		EXPECT_EQ(19, bksge::invoke(&Bar::z, bar));
		EXPECT_EQ(19, bksge::invoke(&Bar::z, &bar));
		EXPECT_EQ(20, bksge::invoke(&Bar::w, bar));
		EXPECT_EQ(20, bksge::invoke(&Bar::w, &bar));
	}
	{
		const Bar bar;
//		EXPECT_EQ( 9, bksge::invoke(&Bar::f1, bar));
		EXPECT_EQ(10, bksge::invoke(&Bar::f2, bar));
//		EXPECT_EQ(11, bksge::invoke(&Bar::f3, bar));
		EXPECT_EQ(12, bksge::invoke(&Bar::f4, bar));

		EXPECT_EQ(17, bksge::invoke(&Bar::x, bar));
		EXPECT_EQ(17, bksge::invoke(&Bar::x, &bar));
		EXPECT_EQ(18, bksge::invoke(&Bar::y, bar));
		EXPECT_EQ(18, bksge::invoke(&Bar::y, &bar));
		EXPECT_EQ(19, bksge::invoke(&Bar::z, bar));
		EXPECT_EQ(19, bksge::invoke(&Bar::z, &bar));
		EXPECT_EQ(20, bksge::invoke(&Bar::w, bar));
		EXPECT_EQ(20, bksge::invoke(&Bar::w, &bar));
	}
	{
		volatile Bar bar;
//		EXPECT_EQ( 9, bksge::invoke(&Bar::f1, bar));
//		EXPECT_EQ(10, bksge::invoke(&Bar::f2, bar));
		EXPECT_EQ(11, bksge::invoke(&Bar::f3, bar));
		EXPECT_EQ(12, bksge::invoke(&Bar::f4, bar));

		EXPECT_EQ(17, bksge::invoke(&Bar::x, bar));
		EXPECT_EQ(17, bksge::invoke(&Bar::x, &bar));
		EXPECT_EQ(18, bksge::invoke(&Bar::y, bar));
		EXPECT_EQ(18, bksge::invoke(&Bar::y, &bar));
		EXPECT_EQ(19, bksge::invoke(&Bar::z, bar));
		EXPECT_EQ(19, bksge::invoke(&Bar::z, &bar));
		EXPECT_EQ(20, bksge::invoke(&Bar::w, bar));
		EXPECT_EQ(20, bksge::invoke(&Bar::w, &bar));
	}
	{
		const volatile Bar bar;
//		EXPECT_EQ( 9, bksge::invoke(&Bar::f1, bar));
//		EXPECT_EQ(10, bksge::invoke(&Bar::f2, bar));
//		EXPECT_EQ(11, bksge::invoke(&Bar::f3, bar));
		EXPECT_EQ(12, bksge::invoke(&Bar::f4, bar));

		EXPECT_EQ(17, bksge::invoke(&Bar::x, bar));
		EXPECT_EQ(17, bksge::invoke(&Bar::x, &bar));
		EXPECT_EQ(18, bksge::invoke(&Bar::y, bar));
		EXPECT_EQ(18, bksge::invoke(&Bar::y, &bar));
		EXPECT_EQ(19, bksge::invoke(&Bar::z, bar));
		EXPECT_EQ(19, bksge::invoke(&Bar::z, &bar));
		EXPECT_EQ(20, bksge::invoke(&Bar::w, bar));
		EXPECT_EQ(20, bksge::invoke(&Bar::w, &bar));
	}
}

}	// namespace invoke_test
