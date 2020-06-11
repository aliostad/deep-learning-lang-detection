package vaulty

import (
	"bytes"
	"testing"
)

func TestUnmarshalMarshal(t *testing.T) {
	v := NewVault()
	err := v.Unmarshal([]byte(`
		foo=bar
		bar=baz
		
		a.b=foo
		a.c = bar
	`))
	if err != nil {
		t.Error(err)
	}

	l := v.List()
	if len(l) != 4 {
		t.Errorf("should have 4 entries")
	}

	data, err := v.Marshal()
	if err != nil {
		t.Error(err)
	}

	v = NewVault()
	err = v.Unmarshal(data)
	if err != nil {
		t.Error(err)
	}

	l = v.List()
	if len(l) != 4 {
		t.Errorf("should have 4 entries")
	}
}

func TestAccessMethods(t *testing.T) {
	v := NewVault()
	err := v.Unmarshal([]byte(`
		foo=bar
		bar=baz
		
		a.b=foo
		a.c = bar
	`))
	if err != nil {
		t.Error(err)
	}

	l := v.List()
	if len(l) != 4 {
		t.Errorf("should have 4 entries")
	}

	if v.Get("a.b") != "foo" {
		t.Errorf("should be foo")
	}

	v.Put("x.y", "hello")
	if v.Get("x.y") != "hello" {
		t.Errorf("should be hello")
	}

	v.Remove("x.y")
	if v.Get("x.y") != "" {
		t.Errorf("should be removed")
	}

	l = v.Find("a")
	if l[0] != "a.b" {
		t.Errorf("should be a.b")
	}
	if l[1] != "a.c" {
		t.Errorf("should be a.b")
	}
}

func TestConsoleFuncs(t *testing.T) {
	v := NewVault()
	err := v.Unmarshal([]byte(`
		foo=bar
		bar=baz
		
		a.b=foo
		a.c = bar
	`))
	if err != nil {
		t.Error(err)
	}

	b := &bytes.Buffer{}
	c := NewConsole(v, b)

	c.List("")
	o := b.String()
	if o != `a.b
a.c
bar
foo
` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.List("a")
	o = b.String()
	if o != `a.b
a.c
` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.Get("a")
	o = b.String()
	if o != `no such key: a
` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.Get("a.b")
	o = b.String()
	if o != `foo
` {
		t.Errorf("should be %v", o)
	}
}

func TestConsoleDispatch(t *testing.T) {
	v := NewVault()
	err := v.Unmarshal([]byte(`
		foo=bar
		bar=baz
		
		a.b=foo
		a.c = bar
	`))
	if err != nil {
		t.Error(err)
	}

	b := &bytes.Buffer{}
	c := NewConsole(v, b)

	c.Dispatch("ls")
	o := b.String()
	if o != `a.b
a.c
bar
foo
` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.Dispatch("ls a")
	o = b.String()
	if o != `a.b
a.c
` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.Dispatch("cat a")
	o = b.String()
	if o != `no such key: a
` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.Dispatch("cat a.b")
	o = b.String()
	if o != `foo
` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.Dispatch("echo secret > x.z")
	b.Truncate(0)
	c.Dispatch("cat x.z")
	o = b.String()
	if o != `secret
` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.Dispatch("rm x.z")
	o = b.String()
	if o != `` {
		t.Errorf("should be %v", o)
	}

	b.Truncate(0)
	c.Dispatch("cat x.z")
	o = b.String()
	if o != `no such key: x.z
` {
		t.Errorf("should be %v", o)
	}
}
