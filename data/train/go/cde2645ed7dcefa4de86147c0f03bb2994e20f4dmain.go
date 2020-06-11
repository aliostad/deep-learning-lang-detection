package main

import (
	"com.copooo/switch/mylog"
	"com.copooo/switch/push"
	"com.copooo/switch/view"
	"encoding/json"
	"github.com/xlong/aesutil"
	"io/ioutil"
	"net/http"
	"strings"
)

//aes key
const keystr = "1234567812345678"

//RESTFULL请求中的消息是否已加密
const encrypted = true

func main() {
	handler := PreHandler{username: "admin", password: "123456"}
	mylog.Info.Print("listening at :8085\n")
	http.ListenAndServe(":8085", handler)
}

type PreHandler struct {
	username string
	password string
}

func (ph PreHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	mylog.Info.Printf("===========请求开始preHandler: %s============\n", r.URL.Path)

	if strings.HasPrefix(r.URL.Path, "/js/") || strings.HasPrefix(r.URL.Path, "/css/") {
		fileserver := http.FileServer(http.Dir("."))
		fileserver.ServeHTTP(w, r)
		return
	}
	switch r.URL.Path {
	case "/view/switchUnbind":
		ph.basicAuthDispatch(w, r, view.HandleSwitchUnBind)
		break
	case "/view/switch":
		ph.basicAuthDispatch(w, r, view.HandleSwitchBind)
		break
	case "/view/users":
		ph.basicAuthDispatch(w, r, view.HandleUsers)
		break
	case "/view/interactive":
		ph.basicAuthDispatch(w, r, view.HanldeInteractiveRec)
		break
	case "/view/users/delete":
		ph.basicAuthDispatch(w, r, view.HandleUsersDelete)
		break
	case "/view/users/add":
		ph.basicAuthDispatch(w, r, view.HandleUserAdd)
		break
	case "/switch/addAsk":
		dispatch(addAsk, w, r)
		break
	case "/switch/updateAnswer":
		dispatch(updateAnswer, w, r)
		break
	case "/app/modifyPhone":
		dispatch(modifyPhone, w, r)
		break
	case "/app/checkUsernameExist":
		dispatch(checkUsernameExist, w, r)
	case "/app/checkSmscode":
		dispatch(checkSmscode, w, r)
		break
	case "/app/newPassword":
		dispatch(setNewPassword, w, r)
		break
	case "/app/bindSwitch":
		dispatch(bindSwitch, w, r)
		break
	case "/app/smscode":
		dispatch(smscode, w, r)
		break
	case "/app/register":
		dispatch(register, w, r)
		break
	case "/app/login":
		dispatch(login, w, r)
		break
	case "/app/downloadApk":
		downloadApk(w)
		break
	case "/app/checkUpdate":
		dispatch(checkUpdate, w, r)
		break
	case "/mqtt":
		s := "{\"name\":\"server\", \"msg\":\"hello client\"}"
		push.SendPush(s, s)
		break
	default:
		http.NotFound(w, r)
		break
	}
}

func (ph *PreHandler) basicAuthDispatch(w http.ResponseWriter, r *http.Request,
	process func(w http.ResponseWriter, r *http.Request)) {
	username, password, ok := r.BasicAuth()
	var access bool
	if !ok {
		access = false
	} else {
		if username == ph.username && password == ph.password {
			access = true
		} else {
			access = false
		}
	}

	if !access {
		w.Header().Add("WWW-Authenticate", "Basic realm=\"Login Required\"")
		http.Error(w, "未认证用户", http.StatusUnauthorized)
	} else {
		process(w, r)
	}
}

func dispatch(process func(w http.ResponseWriter, r *http.Request),
	w http.ResponseWriter, r *http.Request) {

	if r.Method != http.MethodPost {
		http.Error(w, "method not support", http.StatusMethodNotAllowed)
		return
	}
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	params := string(body)
	if len(params) == 0 {
		http.Error(w, "参数不能为空", http.StatusBadRequest)
		return
	}
	mylog.Info.Printf("参数：%s", params)
	if encrypted {
		result, err := aesutil.DecryptECB128(params, []byte(keystr))
		if err != nil {
			//http.Error(w, "解析参数出错", http.StatusExpectationFailed)
			//return
			mylog.Error.Println("解密失败")
		} else {
			params = result
			mylog.Info.Printf("参数解密：%s\n", params)
		}
	}
	r.ParseForm()
	r.Form.Add("json", params)

	process(w, r)
}

func getParamsMap(r *http.Request) map[string]interface{} {
	j := r.Form.Get("json")
	m := make(map[string]interface{})
	json.Unmarshal([]byte(j), &m)
	return m
}
