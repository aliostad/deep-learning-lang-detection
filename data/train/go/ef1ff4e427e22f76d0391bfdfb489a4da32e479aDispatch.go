package dispatch

import (
	"config"
	. "network"
	. "protocol"
	"strings"
	. "util"
)

type Context struct {
	mRequest  *Request
	mResponse *Response
	mConnId   int32
}

func (c *Context) GetConnection() int32 {
	return c.mConnId
}

type Dispatcher struct {
	mReqContextChan chan Context
	mRepContextChan chan Context
	mRequestNum     int64
	mResponseNum    int64
	mLayer          ILayer
	mStack          IStack
	mContainer      IControllerContainer
}

// IController is interface, each controller must inplement it to handle request
type IController interface {
	Handle(context *Context, req *Request) *Response
}

// container of GetController(action int32) IController
type IControllerContainer interface {
	GetController(action int32) IController
}

type IResponseConsumer interface {
	OnResponseAvailable(connid int32, response *Response)
}

var logger = NewLogger("Dispatch")

// create A instance of RequestDistapch
func NewDispatcher(layer ILayer) *Dispatcher {
	dispatch := &Dispatcher{mReqContextChan: make(chan Context, config.CHANNEL_BUF_SIZE), mRepContextChan: make(chan Context, config.CHANNEL_BUF_SIZE), mRequestNum: 0, mResponseNum: 0, mLayer: layer, mStack: nil}
	if strings.EqualFold("PB", config.PROTO_TYPE) {
		dispatch.mStack = &PBStack{}
	}
	return dispatch
}

// receive data from connection
func (rd *Dispatcher) OnRawDataAvailable(connid int32, raw []byte) {
	request, err := rd.mStack.UnpackRequest(raw)
	if err != nil {
		logger.Errorln(err)
		return
	}

	rd.mReqContextChan <- Context{mRequest: request, mConnId: connid}
}

func (rd *Dispatcher) DispatchRequest() {
	for {
		context, ok := <-rd.mReqContextChan
		if ok == false {
			logger.Debugln("Channel RequestDispatch is closed")
			continue
		}

		rd.mRequestNum++
		var request *Request = context.mRequest
		// before handle request,  layers will preprocess and filter
		if rd.mLayer.OnRequestAvailable(request) == false {
			continue
		}

		// Based on the action,  controller will handle the request
		handler := rd.mContainer.GetController(request.Action)
		if handler == nil {
			continue
		}
		response := handler.Handle(&context, request)

		// response  preprocess and filter
		if rd.mLayer.OnResponseAvailable(response) == false {
			continue
		}

		// protocal stack pack data to  raw data
		if response == nil || rd.mStack == nil {
			logger.Debugln("response is nil or stack is nil")
			continue
		}

		raw, err := rd.mStack.PackResponse(response)
		if err != nil {
			logger.Debugln("stack pack err ", err)
			continue
		}
		//logger.Debugf("send response %v\n", response)
		// send raw data by connection
		writer := GetConnectionManager().Get(context.mConnId)
		if writer != nil {
			writer.WriteData(raw)
		}
	}
}

func (rd *Dispatcher) OnResponseAvailable(connid int32, response *Response) {
	if response != nil && connid >= 0 {
		rd.mRepContextChan <- Context{mResponse: response, mConnId: connid}
	}
}

func (rd *Dispatcher) DispatchResponse() {
	for {
		context, ok := <-rd.mRepContextChan
		if ok == false {
			logger.Debugln("Channel DispatchResponse is closed")
			continue
		}

		rd.mResponseNum++
		raw, err := rd.mStack.PackResponse(context.mResponse)
		if err != nil {
			logger.Debugln("stack pack err ", err)
			continue
		}
		//logger.Debugf("send response %v\n", context.mResponse)
		// send raw data by connection
		// send raw data by connection
		writer := GetConnectionManager().Get(context.mConnId)
		if writer != nil {
			writer.WriteData(raw)
		}
	}
}

func InitDispatch(controllers IControllerContainer) *Dispatcher {
	// Layers used to decorate request and response
	layers := NewLayerManager()
	// Request dispatch, Response dispatch
	reqDispatch := NewDispatcher(layers)
	reqDispatch.mContainer = controllers
	go reqDispatch.DispatchRequest()
	go reqDispatch.DispatchResponse()
	logger.Debugln("Dispatch init ok")
	return reqDispatch
}
