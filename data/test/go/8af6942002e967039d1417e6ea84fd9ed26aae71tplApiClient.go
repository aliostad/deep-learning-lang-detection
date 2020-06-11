package kmgRpcJava

import (
	"bytes"
)

func (config Api) tplApiClient() string {
	var _buf bytes.Buffer
	_buf.WriteString(`
        public `)
	_buf.WriteString(config.OutTypeString)
	_buf.WriteString(` `)
	_buf.WriteString(config.Name)
	_buf.WriteString(`(`)
	_buf.WriteString(config.getClientFuncInParameter())
	_buf.WriteString(`) throws Exception{
            `)
	_buf.WriteString(config.Name)
	_buf.WriteString(`RpcRequest reqData = new `)
	_buf.WriteString(config.Name)
	_buf.WriteString(`RpcRequest();
            `)
	for _, arg := range config.InArgsList {
		_buf.WriteString(`
                reqData.`)
		_buf.WriteString(arg.Name)
		_buf.WriteString(` = `)
		_buf.WriteString(arg.Name)
		_buf.WriteString(`;
            `)
	}
	_buf.WriteString(`
            `)
	if config.OutTypeFieldName != "" {
		_buf.WriteString(`
                return this.sendRequest("`)
		_buf.WriteString(config.Name)
		_buf.WriteString(`", reqData, `)
		_buf.WriteString(config.Name)
		_buf.WriteString(`RpcResponse.class).`)
		_buf.WriteString(config.OutTypeFieldName)
		_buf.WriteString(`;
            `)
	} else if config.OutTypeString == "void" {
		_buf.WriteString(`
                this.sendRequest("`)
		_buf.WriteString(config.Name)
		_buf.WriteString(`", reqData, `)
		_buf.WriteString(config.OutTypeString)
		_buf.WriteString(`.class);
            `)
	} else {
		_buf.WriteString(`
                return this.sendRequest("`)
		_buf.WriteString(config.Name)
		_buf.WriteString(`", reqData, `)
		_buf.WriteString(config.OutTypeString)
		_buf.WriteString(`.class);
            `)
	}
	_buf.WriteString(`
        }
`)
	return _buf.String()
}
