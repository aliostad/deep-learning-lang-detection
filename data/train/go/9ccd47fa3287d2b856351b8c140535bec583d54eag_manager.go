/*
 * Copyright 2014 Canonical Ltd.
 *
 * Authors:
 * Sergio Schvezov <sergio.schvezov@canonical.com>
 *
 * This file is part of libaccounts.
 */

package libaccounts

/*
#cgo pkg-config: libaccounts-glib
#include <stdlib.h>
#include <glib.h>
#include <libaccounts-glib/accounts-glib.h>
#include "common.h"
*/
import "C"
import "unsafe"

// Manager holds an instance of an AgManager.
type Manager struct {
	manager *C.AgManager
}

// NewManager creates a new AgManager instance.
func NewManager() *Manager {
	return &Manager{manager: C.ag_manager_new()}
}

// NewManagerForSeviceType creates a new AgManager instance with the
// specified serviceType.
func NewManagerForServiceType(serviceType string) *Manager {
	service_type_str := C.CString(serviceType)
	defer C.free_string(service_type_str)

	return &Manager{manager: C.ag_manager_new_for_service_type(
		C.to_gcharptr(service_type_str))}
}

// Delete removes the AgManager instance.
func (manager *Manager) Delete() {
	C.g_object_unref(C.gpointer(manager.manager))
}

// GetAccountService returns all the account services. If Manager was
// created for a specific serviceType, only services with that type will
// be returned.
func (manager *Manager) GetAccountServices() []*AccountService {
	services := C.ag_manager_get_account_services(manager.manager)
	defer C.g_list_free(services)
	return getAccountServicesFromList(services)
}

// GetEnabledAccountServices returns all the enabled account services.
// If Manager was created for a specific serviceType, only services with
// that type will be returned.
func (manager *Manager) GetEnabledAccountServices() []*AccountService {
	services := C.ag_manager_get_enabled_account_services(manager.manager)
	defer C.g_list_free(services)
	return getAccountServicesFromList(services)
}

func getAccountServicesFromList(services *C.GList) []*AccountService {
	length := C.g_list_length(services)
	result := make([]*AccountService, length)

	for n := C.guint(0); n < length; n++ {
		data := C.g_list_nth_data(services, n)
		pointer := unsafe.Pointer(data)
		service := &AccountService{acc: C.to_AgAccountService(pointer)}
		result[uint(n)] = service
	}
	return result
}
