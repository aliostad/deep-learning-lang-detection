package http_server

import (
	"encoding/json"
	"fmt"
	"github.com/giskook/bed2/base"
	"io/ioutil"
	"log"
	"net/http"
)

type LoadBinCode int

const (
	LOAD_BIN_SUCCESS        LoadBinCode = 0
	LOAD_BIN_UNAVAILABLE    LoadBinCode = 1
	LOAD_BIN_FILE_NOT_FIND  LoadBinCode = 2
	LOAD_BIN_LACK_PARAMTER  LoadBinCode = 3
	LOAD_BIN_INTERAL_ERROR  LoadBinCode = 4
	LOAD_BIN_READFILE_ERROR LoadBinCode = 5
)

var LOAD_BIN_CODE_DESC = []string{"成功", "有终端正在升级，稍后重试", "找不到bin文件", "请检查参数", "内部错误", "读取bin文件错误"}

func (c LoadBinCode) Desc() string {
	return LOAD_BIN_CODE_DESC[int(c)]
}

type RepLoadBin struct {
	Code int    `json:"code"`
	Desc string `json:"desc"`
}

func EncodeRepLoadBin(code LoadBinCode, r *http.Request) string {
	resp := &RepTransparentTransmission{
		Code: int(code),
		Desc: code.Desc(),
	}

	response, _ := json.Marshal(resp)
	RecordRecv(r, string(response))

	return string(response)
}

func (h *HttpServer) HandleLoadBin(endpoint string) {
	h.mux.HandleFunc(endpoint, func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if x := recover(); x != nil {
				fmt.Fprint(w, EncodeRepLoadBin(LOAD_BIN_INTERAL_ERROR, r))
			}
		}()
		RecordSend(r)
		r.ParseForm()
		path := r.Form.Get("path")
		if path == "" {
			fmt.Fprint(w, EncodeRepLoadBin(LOAD_BIN_LACK_PARAMTER, r))
			RecordSendLackParamter(r)
			return
		}
		base.GetTTB().SetMode(base.TTB_MODE_UNAVAILABLE)
		if !base.GetTTB().IsLoadAvailable() {
			fmt.Fprint(w, EncodeRepLoadBin(LOAD_BIN_UNAVAILABLE, r))
			return
		}

		bin, err := ioutil.ReadFile(path)
		if err != nil {
			fmt.Fprint(w, EncodeRepLoadBin(LOAD_BIN_READFILE_ERROR, r))
			log.Println(err.Error())
			return
		}

		base.GetTTB().SetBytes(bin)
		base.GetTTB().SetMode(base.TTB_MODE_NORMAL)
		fmt.Fprint(w, EncodeRepLoadBin(LOAD_BIN_SUCCESS, r))
	})
}
