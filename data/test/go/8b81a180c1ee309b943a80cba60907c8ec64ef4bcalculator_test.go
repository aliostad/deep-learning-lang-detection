package tests

import "calculator/machine"
import "testing"

var mockedInput1 string = "1+2+3+4" // 10
var mockedInput2 string = "1+2/3+4" // 5
var mockedInput3 string = "2+3*1-2" // 3

var mockedWrongInput1 string = "++2" // [Error]: Given RPN expression isn't correct!
var mockedWrongInput2 string = "1/0" // [Error]: Divide by zero

func TestProcessValid(t *testing.T) {
	t.Log("Trying valid mocked inputs ...")

	if result, errorProcess := machine.Process(mockedInput1); result != 10 && errorProcess == nil {
		t.Errorf("Expected 10, but got %v", result)
	}
	if result, errorProcess := machine.Process(mockedInput2); result != 5 && errorProcess == nil {
		t.Errorf("Expected 5, but got %v", result)
	}
	if result, errorProcess := machine.Process(mockedInput3); result != 3 && errorProcess == nil {
		t.Errorf("Expected 3, but got %v", result)
	}
}

func TestTranslateWrong(t *testing.T) {
	t.Log("Trying wrong mocked inputs ...")

	if _, errorProcess := machine.Process(mockedWrongInput1); errorProcess == nil {
		t.Errorf("Expected \"[Error]: Given RPN expression isn't correct!\", but got %v", errorProcess)
	}
	if _, errorProcess := machine.Process(mockedWrongInput2); errorProcess == nil {
		t.Errorf("Expected \"[Error]: Divide by zero\", but got %v", errorProcess)
	}
}
