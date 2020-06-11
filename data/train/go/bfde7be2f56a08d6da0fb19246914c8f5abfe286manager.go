/* Copyright 2014 Ooyala, Inc. All rights reserved.
 *
 * This file is licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is
 * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations under the License.
 */

package manager

import (
	"atlantis/manager/datamodel"
	"atlantis/manager/dns"
	"atlantis/manager/helper"
	. "atlantis/manager/rpc/client"
	. "atlantis/manager/rpc/types"
	"errors"
)

var Port string

func Init(port string) {
	Port = port
}

func Register(region, value, registryCName, managerCName string) (*datamodel.ZkManager, error) {
	if tmpManager, err := datamodel.GetManager(region, value); err == nil {
		return tmpManager, errors.New("Already registered.")
	}

	// NOTE[jigish]: health check removed because we can't actually do it security-group wise.

	// set up datamodel
	zkManager := datamodel.Manager(region, value)
	err := zkManager.Save()
	if err != nil {
		return zkManager, err
	}

	// pass through specified cnames
	if managerCName != "" {
		zkManager.ManagerCName = managerCName
	}
	if registryCName != "" {
		zkManager.RegistryCName = registryCName
	}
	err = zkManager.Save()
	if err != nil {
		return zkManager, err
	}

	if dns.Provider == nil || (zkManager.ManagerCName != "" && zkManager.RegistryCName != "") {
		return zkManager, nil
	}

	suffix, err := dns.Provider.Suffix(region)
	if err != nil {
		return nil, err
	}

	// set up unspecified cnames
	// first delete all entries we may already have for this Value in DNS
	err = dns.DeleteRecordsForValue(region, value)
	if err != nil {
		return zkManager, err
	}
	// choose cnames
	managers, err := datamodel.ListManagersInRegion(region)
	if err != nil {
		return zkManager, err
	}
	managerMap := map[string]bool{}
	registryMap := map[string]bool{}
	for _, manager := range managers {
		tmpManager, err := datamodel.GetManager(region, manager)
		if err != nil {
			return zkManager, err
		}
		managerMap[tmpManager.ManagerCName] = true
		registryMap[tmpManager.RegistryCName] = true
	}

	cnames := []dns.Record{}
	if zkManager.ManagerCName == "" {
		managerNum := 1
		zkManager.ManagerCName = helper.GetManagerCName(managerNum, suffix)
		for ; managerMap[zkManager.ManagerCName]; managerNum++ {
			zkManager.ManagerCName = helper.GetManagerCName(managerNum, suffix)
		}
		// managerX.<region>.<suffix>
		cname := dns.NewRecord(zkManager.ManagerCName, zkManager.Host, 0)
		zkManager.ManagerRecordID = cname.ID()
		cnames = append(cnames, cname)
	}
	if zkManager.RegistryCName == "" {
		registryNum := 1
		zkManager.RegistryCName = helper.GetRegistryCName(registryNum, suffix)
		for ; registryMap[zkManager.RegistryCName]; registryNum++ {
			zkManager.RegistryCName = helper.GetRegistryCName(registryNum, suffix)
		}
		// registryX.<region>.<suffix>
		cname := dns.NewRecord(zkManager.RegistryCName, zkManager.Host, 0)
		zkManager.RegistryRecordID = cname.ID()
		cnames = append(cnames, cname)
	}

	if len(cnames) == 0 {
		return zkManager, nil
	}
	err = dns.Provider.CreateRecords(region, "CREATE_MANAGER "+zkManager.Host+" in "+region, cnames)
	if err != nil {
		return zkManager, err
	}
	return zkManager, zkManager.Save()
}

func Unregister(region, value string) error {
	zkManager, err := datamodel.GetManager(region, value)
	if err != nil {
		return err
	}
	if dns.Provider == nil {
		// if we have no dns provider then just save here
		return zkManager.Delete()
	}
	records := []string{}
	if zkManager.ManagerRecordID != "" {
		records = append(records, zkManager.ManagerRecordID)
	}
	if zkManager.RegistryRecordID != "" {
		records = append(records, zkManager.RegistryRecordID)
	}
	if len(records) > 0 {
		err, errChan := dns.Provider.DeleteRecords(region, "DELETE_MANAGER "+value+" in "+region, records...)
		if err != nil {
			return err
		}
		err = <-errChan // wait for it to propagate
		if err != nil {
			return err
		}
	}
	return zkManager.Delete()
}

func HealthCheck(host string) (*ManagerHealthCheckReply, error) {
	args := ManagerHealthCheckArg{}
	var reply ManagerHealthCheckReply
	return &reply, NewManagerRPCClient(host+":"+Port).Call("HealthCheck", args, &reply)
}
