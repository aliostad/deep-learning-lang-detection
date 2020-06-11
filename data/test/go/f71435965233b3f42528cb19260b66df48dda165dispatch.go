package frontend

import (
	"errors"
	"fmt"
	"github.com/juju/loggo"
	"github.com/zeronetscript/universal_p2p/backend"
	"io"
	"net/http"
	"strings"
)

var dispatchLog = loggo.GetLogger("Dispatch")

func parseHttpRequest(URL string) (commonRequest backend.CommonRequest, pathArray []string, err error) {
	dispatchLog.Tracef("accessing %s", URL)

	trimmed := strings.TrimRight(strings.TrimLeft(URL, backend.SLASH), backend.SLASH)

	allPathArray := strings.Split(trimmed, backend.SLASH)

	if len(allPathArray) < 3 {
		errStr := fmt.Sprintf("url access path is '%s', less than needed (at least 3)", trimmed)
		return backend.CommonRequest{}, nil, errors.New(errStr)
	}

	commonRequest = backend.CommonRequest{
		RootProtocol: allPathArray[0],
		SubVersion:   allPathArray[1],
		RootCommand:  allPathArray[2],
	}

	pathArray = allPathArray[3:]

	dispatchLog.Debugf("RootProtocol:%s,SubVersion:%s,RootCommand:%s",
		commonRequest.RootProtocol, commonRequest.SubVersion, commonRequest.RootCommand)
	err = nil
	return
}

func HttpAndLogError(str string, l *loggo.Logger, w http.ResponseWriter) {
	l.Errorf(str)
	http.Error(w, str, 404)
}

func Dispatch(w http.ResponseWriter, request *http.Request) {

	if request.Method != "GET" && request.Method != "POST" {
		HttpAndLogError(fmt.Sprintf("unsupported method %s", request.Method), &dispatchLog, w)
		return
	}

	commonRequest, pathArray, err := parseHttpRequest(request.URL.Path)

	if err != nil {
		frontLog.Errorf(err.Error())
		http.Error(w, err.Error(), 404)
		return
	}

	frontend, exist := AllFrontEnd[commonRequest.RootProtocol]

	if !exist {
		HttpAndLogError(fmt.Sprintf("not support protocol", commonRequest.RootProtocol), &dispatchLog, w)
		return
	}

	var parsedRequest interface{}

	var rd io.ReadCloser

	if request.Method == "GET" {
		parsedRequest = &backend.AccessRequest{
			CommonRequest: commonRequest,
			SubPath:       pathArray,
		}
	} else {

		const MAX_POST_DATA = 2 * 1024 * 1024
		er := request.ParseMultipartForm(MAX_POST_DATA)
		if er != nil {
			HttpAndLogError(fmt.Sprintf("error parsing form %s", er), &dispatchLog, w)
			return
		}

		const UPLOAD_KEY = "UPLOAD"

		list, ok := request.MultipartForm.File[UPLOAD_KEY]

		for k := range request.MultipartForm.File {
			dispatchLog.Debugf("key %s", k)
		}

		if !ok {
			HttpAndLogError(fmt.Sprintf("no such key %s", UPLOAD_KEY), &dispatchLog, w)
			return
		}

		if len(list) <= 0 {
			HttpAndLogError("file list 0", &dispatchLog, w)
			return
		}

		f, err := list[0].Open()

		if err != nil {
			HttpAndLogError(fmt.Sprintf("error open multi part:%s", err), &dispatchLog, w)
			return
		}

		rd = f

		parsedRequest = &backend.UploadDataRequest{
			CommonRequest: commonRequest,
			UploadReader:  f,
		}
	}
	//predefined command

	if rd != nil {
		defer rd.Close()
	}

	_, exist = backend.AllBackend[commonRequest.RootProtocol]

	if !exist {
		errStr := fmt.Sprintf("protocol %s not supported", commonRequest.RootProtocol)
		dispatchLog.Warningf(errStr)
		http.Error(w, errStr, http.StatusServiceUnavailable)
		return
	}

	frontend.HandleRequest(w, request, parsedRequest)
}
