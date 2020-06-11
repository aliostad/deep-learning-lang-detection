package kmgRpcSwift

import (
	"bytes"
)

func (config Api) tplApiClient() string {
	var _buf bytes.Buffer
	_buf.WriteString(`
        func `)
	_buf.WriteString(config.Name)
	_buf.WriteString(`(`)
	_buf.WriteString(config.getClientFuncInParameter())
	_buf.WriteString(`)`)
	if config.OutTypeString != "void" {
		_buf.WriteString(`->`)
		_buf.WriteString(config.OutTypeString)
	}
	_buf.WriteString(`{
                var params: Dictionary<String,AnyObject> = Dictionary()
                `)
	for _, arg := range config.InArgsList {
		_buf.WriteString(`
                    params["`)
		_buf.WriteString(arg.Name)
		_buf.WriteString(`"]=`)
		_buf.WriteString(arg.Name)
		_buf.WriteString(`
                                `)
	}
	_buf.WriteString(`
                `)
	if config.OutTypeString != "void" {
		_buf.WriteString(`
                var out = `)
		_buf.WriteString(config.OutTypeString)
		_buf.WriteString(`()
                func `)
		_buf.WriteString(config.Name)
		_buf.WriteString(`Data(outData:JSON){
                `)
		if config.OutTypeString == "NSString" {
			_buf.WriteString(`
                        out = outData["Out_0"].stringValue
                `)
		} else if config.OutTypeString == "Int" {
			_buf.WriteString(`
                        out = outData["Out-0"].intValue
                `)
		} else if config.OutTypeString == "NSDate" {
			_buf.WriteString(`
                        out = outData["Out_0"].stringValue.toDate(format: DateFormat.ISO8601)!
                `)
		} else {
			_buf.WriteString(`
                        out.ToData(outData["Out_0"])
                `)
		}
		_buf.WriteString(`
                }
                sendRequest("`)
		_buf.WriteString(config.Name)
		_buf.WriteString(`",params:params,callback:`)
		_buf.WriteString(config.Name)
		_buf.WriteString(`Data )
                return out
                `)
	} else {
		_buf.WriteString(`
                sendRequest("`)
		_buf.WriteString(config.Name)
		_buf.WriteString(`",params:params,callback:{JSON in })
                `)
	}
	_buf.WriteString(`
        }
`)
	return _buf.String()
}
