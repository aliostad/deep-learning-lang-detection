package logkit

type OutputFilter struct {
	parent                                                                                    Output
	writeOperationBegin, writeOperationComplete, writeDebug, writeInfo, writeWarn, writeError bool
}

func NewOutputFilter(parent Output, writeOperationBegin, writeOperationComplete, writeDebug, writeInfo, writeWarn, writeError bool) Output {
	return &OutputFilter{parent, writeOperationBegin, writeOperationComplete, writeDebug, writeInfo, writeWarn, writeError}
}

func (d *OutputFilter) Event(evt Event) {
	switch evt.Type {
	case EventTypeBeginOperation:
		if d.writeOperationBegin {
			d.parent.Event(evt)
		}
	case EventTypeCompleteOperation:
		if d.writeOperationComplete {
			d.parent.Event(evt)
		}
	case EventTypeDebug:
		if d.writeDebug {
			d.parent.Event(evt)
		}
	case EventTypeInfo:
		if d.writeInfo {
			d.parent.Event(evt)
		}
	case EventTypeWarn:
		if d.writeWarn {
			d.parent.Event(evt)
		}
	case EventTypeError:
		if d.writeError {
			d.parent.Event(evt)
		}
	}
}
