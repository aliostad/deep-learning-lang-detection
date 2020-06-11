package python

/*
#cgo pkg-config: python3

#include <Python.h>

#include <stdio.h>
#include <stdlib.h>

#include "binding.h"

#include "../dispatcher.h"

static int Python_Init() {
  Py_Initialize();
  return Py_IsInitialized();
}

static int Python_LoadDispatcher() {
  PyObject *module_name = PyUnicode_FromString( dispatcher_module_name );
  dispatcher_module = PyImport_Import( module_name );

  if( dispatcher_module == NULL ) {
    printf("dispatcher_module error\n");
    PyErr_Print();
    return -1;
  }

  dispatcher_dict = PyModule_GetDict(dispatcher_module);

  if( dispatcher_dict == NULL ) {
    printf("dispatcher_dict error\n");
    PyErr_Print();
    return -1;
  }

  dispatch_json_string_hook = PyDict_GetItemString(dispatcher_dict, dispatch_json_string);
  dispatch_ujson_string_hook = PyDict_GetItemString(dispatcher_dict, dispatch_ujson_string);
  dispatch_native_object_hook = PyDict_GetItemString(dispatcher_dict, dispatch_native_object);
  dispatch_msgpack_object_hook = PyDict_GetItemString(dispatcher_dict, dispatch_msgpack_object);

  if( dispatch_json_string_hook == NULL || dispatch_ujson_string_hook == NULL || dispatch_native_object_hook == NULL || dispatch_msgpack_object_hook == NULL ) {
    PyErr_Print();
    return -1;
  }

  if( !PyCallable_Check(dispatch_json_string_hook) || !PyCallable_Check(dispatch_ujson_string_hook) || !PyCallable_Check(dispatch_native_object_hook) || !PyCallable_Check(dispatch_msgpack_object_hook) ) {
    return -1;
  }

  return 0;
}

static void Python_SetEnv(char* python_path) {
  // printf("Setting PYTHONPATH to: %s\n", python_path );
  setenv("PYTHONPATH", python_path, 1 );
}

static char* Python_DispatchJsonString(char* object) {
  PyObject *args = PyTuple_Pack( 1, PyUnicode_FromString(object) );
  PyObject *result = PyObject_CallObject( dispatch_json_string_hook, args );

  Py_DECREF(args);

  if( result == NULL ) {
    PyErr_Print();
    return NULL;
  } else {
    char *payload = PyUnicode_AsUTF8(result);
    Py_DECREF(result);
    return payload;
  }
}

static char* Python_DispatchUJsonString(char* object) {
  PyObject *args = PyTuple_Pack( 1, PyUnicode_FromString(object) );
  PyObject *result = PyObject_CallObject( dispatch_ujson_string_hook, args );

  Py_DECREF(args);

  if( result == NULL ) {
    PyErr_Print();
    return NULL;
  } else {
    char *payload = PyUnicode_AsUTF8(result);
    Py_DECREF(result);
    return payload;
  }
}

static NativeObject* Python_DispatchNativeObject(void* p) {
  NativeObject* obj = (NativeObject*)p;

  PyObject *n = Py_BuildValue("i", obj->timestamp);

  PyObject *args = PyTuple_Pack( 3, PyUnicode_FromString(obj->name), PyUnicode_FromString(obj->message), n );
  PyObject *result = PyObject_CallObject( dispatch_native_object_hook, args );

  Py_DECREF(n);
  Py_DECREF(args);

  if( result == NULL ) {
    PyErr_Print();
    return NULL;
  } else {
    PyObject* tupleName = PyTuple_GetItem(result, 0);
    PyObject* tupleMessage = PyTuple_GetItem(result, 1);
    PyObject* tupleTimestamp = PyTuple_GetItem(result, 2);

    char* name = PyUnicode_AsUTF8(tupleName);
    char* message = PyUnicode_AsUTF8(tupleMessage);
    char* timestamp_str = PyUnicode_AsUTF8(tupleTimestamp);

    int timestamp = atoi(timestamp_str);

    int len = sizeof(NativeObject) + strlen(name) + strlen(message) + sizeof(int) + 1;
    NativeObject* obj = (NativeObject*) malloc( len );

    obj->name = name;
    obj->message = message;
    obj->timestamp = timestamp;

    Py_DECREF(tupleName);
    Py_DECREF(tupleMessage);
    Py_DECREF(tupleTimestamp);

    // Py_DECREF(result);
    // printf("Py_REFCNT: %d\n", Py_REFCNT(result));

    return obj;
  }
  return NULL;
};

static char* Python_DispatchMsgPackObject(void *p) {
  char* serializedObject = (char*)p;

  // printf("Python_DispatchMsgPackObject, serializedObject: %s\n", serializedObject);

  PyObject *args = PyTuple_Pack( 1, PyBytes_FromString(serializedObject) );
  PyObject *result = PyObject_CallObject( dispatch_msgpack_object_hook, args );

  // PyObject* output = PyTuple_GetItem(result, 0);
  char* outputString = PyBytes_AsString(result);

  // printf("%s (C, output string)\n", outputString);

  // return serializedObject;
  return outputString;
};
*/
import "C"

import(
  "errors"
  // "fmt"
  "unsafe"
)


type NestedObject struct {
  NestedStringField string `msg;"string_field"`
  NestedIntField int `msg:"int_field"`
}

type Object struct {
  Name string `msg:"name"`
  Message string `msg:"message"`
  Timestamp int `msg:"ts"`
  NestedObject NestedObject `msg:"nested_object"`
}

func Init() error {
  var err error
  result := int(C.Python_Init())
  if result != 0 {
    err = errors.New("Couldn't initialize Python")
  }
  return err
}

func LoadDispatcher() error {
  var err error
  result := int(C.Python_LoadDispatcher())
  if result != 0 {
    err = errors.New("Couldn't load dispatcher")
  }
  return err
}

func SetPath(path string) {
  CPath := C.CString(path)
  C.Python_SetEnv((CPath))
}

func DispatchJsonString(object []byte) string {
  s := string(object)
  CObject := C.CString(s)
  var output *C.char
  output = C.Python_DispatchJsonString(CObject)
  C.free(unsafe.Pointer(CObject))
  var outputStr string
  outputStr = C.GoString(output)
  return outputStr
}

func DispatchUJsonString(object []byte) string {
  s := string(object)
  CObject := C.CString(s)

  var output *C.char
  output = C.Python_DispatchUJsonString(CObject)

  C.free(unsafe.Pointer(CObject))

  var outputStr string
  outputStr = C.GoString(output)

  return outputStr
}

func DispatchNativeObject(object unsafe.Pointer) Object {
  var Cobj *C.struct_NativeObject
  Cobj = C.Python_DispatchNativeObject(object)

  obj := Object{
    Name: C.GoString(Cobj.name),
    Message: C.GoString(Cobj.message),
    Timestamp: int(Cobj.timestamp),
  }

  C.free(unsafe.Pointer(Cobj))

  return obj
}

func DispatchMsgPackObject(object unsafe.Pointer) []byte {
  var output *C.char
  output = C.Python_DispatchMsgPackObject(object)

  var outputStr string
  outputStr = C.GoString(output)

  return []byte(outputStr)
}
func DispatchBytes(object []byte) {
}
