// Copyright 2015 Jake Dahn
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package core

import (
	"encoding/json"

	"gopkg.in/yaml.v2"
)

func NewDispatchRequest(requestJson []byte) (*DispatchRequest, error) {
	dispatchRequest := &DispatchRequest{}
	err := json.Unmarshal(requestJson, dispatchRequest)
	if err != nil {
		return nil, err
	}
	return dispatchRequest, nil
}

func ParseDispatchFile(dispatchFileContent []byte) (*DispatchFile, error) {
	df := &DispatchFile{}
	err := yaml.Unmarshal(dispatchFileContent, df)
	if err != nil {
		return nil, err
	}
	return df, nil
}

func (d *DispatchRequest) IsValid(dispatchFile *DispatchFile) bool {
	dfArgs := dispatchFile.Arguments
	reqArgs := d.Arguments[0]

	for _, dfarg := range dfArgs {
		if dfarg.Presence == "required" {
			if reqArgs[dfarg.Key] == "" {
				return false
			}
		}
	}
	return true
}
