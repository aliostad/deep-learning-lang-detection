// Copyright © 2014-2016 Thomas Rabaix <thomas.rabaix@gmail.com>.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

package logger

import (
	log "github.com/Sirupsen/logrus"
)

type DispatchHook struct {
	Hooks map[log.Level][]log.Hook
}

func (d *DispatchHook) Add(h log.Hook, l log.Level) {

	d.Hooks[l] = append(d.Hooks[l], h)
}

func (d *DispatchHook) Levels() []log.Level {
	return []log.Level{
		log.PanicLevel,
		log.FatalLevel,
		log.ErrorLevel,
		log.WarnLevel,
		log.InfoLevel,
		log.DebugLevel,
	}
}

func (d *DispatchHook) Fire(e *log.Entry) error {

	for l := range d.Hooks {
		if _, ok := d.Hooks[l]; ok && l >= e.Level {
			for _, h := range d.Hooks[l] {
				h.Fire(e)
			}
		}
	}

	return nil
}
