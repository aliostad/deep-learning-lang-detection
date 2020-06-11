from fuf import DispatchDict


def test_basic():
    d1 = {}
    d = DispatchDict()
    d.dispatch(d1)
    d1["foo"] = 5
    d["bar"] = 7
    assert "foo" in d, "Dispatch lookup failed"
    assert "bar" in d, "Normal lookup failed"
    assert "baz" not in d, "False positive lookup"
    assert d["foo"] == 5, "Value from dispatch"


def test_nodispatch():
    d1 = {}
    d = DispatchDict()
    d1["foo"] = 5
    d["bar"] = 7
    assert "foo" not in d, "Dispatch lookup failed"
    assert "bar" in d, "Normal lookup failed"
    assert "baz" not in d, "False positive lookup"
    assert d["bar"] == 7, "Value from dispatch"
