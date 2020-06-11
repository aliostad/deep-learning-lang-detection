package cef

/*
#include <stdlib.h>
#include "string.h"
#include "include/capi/cef_client_capi.h"
#include "include/capi/cef_browser_capi.h"
#include "include/capi/cef_v8_capi.h"
#include "cef_app.h"
#include "cef_client.h"
#include "cef_helpers.h"

extern int cef_process_message_is_valid(struct _cef_process_message_t* self);

extern int cef_process_message_is_read_only(struct _cef_process_message_t* self);

extern struct _cef_process_message_t* cef_process_message_copy(
      struct _cef_process_message_t* self);

extern cef_string_userfree_t cef_process_message_get_name(
      struct _cef_process_message_t* self);

extern struct _cef_list_value_t* cef_process_message_get_argument_list(
      struct _cef_process_message_t* self);

*/
import "C"

import (
//"fmt"
)

// PID_BROWSER, PID_RENDERER
type CefProcessMessage struct {
	CStruct *C.struct__cef_process_message_t
}

func (m *CefProcessMessage) IsValid() bool {
	return (C.cef_process_message_is_valid(m.CStruct) == 1)
}

func (m *CefProcessMessage) IsReadOnly() bool {
	return (C.cef_process_message_is_read_only(m.CStruct) == 1)
}

func (m *CefProcessMessage) Copy() (c *CefProcessMessage) {
	c.CStruct = C.cef_process_message_copy(m.CStruct)
	return
}

func (m *CefProcessMessage) GetName() string {
	return CEFToGoString(C.cef_process_message_get_name(m.CStruct))
}

func (m *CefProcessMessage) GetArgumentList() (listValue *CefListValue) {
	listValue = &CefListValue{}
	v := C.cef_process_message_get_argument_list(m.CStruct)
	listValue.CStruct = v
	return
}

func CefProcessMessageCreate(name string) (message *CefProcessMessage) {
	message = &CefProcessMessage{}
	s := CEFString(name)
	message.CStruct = C.cef_process_message_create(s)
	return
}

func NewCefProcessMessage(m *C.struct__cef_process_message_t) (message *CefProcessMessage) {
	message = &CefProcessMessage{CStruct: m}
	return
}
