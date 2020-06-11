// Copyright © 2014-2016 Thomas Rabaix <thomas.rabaix@gmail.com>.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

package logger

import (
	"fmt"
	"os"
	"testing"

	log "github.com/Sirupsen/logrus"
	"github.com/rande/gonode/core/config"
	"github.com/stretchr/testify/assert"
)

func Test_Dispatch_SameLevel(t *testing.T) {

	e := &log.Entry{}
	e.Level = log.DebugLevel

	h := &MockedHook{}
	h.On("Fire", e).Return(nil)

	d := &DispatchHook{
		Hooks: make(map[log.Level][]log.Hook, 0),
	}
	d.Add(h, log.DebugLevel)
	d.Fire(e)

	h.AssertCalled(t, "Fire", e)
}

func Test_Dispatch_Debug(t *testing.T) {

	e := &log.Entry{}
	e.Level = log.DebugLevel

	h := &MockedHook{}
	h.On("Fire", e).Return(nil)

	d := &DispatchHook{
		Hooks: make(map[log.Level][]log.Hook, 0),
	}
	d.Add(h, log.WarnLevel)
	d.Fire(e)

	h.AssertNotCalled(t, "Fire", e)
}

func Test_Dispatch_Fatal(t *testing.T) {

	e := &log.Entry{}
	e.Level = log.FatalLevel

	h := &MockedHook{}
	h.On("Fire", e).Return(nil)

	d := &DispatchHook{
		Hooks: make(map[log.Level][]log.Hook, 0),
	}
	d.Add(h, log.WarnLevel)
	d.Fire(e)

	h.AssertCalled(t, "Fire", e)
}

func Test_Config_Influx(t *testing.T) {
	hook, err := GetHook(map[string]interface{}{
		"service": "influxdb",
		"tags":    []string{"salut"},
		"url":     fmt.Sprintf("http://%s:8086", os.Getenv("INFLUXDB_HOST")),
	})

	assert.NoError(t, err)
	assert.NotNil(t, hook)
}

func Test_Config_Influx_From_Config(t *testing.T) {
	conf := &config.Config{
		Databases: make(map[string]*config.Database),
	}

	err := config.LoadConfigurationFromString(`
[logger]
    [logger.hooks]
        [logger.hooks.default]
        service = "influxdb"
        url = "http://{{ env "INFLUXDB_HOST" }}:8086"
        tags = ["app.core"]
        database = "gonode_stats"
        level = "debug"

`, conf)

	assert.NoError(t, err)

	hook, err := GetHook(conf.Logger.Hooks["default"])

	assert.NoError(t, err)
	assert.NotNil(t, hook)
}
