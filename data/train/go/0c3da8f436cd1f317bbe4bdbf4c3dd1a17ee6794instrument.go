package sgapi

import (
	//	"github.com/ws6/raptor/sgconn/sgclient"
	"encoding/json"
	"fmt"
	"github.com/ws6/raptor/sgconn/sgmod"
	"io/ioutil"
)

var (
	NOTFOUND_INSTRUMENT = "not found instrument"
)

func (self *SgApi) GetInstrumentByName(instrumentName string) (*sgmod.InstrumentType, error) {

	apiPath := fmt.Sprintf(`/api/blueprints/instrumenttype?instrument_name=%s`, instrumentName)
	//	fmt.Println("get fc:", apiPath)

	resp, err := self.SageClient.Get(apiPath)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != 200 {
		return nil, fmt.Errorf(NOTFOUND_INSTRUMENT)
	}

	fcRes, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		return nil, err
	}

	var found []sgmod.InstrumentType
	err = Unmarshal(fcRes, &found)
	if err != nil {
		return nil, err
	}
	if len(found) == 0 {
		return nil, nil
	}
	if len(found) > 1 {
		return nil, fmt.Errorf("multiple instrument  found with name %s", instrumentName) // unlikely at mysql schema
	}
	return &found[0], nil
}

func (self *SgApi) CreateInstrument(instrument *sgmod.InstrumentType) (*sgmod.InstrumentType, error) {
	apiPath := fmt.Sprintf(`/api/blueprints/instrumenttype`)
	b, err := json.Marshal(instrument)
	if err != nil {
		return nil, err
	}
	resp, err := self.SageClient.Post(apiPath, string(b))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	var ret sgmod.InstrumentType
	err = ResToStruct(resp, &ret)
	if err != nil {
		return nil, err
	}
	return &ret, nil
}

func (self *SgApi) UpdateInstrumentById(instrument *sgmod.InstrumentType) (*sgmod.InstrumentType, error) {

	if instrument.Id == 0 {
		return nil, fmt.Errorf("param instrument not have Id set")
	}
	apiPath := fmt.Sprintf(`/api/blueprints/instrumenttype/%d?populate=false`, instrument.Id)
	b, err := json.Marshal(instrument)
	if err != nil {
		return nil, err
	}

	resp, err := self.SageClient.Put(apiPath, string(b))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if err := ResToStruct(resp, &instrument); err != nil {
		return nil, err
	}
	return instrument, nil
}

//UpdateOrCreateInstrument write update to sage server
func (self *SgApi) UpdateOrCreateInstrument(instrument *sgmod.InstrumentType) (*sgmod.InstrumentType, error) {
	foundInstrument, err := self.GetInstrumentByName(instrument.InstrumentName)
	//not found
	if err == nil && foundInstrument == nil {
		return self.CreateInstrument(instrument)
	}
	if foundInstrument != nil {
		instrument.Id = foundInstrument.Id
		return self.UpdateInstrumentById(instrument)
	}
	return nil, err
}
