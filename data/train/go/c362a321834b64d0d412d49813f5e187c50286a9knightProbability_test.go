package dp

import "testing"
import "fmt"

type TestCase struct {
    size int
    moveNum int
    startX int
    startY int
    expected float64
}

func TestKnightProbability(t *testing.T) {
    testList := []TestCase{
        case1(),
        case2(),
        case3(),
    }

    for _, testCase := range testList {
        expected := testCase.expected
        result := knightProbability(testCase.size, testCase.moveNum, testCase.startX, testCase.startY)

        if (expected != result) {
            errorMsg := fmt.Sprintf("\nresult: %v\nexpected: %v\n", result, expected)
            t.Errorf(errorMsg)
        }
    }
}

func case1() TestCase {
    testCase := TestCase{
        3,
        1,
        0,
        0,
        float64(2.0 / 8.0),
    }

    return testCase
}

func case2() TestCase {
    testCase := TestCase{
        3,
        2,
        0,
        0,
        float64(4.0 / 64.0),
    }

    return testCase
}

func case3() TestCase {
    testCase := TestCase{
        8,
        30,
        6,
        4,
        0.00019,
    }

    return testCase
}
