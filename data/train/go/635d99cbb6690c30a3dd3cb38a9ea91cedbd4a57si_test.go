package si

import (
	"testing"
)

func TestParse(t *testing.T) {
	type testCase struct {
		Data   string
		Result Number
	}

	testCases := []testCase{
		testCase{"1.0Y", Number{1, Yotta}},
		testCase{"1.0Z", Number{1, Zetta}},
		testCase{"1.0 E", Number{1, Exa}},
		testCase{"1.0P", Number{1, Peta}},
		testCase{"1.0T", Number{1, Tera}},
		testCase{"1.0G", Number{1, Giga}},
		testCase{"1.0M", Number{1, Mega}},
		testCase{"1.0k", Number{1, Kilo}},
		testCase{"1.0h", Number{1, Hecto}},
		testCase{"1.0da", Number{1, Deca}},
		testCase{"1.0d", Number{1, Deci}},
		testCase{"1.0c", Number{1, Centi}},
		testCase{"1.0m", Number{1, Milli}},
		testCase{"1.0μ", Number{1, Micro}},
		testCase{"1.0u", Number{1, Micro}},
		testCase{"1.0n", Number{1, Nano}},
		testCase{"1.0 p", Number{1, Pico}},
		testCase{"1.0f", Number{1, Femto}},
	}

	for _, testCase := range testCases {
		t.Log(testCase)

		res, err := Parse(testCase.Data)
		if err != nil {
			t.Error(err)
		} else if res != testCase.Result {
			t.Errorf("Parse(%#v) should return %#v, got %#v", testCase.Data,
				testCase.Result, res)
		}
	}
}

func TestString(t *testing.T) {
	type testCase struct {
		Data   Number
		Result string
	}

	testCases := []testCase{
		testCase{Number{1, Yotta}, "1Y"},
		testCase{Number{1, Zetta}, "1Z"},
		testCase{Number{1, Exa}, "1 E"},
		testCase{Number{1, Peta}, "1P"},
		testCase{Number{1, Tera}, "1T"},
		testCase{Number{1, Giga}, "1G"},
		testCase{Number{1, Mega}, "1M"},
		testCase{Number{1, Kilo}, "1k"},
		testCase{Number{1, Hecto}, "1h"},
		testCase{Number{1, Deca}, "1da"},
		testCase{Number{1, None}, "1"},
		testCase{Number{1, Deci}, "1d"},
		testCase{Number{1, Centi}, "1c"},
		testCase{Number{1, Milli}, "1m"},
		testCase{Number{1, Micro}, "1μ"},
		testCase{Number{1, Nano}, "1n"},
		testCase{Number{1, Pico}, "1 p"},
		testCase{Number{1, Femto}, "1f"},
	}

	for _, testCase := range testCases {
		t.Log(testCase)

		res := testCase.Data.String()

		if res != testCase.Result {
			t.Errorf("%#v.String() should return %#v, got %#v", testCase.Data,
				testCase.Result, res)
		}
	}
}
