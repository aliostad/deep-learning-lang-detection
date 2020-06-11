package main

import "testing"

func TestLoadConfig(t *testing.T) {
	c := loadConfig("")
	if c.Template != defaultTemplate || len(c.Typemap) != len(defaultTypemap) {
		t.Errorf("failed to load default config: %+v", c)
	}
}

func TestLoadConfig2(t *testing.T) {
	c := loadConfig("test/config1.toml")
	if c.Template != defaultTemplate || len(c.Typemap) != 8 {
		t.Errorf("failed to load default config: %+v", c)
	}
}

func TestLoadConfig3(t *testing.T) {
	c := loadConfig("test/config2.toml")
	if c.Template == defaultTemplate || len(c.Typemap) != len(defaultTypemap) {
		t.Errorf("failed to load default config: %+v", c)
	}
	t.Logf("%+v", c)
}
