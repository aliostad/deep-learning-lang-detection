package api

import (
	"github.com/kumanote/go-oanda-api/data"
	"strconv"
)

func (o *Oanda) GetPositions(accountId int64) (*data.GetPositions, error) {
	var ret data.GetPositions
	endpoint := "/v1/accounts/" + strconv.FormatInt(accountId, 10) + "/positions"
	if err := o.apiJsonUnmarshal(endpoint, "GET", nil, nil, &ret); err != nil {
		return nil, err
	}
	return &ret, nil
}

func (o *Oanda) GetPosition(accountId int64, instrument string) (*data.Position, error) {
	var ret data.Position
	endpoint := "/v1/accounts/" + strconv.FormatInt(accountId, 10) + "/positions/" + instrument
	if err := o.apiJsonUnmarshal(endpoint, "GET", nil, nil, &ret); err != nil {
		return nil, err
	}
	return &ret, nil
}

func (o *Oanda) ClosePosition(accountId int64, instrument string) (*data.ClosePositionResult, error) {
	var ret data.ClosePositionResult
	endpoint := "/v1/accounts/" + strconv.FormatInt(accountId, 10) + "/positions/" + instrument
	if err := o.apiJsonUnmarshal(endpoint, "DELETE", nil, nil, &ret); err != nil {
		return nil, err
	}
	return &ret, nil
}
