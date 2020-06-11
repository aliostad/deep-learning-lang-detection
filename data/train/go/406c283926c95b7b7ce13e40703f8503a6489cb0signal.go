package main

import (
	"os"
	"os/signal"
	"sync"
)

type SignalHandlerFunc func()

type SignalHandler struct {
	lgr           LOGGER
	wg            *sync.WaitGroup
	signalChan    chan os.Signal
	dispatchTable map[os.Signal]SignalHandlerFunc
}

func NewSignalHandler(lgr LOGGER, signalChan chan os.Signal,
	wg *sync.WaitGroup, dispatchTable map[os.Signal]SignalHandlerFunc) (
	*SignalHandler, error) {

	sighan := &SignalHandler{
		lgr:           lgr,
		wg:            wg,
		signalChan:    signalChan,
		dispatchTable: dispatchTable,
	}
	return sighan, nil
}

func (s *SignalHandler) Run() {
	s.lgr.Infof("started")
	signal.Notify(s.signalChan)
	for sig := range s.signalChan {
		s.handle(sig)
	}
	signal.Reset()
	signal.Stop(s.signalChan)
	s.wg.Done()
	s.lgr.Infof("stopped")
}

func (s *SignalHandler) handle(sig os.Signal) {
	s.lgr.Warnf("Captured signal %q", sig)
	fn, ok := s.dispatchTable[sig]
	if !ok {
		s.lgr.Warnf("No func for signal %q - ignoring", sig)
		return
	}
	fn()
}
