package foolgo

import (
	"fmt"
	"net/http"
	"reflect"
	"strings"
)

var dispatcher_instance *Dispatcher

type Dispatcher struct {
	server_config   *HttpServerConfig
	before_dispatch string
	after_dispatch  string
}

func NewDispatcher(http_server_config ...*HttpServerConfig) *Dispatcher { /*{{{*/
	if dispatcher_instance != nil {
		return dispatcher_instance
	}

	dispatcher_instance = &Dispatcher{
		server_config:   http_server_config[0],
		before_dispatch: "BeforeDispatch",
		after_dispatch:  "AfterDispatch",
	}

	return dispatcher_instance
} /*}}}*/

func (this *Dispatcher) Dispatch_handler(w http.ResponseWriter, r *http.Request) { /*{{{*/
	//init request
	request := NewRequest(r)
	router := GetRouter()
	response := NewResponse(w, request, this.server_config)

	var controller_name string
	var action_name string
	var match_param map[string]string
	var ok error

	response.Header("Status", fmt.Sprintf("%d", http.StatusOK))

	url := strings.TrimRight(request.Url(), "/")
	if url != "" { //有url
		controller_name, action_name, match_param, ok = router.MatchRewrite(url, request.Method())
		if ok != nil {
			//静态资源
			OutStaticFile(response, request, url)
			return
		}
		if match_param != nil {
			request.rewrite_params = match_param
		}
		action_name = strings.TrimSuffix(action_name, ACTION_SUFFIX)
	} else if url == "" && request.Param(HTTP_METHOD_PARAM_NAME) == "" { //首页
		controller_name = DEFAULT_CONTROLLER
		action_name = DEFAULT_ACTION
	} else if request.Param(HTTP_METHOD_PARAM_NAME) != "" {
		controller_name, action_name = router.ParseMethod(request.Param(HTTP_METHOD_PARAM_NAME))
		action_name = strings.Title(strings.ToLower(action_name))
	}

	request.SetController(controller_name)
	request.SetAction(action_name)

	controller, err := router.NewController(controller_name)
	if err != nil {
		OutErrorHtml(response, request, http.StatusNotFound)
		return
	}

	controller_handler := controller.MethodByName(action_name + ACTION_SUFFIX)
	if controller_handler.IsValid() == false {
		OutErrorHtml(response, request, http.StatusNotFound)
		return
	}

	init_params := make([]reflect.Value, 2)
	init_params[0] = reflect.ValueOf(request)
	init_params[1] = reflect.ValueOf(response)

	init_handler := controller.MethodByName("Init")
	if init_handler.IsValid() == false {
		logger.ErrorLog("Can't find method of \"Init\" in controller " + controller_name)
		OutErrorHtml(response, request, http.StatusInternalServerError)
		return
	}

	request_handlers := make([]reflect.Value, 0)
	if before_handler := controller.MethodByName(this.before_dispatch); before_handler.IsValid() == true {
		request_handlers = append(request_handlers, before_handler)
	}

	request_handlers = append(request_handlers, controller_handler)

	if after_handler := controller.MethodByName(this.after_dispatch); after_handler.IsValid() == true {
		request_handlers = append(request_handlers, after_handler)
	}

	//执行 Init()
	init_result := init_handler.Call(init_params)

	if reflect.Indirect(init_result[0]).Bool() == false {
		logger.ErrorLog("Method of \"Init\" in controller " + controller_name + " return false")
		OutErrorHtml(response, request, http.StatusInternalServerError)
		return
	}

	request_params := make([]reflect.Value, 0)
	//Run : Init -> before_dispatch -> controller_handler -> after_dispatch
	for _, v := range request_handlers {
		v.Call(request_params)
	}

	response.Header("Connection", request.Header("Connection"))
} /*}}}*/
