package core

import "testing"

func TestLoadTransliterationFileNotFound(t *testing.T) {
	defer func() {
		r := recover()
		if r == nil {
			t.Error("loadTransliteration should panic")
		}
	}()
	loadTransliteration("")
}

func TestLoadQuranFileNotFound(t *testing.T) {
	defer func() {
		r := recover()
		if r == nil {
			t.Error("loadQuran should panic")
		}
	}()
	loadQuran("", nil)
}

func TestLoadQuranBadXMLFormat(t *testing.T) {
	defer func() {
		r := recover()
		if r == nil {
			t.Error("loadQuran should panic")
		}
	}()
	loadQuran("corpus/arabic-to-alphabet", nil)
}
