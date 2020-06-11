# -*- coding: utf-8 -*-

from railroad import dispatch


def test_return_none_if_all_functions_return_empty_result():
    def empty():
        return None

    dispatch_function = dispatch(
        empty,
        empty,
        empty,
        empty
    )

    assert dispatch_function() is None


def test_return_first_non_empty_result():
    def empty():
        return None

    def one():
        return 1

    def two():
        return 2

    dispatch_function = dispatch(
        empty,
        empty,
        one,
        two,
        empty
    )

    assert dispatch_function() == 1
