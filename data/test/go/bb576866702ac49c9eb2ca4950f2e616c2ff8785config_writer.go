package fakes

import "github.com/cloudfoundry-incubator/consul-release/src/confab/config"

type ConfigWriter struct {
	WriteCall struct {
		CallCount int
		Configs   []config.Config
		Stub      func(config config.Config) error
		Receives  struct {
			Config config.Config
		}
		Returns struct {
			Error error
		}
	}
}

func (w *ConfigWriter) Write(cfg config.Config) error {
	w.WriteCall.Configs = append(w.WriteCall.Configs, cfg)
	w.WriteCall.Receives.Config = cfg
	w.WriteCall.CallCount++

	if w.WriteCall.Stub != nil {
		return w.WriteCall.Stub(cfg)
	}

	return w.WriteCall.Returns.Error
}
