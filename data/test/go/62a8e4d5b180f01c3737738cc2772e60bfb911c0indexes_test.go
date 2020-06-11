package db

import "testing"

func TestIndexGet(t *testing.T) {
	w, ds := getWaifu("")

	_, err := w.CreateType(&Type{
		Name:    "person",
		Indexes: []string{"name", "instrument"},
	})
	if err != nil {
		t.Error(err)
		return
	}

	ds.Release()
}

func BenchmarkIndexes(b *testing.B) {
	w, ds := getWaifu("")

	ty, err := w.CreateType(&Type{
		Name:    "person",
		Indexes: []string{"name", "instrument"},
	})
	if err != nil {
		b.Error(err)
		return
	}

	knownData := map[string]interface{}{
		"name":       "Reina Kousaka",
		"instrument": "trumpet",
		"loves":      "me",
	}

	w.PutItem(ty.Name, knownData)

	seed(w, ty, 100000, 5)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := w.GetItemByKey(ty.Name, "name", "Reina Kousaka")
		if err != nil {
			b.Error(err)
			return
		}
	}

	ds.Release()
	ds.DestroyDestroyDestroy()
}

func BenchmarkNoIndexes(b *testing.B) {
	w, ds := getWaifu("")

	ty, err := w.CreateType(&Type{
		Name:    "person",
		Indexes: []string{"name", "instrument"},
	})
	if err != nil {
		b.Error(err)
		return
	}

	knownData := map[string]interface{}{
		"name":       "Reina Kousaka",
		"instrument": "trumpet",
		"loves":      "me",
	}

	seed(w, ty, 100000, 5)

	w.PutItem(ty.Name, knownData)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := w.GetItemByKey(ty.Name, "loves", "me")
		if err != nil {
			b.Error(err)
			return
		}
	}

	ds.Release()
	ds.DestroyDestroyDestroy()
}
