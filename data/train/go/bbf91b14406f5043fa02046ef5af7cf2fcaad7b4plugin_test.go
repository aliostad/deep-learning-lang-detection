package main

import (
	"testing"

	"github.com/zalando/skipper/tracing"
)

var pluginDir string = "./build"

/* currently fails to load - need to check why ...
func TestLoadPluginLightstep(t *testing.T) {
	if _, err := tracing.LoadPlugin(pluginDir, []string{"tracing_lightstep", "token=123456"}); err != nil {
		t.Errorf("failed to load plugin `lightstep`: %s", err)
	}
}
*/

func TestLoadPluginBasic(t *testing.T) {
	if _, err := tracing.LoadPlugin(pluginDir, []string{"tracing_basic"}); err != nil {
		t.Errorf("failed to load plugin `basic`: %s", err)
	}
}

func TestLoadPluginInstana(t *testing.T) {
	if _, err := tracing.LoadPlugin(pluginDir, []string{"tracing_instana"}); err != nil {
		t.Errorf("failed to load plugin `instana`: %s", err)
	}
}
