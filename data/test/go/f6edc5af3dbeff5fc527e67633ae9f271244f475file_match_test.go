package dirdiff

import (
	"testing"
)

type T struct {
	S     string
	Cases []Case
}

type Case struct {
	D  string
	Ok bool
}

func TestFileMatcher(t *testing.T) {
	a := []T{
		T{`/xxxx`, []Case{
			Case{`xxxx`, true},
			Case{`xxxxy`, false},
			Case{`xxxx`, true},
			Case{`xxxx/yyy`, true},
		}},
		T{`//xxxx`, []Case{
			Case{`xxxx`, true},
			Case{`xxxxy`, false},
			Case{`xxxx`, true},
		}},
		T{`./aa/bb/cc`, []Case{
			Case{`aa/bb/cc`, true},
			Case{`aa/bb/cc/dd`, true},
		}},
		T{`./aa//bb/cc`, []Case{
			Case{`aa/bb/cc`, true},
			Case{`aa/bb/cc/dd`, true},
		}},
		T{`111/`, []Case{
			Case{`111`, true},
			Case{`111/1.txt`, true},
			Case{`11122/1.txt`, false},
		}},
		T{`111/*`, []Case{
			Case{`111`, false},
			Case{`111/222`, true},
			Case{`111/222/333`, true},
		}},
		T{`111/*.tmp`, []Case{
			Case{`111/1.tmp`, true},
			Case{`111/tmp`, false},
			Case{`111/1.tmp/222`, true},
		}},
		T{`111/tmp-*`, []Case{
			Case{`111/tmp-`, true},
			Case{`111/tmp-1.txt`, true},
			Case{`111/tmp-1.txt/222`, true},
		}},
		T{`111*`, []Case{
			Case{`111/222`, true},
			Case{`1112`, true},
			Case{`1112/333`, true},
		}},
		T{`git`, []Case{
			Case{`aaa/git`, false},
			Case{`git/*`, true},
		}},
	}
	for _, x := range a {
		matcher := NewFileMatcher(x.S)

		for _, c := range x.Cases {
			if matched, err := matcher.Match(c.D); err != nil {
				t.Errorf("%s => (%s, %t), matched error: %v", x.S, c.D, c.Ok, err)
			} else if matched != c.Ok {
				t.Errorf("%s => (%s, %t) not matched", x.S, c.D, c.Ok)
			}

		}
	}
}
