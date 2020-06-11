package kmgBootstrap

import (
	"bytes"
	"github.com/bronze1man/kmg/kmgXss"
)

func tplButton(button Button) string {
	var _buf bytes.Buffer
	_buf.WriteString(`<`)
	_buf.WriteString(kmgXss.H(string(button.Type)))
	_buf.WriteString(` `)
	if button.FormId != "" {
		_buf.WriteString(` form="`)
		_buf.WriteString(kmgXss.H(button.FormId))
		_buf.WriteString(`" `)
	}
	if button.Type == ButtonTypeA {
		_buf.WriteString(`    `)
		if button.Url == "" {
			_buf.WriteString(`    href="javascript:void(0);"
    `)
		} else {
			_buf.WriteString(`    href="`)
			_buf.WriteString(kmgXss.H(button.Url))
			_buf.WriteString(`"
    `)
		}
	}
	if button.Name != "" {
		_buf.WriteString(`    name="`)
		_buf.WriteString(kmgXss.H(button.Name))
		_buf.WriteString(`"`)
	}
	if button.Value != "" {
		_buf.WriteString(`    value="`)
		_buf.WriteString(kmgXss.H(button.Value))
		_buf.WriteString(`"`)
	}
	if button.Type == ButtonTypeButton {
		_buf.WriteString(`    type="submit"`)
	}
	if button.AttributeNode != nil {
		_buf.WriteString(`    `)
		_buf.WriteString(button.AttributeNode.HtmlRender())
	}
	_buf.WriteString(`class="btn `)
	_buf.WriteString(kmgXss.H(string(button.Color)))
	_buf.WriteString(` `)
	_buf.WriteString(kmgXss.H(string(button.Size)))
	_buf.WriteString(` `)
	_buf.WriteString(kmgXss.H(button.ClassName))
	_buf.WriteString(`"
id="`)
	_buf.WriteString(kmgXss.H(button.Id))
	_buf.WriteString(`"
>
    `)
	_buf.WriteString(button.Content.HtmlRender())
	_buf.WriteString(`</`)
	_buf.WriteString(kmgXss.H(string(button.Type)))
	_buf.WriteString(`>`)
	return _buf.String()
}
