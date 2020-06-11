package GxDict

import (
	"testing"
)

func Test_LoadDropTable(t *testing.T) {
	str1 := "10001,1,1000,10002,2,2000;10003,3,10000"
	str2 := "10001,1,1000,10002,2,2000;"
	str3 := ""
	str4 := "10001,1,1000,10002,2,2000,2,2;"

	dict1, _ := LoadDropTable(str1)
	if len(dict1) != 2 {
		t.Error("Test_LoadDropTable fail 1", str1)
	}
	if len(dict1[0]) != 2 {
		t.Error("Test_LoadDropTable 2 fail", str1)
	}
	if len(dict1[1]) != 1 {
		t.Error("Test_LoadDropTable 3 fail", str1)
	}

	dict2, _ := LoadDropTable(str2)
	if len(dict2) != 1 {
		t.Error("Test_LoadDropTable fail", str2)
	}

	dict3, _ := LoadDropTable(str3)
	if len(dict3) != 0 {
		t.Error("Test_LoadDropTable fail", str3)
	}

	_, err := LoadDropTable(str4)
	if err == nil {
		t.Error("Test_LoadDropTable fail", str4)
	}
}
