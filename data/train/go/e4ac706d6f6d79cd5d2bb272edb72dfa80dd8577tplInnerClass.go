package kmgRpcJava

import (
	"bytes"
)

func (config InnerClass) tplInnerClass() string {
	var _buf bytes.Buffer
	_buf.WriteString(`
    `)
	if config.IsPublic {
		_buf.WriteString(`public`)
	} else {
		_buf.WriteString(`private`)
	}
	_buf.WriteString(` static class `)
	_buf.WriteString(config.Name)
	_buf.WriteString(`{
        `)
	for _, field := range config.FieldList {
		_buf.WriteString(`
            public `)
		_buf.WriteString(field.TypeStr)
		_buf.WriteString(` `)
		_buf.WriteString(field.Name)
		_buf.WriteString(`;
        `)
	}
	_buf.WriteString(`
    }
`)
	return _buf.String()
}
