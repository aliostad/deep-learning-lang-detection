package kmgRpc

import (
	"bytes"
)

func tplApiClient(config *tplConfig, api Api) string {
	var _buf bytes.Buffer
	_buf.WriteString(`

func (c *Client_`)
	_buf.WriteString(config.ObjectName)
	_buf.WriteString(` ) `)
	_buf.WriteString(api.Name)
	_buf.WriteString(`( `)
	for _, arg := range api.GetClientInArgsList() {
		_buf.WriteString(arg.Name)
		_buf.WriteString(` `)
		_buf.WriteString(arg.ObjectTypeStr)
		_buf.WriteString(`, `)
	}
	_buf.WriteString(`  ) (`)
	for _, arg := range api.GetClientOutArgument() {
		_buf.WriteString(arg.Name)
		_buf.WriteString(` `)
		_buf.WriteString(arg.ObjectTypeStr)
		_buf.WriteString(`, `)
	}
	_buf.WriteString(` ) {
	reqData := &struct {
	    `)
	for _, arg := range api.GetClientInArgsList() {
		_buf.WriteString(`
	        `)
		_buf.WriteString(arg.Name)
		_buf.WriteString(` `)
		_buf.WriteString(arg.ObjectTypeStr)
		_buf.WriteString(`
	    `)
	}
	_buf.WriteString(`
	}{
        `)
	for _, arg := range api.GetClientInArgsList() {
		_buf.WriteString(`
            `)
		_buf.WriteString(arg.Name)
		_buf.WriteString(`:`)
		_buf.WriteString(arg.Name)
		_buf.WriteString(`,
        `)
	}
	_buf.WriteString(`
	}
	`)
	if api.IsOutExpendToOneArgument() {
		_buf.WriteString(`
	    var respData `)
		_buf.WriteString(api.OutArgsList[0].ObjectTypeStr)
		_buf.WriteString(`
        Err = c.sendRequest("`)
		_buf.WriteString(api.Name)
		_buf.WriteString(`", reqData, &respData)
        return respData,Err
	`)
	} else {
		_buf.WriteString(`
        respData := &struct {
            `)
		for _, arg := range api.GetOutArgsListWithoutError() {
			_buf.WriteString(`
                `)
			_buf.WriteString(arg.Name)
			_buf.WriteString(` `)
			_buf.WriteString(arg.ObjectTypeStr)
			_buf.WriteString(`
            `)
		}
		_buf.WriteString(`
        }{}
        Err = c.sendRequest("`)
		_buf.WriteString(api.Name)
		_buf.WriteString(`", reqData, &respData)
        return `)
		for _, arg := range api.GetOutArgsListWithoutError() {
			_buf.WriteString(`respData.`)
			_buf.WriteString(arg.Name)
			_buf.WriteString(`,`)
		}
		_buf.WriteString(` Err
    `)
	}
	_buf.WriteString(`
}

`)
	return _buf.String()
}
