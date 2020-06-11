package rules

import (
	"fmt"
	"path/filepath"
	"reflect"
	"runtime"
	"strings"
	"testing"
)

var configText = strings.TrimSpace(`
-
  Instrument:     Visa ***1234
  PaymentAccount: Liabilities:Citi Visa
-
  Instrument:     Amex ***5678
  PaymentAccount: Liabilities:American Express'
-
  Payee:       Lyft
  CostAccount: Expenses:Transit:Ride Share
-
  Payee:       Costco
  CostAccount: Expenses:Grocery:General
`)

func TestScenario(t *testing.T) {
	r, err := From(
		[]byte(configText),
		[]string{"Payee", "Instrument"},
		[]string{"PaymentAccount", "CostAccount"})
	ok(t, err)

	result := r.Apply(Input("Payee", "Lyft"),
		Input("Instrument", "Visa ***1234"))
	equals(t, "Liabilities:Citi Visa", result.Get("PaymentAccount"))
	equals(t, "Expenses:Transit:Ride Share", result.Get("CostAccount"))
}

func TestValidation(t *testing.T) {
	_, err := From(
		[]byte(configText),
		[]string{"Payee", "Instrument"},
		[]string{"PaymentAccount", "CostAccount"})
	ok(t, err)

	_, err = From(
		[]byte(configText),
		[]string{"Instrument"},
		[]string{"PaymentAccount", "CostAccount"})
	assert(t, err != nil, "expected error but was nil")
	assert(t, strings.Contains(fmt.Sprintf("%s", err), "Payee"), "Error should have contained %q, but was %q", "Payee", err)

	_, err = From(
		[]byte(configText),
		[]string{"Payee", "Instrument"},
		[]string{"CostAccount"})
	assert(t, err != nil, "expected error but was nil")
	assert(t, strings.Contains(fmt.Sprintf("%s", err), "PaymentAccount"), "Error should have contained %q, but was %q", "Payee", err)

}

// assert fails the test if the condition is false.
func assert(tb testing.TB, condition bool, msg string, v ...interface{}) {
	if !condition {
		_, file, line, _ := runtime.Caller(1)
		fmt.Printf("\033[31m%s:%d: "+msg+"\033[39m\n\n", append([]interface{}{filepath.Base(file), line}, v...)...)
		tb.FailNow()
	}
}

// ok fails the test if an err is not nil.
func ok(tb testing.TB, err error) {
	if err != nil {
		_, file, line, _ := runtime.Caller(1)
		fmt.Printf("\033[31m%s:%d: unexpected error: %s\033[39m\n\n", filepath.Base(file), line, err.Error())
		tb.FailNow()
	}
}

// equals fails the test if exp is not equal to act.
func equals(tb testing.TB, exp, act interface{}) {
	if !reflect.DeepEqual(exp, act) {
		_, file, line, _ := runtime.Caller(1)
		fmt.Printf("\033[31m%s:%d:\n\n\texp: %#v\n\n\tgot: %#v\033[39m\n\n", filepath.Base(file), line, exp, act)
		tb.FailNow()
	}
}
