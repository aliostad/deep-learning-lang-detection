package protocol

import (
	core "connect-server/protocol"
	"errors"
	"fmt"
)

type DispatchRequest struct {
	FromUuid string //16bytes
	DestUuid string //16bytes
	Token    string //16bytes
}

func (request *DispatchRequest) Encode() (buffer []byte, err error) {
	buffer = make([]byte, 48)
	fromBuff, err := core.StringToUuid(request.FromUuid)
	if err != nil {
		err = fmt.Errorf("DispatchRequest Encode Error : %v", err)
		return buffer, err
	}
	buffer = append(buffer, fromBuff...)

	destBuff, err := core.StringToUuid(request.FromUuid)
	if err != nil {
		err = fmt.Errorf("DispatchRequest Encode Error : %v", err)
		return buffer, err
	}
	buffer = append(buffer, destBuff...)

	tokenBuff, err := core.StringToUuid(request.Token)
	if err != nil {
		err = fmt.Errorf("DispatchRequest Encode Error : %v", err)
		return buffer, err
	}
	buffer = append(buffer, tokenBuff...)
	return buffer, err
}

func (request *DispatchRequest) Decode(buffer []byte) (err error) {
	if len(buffer) < 48 {
		err = errors.New("DispatchRequest Decode Error : the []byte is shorter than 48")
		return err
	}
	index := 0
	request.FromUuid, err = core.UuidToString(buffer[index : index+16])
	if err != nil {
		err = fmt.Errorf("DispacthREquest Decode Error : %v", err)
		return err
	}
	index += 16

	request.DestUuid, err = core.UuidToString(buffer[index : index+16])
	if err != nil {
		err = fmt.Errorf("DispacthREquest Decode Error : %v", err)
		return err
	}
	index += 16

	request.Token, err = core.UuidToString(buffer[index : index+16])
	if err != nil {
		err = fmt.Errorf("DispacthREquest Decode Error : %v", err)
		return err
	}
	index += 16

	return err
}

type DispatchMsgRequest struct {
	TsHead
	DispatchRequest
}

func (request *DispatchMsgRequest) Encode() (buffer []byte, err error) {
	headBuff, err := request.TsHead.Encode()
	if err != nil {
		err = fmt.Errorf("DispatchMsgRequest Encode Error : %v", err)
		return buffer, err
	}
	tempBuff, err := request.DispatchRequest.Encode()
	if err != nil {
		err = fmt.Errorf("DispatchMsgRequest Encode Error : %v", err)
		return buffer, err
	}
	buffer = make([]byte, len(headBuff)+len(tempBuff))
	buffer = append(buffer, headBuff...)
	buffer = append(buffer, tempBuff...)
	return buffer, err
}

func (request *DispatchMsgRequest) Decode(buffer []byte) (err error) {
	if len(buffer) != 60 {
		err = fmt.Errorf("DispatchMsgRequest Decode Error : the []byte is shorter than 60")
		return err
	}
	err = request.TsHead.Decode(buffer)
	if err != nil {
		err = fmt.Errorf("DispatchMsgRequest Decode Error : %v", err)
		return err
	}
	err = request.DispatchRequest.Decode(buffer[12:])
	if err != nil {
		err = fmt.Errorf("DispatchMsgRequest Decode Error : %v", err)
		return err
	}
	return err
}

type DispatchMsgResponse struct {
	TsHead
	ConnStatus int8
}

func (response *DispatchMsgResponse) Encode() (buffer []byte, err error) {
	buffer, err = response.TsHead.Encode()
	if err != nil {
		err = fmt.Errorf("DispatchMsgResponse Encode Error: %v", err)
		return buffer, err
	}
	buffer = append(buffer, byte(response.ConnStatus))
	return buffer, err
}

func (response *DispatchMsgResponse) Decode(buffer []byte) (err error) {
	if len(buffer) != 13 {
		err = errors.New("DispatchMSgResponse Decode Error : the []byte is shorter than 13")
		return err
	}
	err = response.TsHead.Decode(buffer)
	if err != nil {
		err = fmt.Errorf("DispatchMsgREsponse DEcode Error: %v", err)
		return err
	}
	response.ConnStatus = int8(buffer[len(buffer)-1])
	return err
}
