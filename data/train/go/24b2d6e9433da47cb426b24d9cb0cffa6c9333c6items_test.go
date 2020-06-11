package db

import (
	"fmt"
	"testing"
)

func TestItems(t *testing.T) {
	w, ds := getWaifu("")

	w.CreateType(&Type{
		Name:    "test",
		Indexes: []string{"name", "instrument"},
	})

	test := map[string]interface{}{
		"name":       "Reina Kousaka",
		"instrument": "trumpet",
		"loves":      "me",
	}

	i, err := w.PutItem("test", test)
	if err != nil {
		t.Error(err)
		return
	}

	err = assertMapEq(test, i)
	if err != nil {
		t.Error(err)
		return
	}

	o, err := w.GetItem("test", i["id"].(string))
	if err != nil {
		t.Error(err)
		return
	}

	err = assertMapEq(i, o)
	if err != nil {
		t.Error(err)
		return
	}

	ds.Release()
}

func TestGetByKey(t *testing.T) {
	w, ds := getWaifu("")

	_, err := w.CreateType(&Type{
		Name:    "test",
		Indexes: []string{"name", "instrument"},
	})
	if err != nil {
		t.Error(err)
		return
	}

	test := map[string]interface{}{
		"name":       "Reina Kousaka",
		"instrument": "trumpet", // trumpet
		"loves":      "me",
	}

	_, err = w.PutItem("test", test)
	if err != nil {
		t.Error(err)
		return
	}

	d1, err := w.GetItemByKey("test", "name", test["name"])
	if err != nil {
		t.Error(err)
		return
	}

	err = assertMapEq(test, d1)
	if err != nil {
		t.Error("d1 not eq:", err)
		return
	}

	d2, err := w.GetItemByKey("test", "loves", test["loves"])
	if err != nil {
		t.Error(err)
		return
	}
	err = assertMapEq(test, d2)
	if err != nil {
		t.Error("d2 not eq:", err)
		return
	}

	ds.Release()
}

func assertMapEq(m1, m2 map[string]interface{}) error {
	for k, v := range m1 {
		if m2[k] != v {
			return fmt.Errorf("m2[%s] !== m1[%s]\n  m2: %v\n  m1: %v", k, k, m2, m1)
		}
	}

	return nil
}
