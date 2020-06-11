package slog

import "testing"

func TestTCache(t *testing.T) {
	tc := targetCache{
		targets: make(map[Level]func(map[string]interface{})),
	}
	ch := make(chan string, 1)
	tc.targets[LDebug] = func(_ map[string]interface{}) {
		ch <- "debug"
	}
	tc.targets[LError] = func(_ map[string]interface{}) {
		ch <- "error"
	}
	tc.defaultTarget = func(_ map[string]interface{}) {
		ch <- "idk"
	}

	tc.dispatch(LDebug, nil)
	if out := <-ch; out != "debug" {
		t.Errorf("expected debug, got %s", out)
	}
	tc.dispatch(LError, nil)
	if out := <-ch; out != "error" {
		t.Errorf("expected error, got %s", out)
	}
	tc.dispatch(LWarn, nil)
	if out := <-ch; out != "idk" {
		t.Errorf("expected idk, got %s", out)
	}
}
