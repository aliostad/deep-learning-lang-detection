/* config_load_test.go --test for config_load */

package config_load

import (
	"fmt"
	"testing"
)

// test ConfigLoad and configCheck, right case
func TestConfiLoadAndCheck_1(t *testing.T) {
	cfgFile := "testdata/spider.conf"

	// load config file
	_, err := ConfigLoad(cfgFile)

	// check
	if err != nil {
		t.Errorf("ConfigLoad(): %s", err.Error())
		return
	}
}

// test ConfigLoad and configCheck, wrong case
func TestConfiLoadAndCheck_2(t *testing.T) {
	cfgFile := "testdata/spider_2.conf"

	// load config file
	_, err := ConfigLoad(cfgFile)
	// check
	if err == nil {
		t.Errorf("config check error, shoule be no UrlListFile")
		return
	}
}

// test ConfigLoad and configCheck, wrong case
func TestConfiLoadAndCheck_3(t *testing.T) {
	cfgFile := "testdata/spider_null.conf"

	// load config file
	_, err := ConfigLoad(cfgFile)
	fmt.Println(err.Error())

	// check
	errMsg := "ReadFileInto(): " +
		"open testdata/spider_null.conf: " +
		"no such file or directory"
	if err == nil || err.Error() != errMsg {
		fmt.Println(err)
		t.Errorf("should have file load error")
		return
	}
}
