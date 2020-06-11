package kmgBootstrap

import (
	"bytes"
	"github.com/bronze1man/kmg/kmgXss"
)

func tplSelect(config Select) string {
	var _buf bytes.Buffer
	_buf.WriteString(`    <select class="form-control" `)
	if config.ReadOnly {
		_buf.WriteString(` disabled="true" `)
	} else {
		_buf.WriteString(` name="`)
		_buf.WriteString(kmgXss.H(config.Name))
		_buf.WriteString(`" `)
	}
	_buf.WriteString(` >
        `)
	for _, opt := range config.OptionList {
		_buf.WriteString(`        <option value="`)
		_buf.WriteString(kmgXss.H(opt.Value))
		_buf.WriteString(`" `)
		if opt.Value == config.Value {
			_buf.WriteString(` selected `)
		}
		_buf.WriteString(` `)
		if opt.Disable {
			_buf.WriteString(` disabled style="color:#ccc;background: #fff" `)
		}
		_buf.WriteString(` >
        `)
		_buf.WriteString(kmgXss.H(opt.ShowName))
		_buf.WriteString(`        </option>
        `)
	}
	_buf.WriteString(`    </select>
    `)
	if config.ReadOnly {
		_buf.WriteString(`    <input type="hidden" name="`)
		_buf.WriteString(kmgXss.H(config.Name))
		_buf.WriteString(`" value="`)
		_buf.WriteString(kmgXss.H(config.Value))
		_buf.WriteString(`">
    `)
	}
	return _buf.String()
}
