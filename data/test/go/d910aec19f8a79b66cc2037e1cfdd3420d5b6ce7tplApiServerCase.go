package kmgRpc

import (
	"bytes"
)

func tplApiServerCase(config *tplConfig, api Api) string {
	var _buf bytes.Buffer
	_buf.WriteString(`

	case "`)
	_buf.WriteString(api.Name)
	_buf.WriteString(`":
	    `)
	for _, args := range api.GetOutArgsListWithoutError() {
		_buf.WriteString(`
	       var `)
		_buf.WriteString(args.Name)
		_buf.WriteString(` `)
		_buf.WriteString(args.ObjectTypeStr)
		_buf.WriteString(`
	    `)
	}
	_buf.WriteString(`
		var Err error
		reqData := &struct {
            `)
	for _, args := range api.GetClientInArgsList() {
		_buf.WriteString(`
               `)
		_buf.WriteString(args.Name)
		_buf.WriteString(` `)
		_buf.WriteString(args.ObjectTypeStr)
		_buf.WriteString(`
            `)
	}
	_buf.WriteString(`
		}{}
		Err = json.Unmarshal(b2, reqData)
		if Err != nil {
			return nil, Err
		}
		`)
	if api.HasHttpContextArgument() {
		_buf.WriteString(`
			Ctx:=kmgHttp.NewContextFromHttp(_httpW,_httpReq)
		`)
	}
	_buf.WriteString(`
		`)
	if api.HasReturnArgument() {
		_buf.WriteString(`
		    `)
		_buf.WriteString(api.GetOutArgsNameListForAssign())
		_buf.WriteString(` = s.obj.`)
		_buf.WriteString(api.Name)
		_buf.WriteString(`(`)
		_buf.WriteString(api.serverCallArgumentStr())
		_buf.WriteString(` )
            if Err != nil {
                return nil, Err
            }
		`)
	} else {
		_buf.WriteString(`
		    s.obj.`)
		_buf.WriteString(api.Name)
		_buf.WriteString(`(`)
		_buf.WriteString(api.serverCallArgumentStr())
		_buf.WriteString(` )
		`)
	}
	_buf.WriteString(`
		`)
	if api.IsOutExpendToOneArgument() {
		_buf.WriteString(`
			return json.Marshal(Response)
        `)
	} else {
		_buf.WriteString(`
			return json.Marshal(struct {
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
			}{
                `)
		for _, arg := range api.GetOutArgsListWithoutError() {
			_buf.WriteString(`
                    `)
			_buf.WriteString(arg.Name)
			_buf.WriteString(`:`)
			_buf.WriteString(arg.Name)
			_buf.WriteString(`,
                `)
		}
		_buf.WriteString(`
			})
		`)
	}
	_buf.WriteString(`

`)
	return _buf.String()
}
