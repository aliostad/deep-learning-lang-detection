package stopWords

import "testing"

func TestTypeStopWordManagerHasDispatchMethod(t *testing.T) {
	var stopWordManager interface{} = &StopWordManager{}

	_, ok := stopWordManager.(interface {
		Dispatch(message []string) ([]string, error)
	})

	if !ok {
		t.Error("Type StopWordManager does not have any method 'Dispatch'!")
	}
}

func TestDispatchRaisesErrorOnNonsenseMessage(t *testing.T) {
	stopWordManager := &StopWordManager{}
	_, err := stopWordManager.Dispatch([]string{"gibberish"})

	if err == nil {
		t.Error("Expected InvalidStopWordManagerMessage, got nothing.")
	}

	_, ok := err.(*InvalidStopWordManagerMessage)

	if !ok {
		t.Errorf("Expected error of type InvalidStopWordManagerMessage, got %T", err)
	}
}

func TestDispatchDoesNotFailOnValidInitMessage(t *testing.T) {
	checkValidDispatchMessage([]string{"init"}, t)
}

func TestDispatchMethodDoesNotFailOnValidIsStopWordMessage(t *testing.T) {
	checkValidDispatchMessage([]string{"is_stop_word"}, t)
}

func TestDispatchReturnsExpectedStopWordsOnInitMessage(t *testing.T) {
	stopWordManager := &StopWordManager{}
	_, err := stopWordManager.Dispatch([]string{"init"})

	if err != nil {
		t.Errorf("Expected noting, got error: %s", err.Error())
	}

	expected := []string{"hello", "world"}
	actual := stopWordManager.stopWords

	if actual == nil {
		t.Error("Expected stopWords attribute to be [\"hello\", \"world\"], but was nil")
	} else if !stringSlicesMatch(actual, expected) {
		t.Errorf("Stop word lists do not match, expected %s, got: %s",
			expected, actual)
	}

}

// ######################  util ###############################

func checkValidDispatchMessage(message []string, t *testing.T) {
	stopWordManager := &StopWordManager{}
	_, err := stopWordManager.Dispatch(message)

	if err != nil {
		t.Errorf("Didn't expect error, but got: %s", err.Error())
	}
}

func stringSlicesMatch(actual []string, expected []string) bool {
	if len(actual) != len(expected) {
		return false
	}
	for index, expectedElem := range expected {
		if actual[index] != expectedElem {
			return false
		}
	}
	return true
}
