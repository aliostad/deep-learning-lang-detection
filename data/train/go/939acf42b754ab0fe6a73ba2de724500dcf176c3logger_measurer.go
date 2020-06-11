package grpcinstrument

type loggerMeasurer struct {
	logger   Logger
	measurer Measurer
}

func newLoggerMeasurer(logger Logger, measurer Measurer) Instrumentator {
	return &loggerMeasurer{logger, measurer}
}

// Init calls Init() on both the logger and measurer.
func (i *loggerMeasurer) Init() error {
	if err := i.logger.Init(); err != nil {
		return err
	}
	if err := i.measurer.Init(); err != nil {
		return err
	}
	return nil
}

// Instrument proxies to the logger and measurer.
func (i *loggerMeasurer) Instrument(call *Call) {
	i.logger.Log(call)
	i.measurer.Measure(call)
}
