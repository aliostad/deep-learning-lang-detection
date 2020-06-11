package kmgRpcSwift

import (
	"bytes"
	"github.com/bronze1man/kmg/kmgStrings"
	"strings"
)

func (config InnerClass) tplInnerClass() string {
	var _buf bytes.Buffer
	_buf.WriteString(`
    `)
	if config.IsPublic {
	} else {
		_buf.WriteString(`private`)
	}
	_buf.WriteString(` struct `)
	_buf.WriteString(config.Name)
	_buf.WriteString(`{
        `)
	for _, field := range config.FieldList {
		_buf.WriteString(`
            var `)
		_buf.WriteString(field.Name)
		_buf.WriteString(`:`)
		_buf.WriteString(field.TypeStr)
		_buf.WriteString(` = `)
		_buf.WriteString(field.TypeStr)
		_buf.WriteString(`()
        `)
	}
	_buf.WriteString(`
`)
	if config.IsPublic {
		_buf.WriteString(`
mutating func ToData(inData:JSON){
`)
		for _, field := range config.FieldList {
			_buf.WriteString(`
`)
			switch field.TypeStr {
			case "Int":
				_buf.WriteString(`self.`)
				_buf.WriteString(field.Name)
				_buf.WriteString(` = inData["`)
				_buf.WriteString(field.Name)
				_buf.WriteString(`"].intValue
        `)
			case "NSString":
				_buf.WriteString(`self.`)
				_buf.WriteString(field.Name)
				_buf.WriteString(` = inData["`)
				_buf.WriteString(field.Name)
				_buf.WriteString(`"].stringValue
        `)
			case "Bool":
				_buf.WriteString(`self.`)
				_buf.WriteString(field.Name)
				_buf.WriteString(` = inData["`)
				_buf.WriteString(field.Name)
				_buf.WriteString(`"].boolValue
        `)
			case "NSDate":
				_buf.WriteString(`self.`)
				_buf.WriteString(field.Name)
				_buf.WriteString(` = inData["`)
				_buf.WriteString(field.Name)
				_buf.WriteString(`"].stringValue.toDate(format: DateFormat.ISO8601)!
        `)
			case "[NSString]", "[Int]", "[Bool]", "[NSDate]":
				_buf.WriteString(`self.`)
				_buf.WriteString(field.Name)
				_buf.WriteString(` = inData["`)
				_buf.WriteString(field.Name)
				_buf.WriteString(`"].arrayObject as! `)
				_buf.WriteString(field.TypeStr)
				_buf.WriteString(`
        `)
			default:
				if strings.HasPrefix(field.TypeStr, "[") {
					_buf.WriteString(` inData["Some"].array!.forEach({body in
        `)
					oneType := kmgStrings.SubStr(field.TypeStr, 1, -1)
					_buf.WriteString(`
        var one:`)
					_buf.WriteString(oneType)
					_buf.WriteString(` = `)
					_buf.WriteString(oneType)
					_buf.WriteString(`()
        one.ToData(body)
        self.`)
					_buf.WriteString(field.Name)
					_buf.WriteString(`.append(one)
        })`)
				} else {
					_buf.WriteString(`.ToData(inData["`)
					_buf.WriteString(field.Name)
					_buf.WriteString(`"])`)
				}
			}
			_buf.WriteString(`
    `)
		}
		_buf.WriteString(`
    }
`)
	}
	_buf.WriteString(`
}
`)
	return _buf.String()
}
