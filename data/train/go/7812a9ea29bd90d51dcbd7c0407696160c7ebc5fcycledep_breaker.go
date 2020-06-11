package registry

import (
  "github.com/twitchyliquid64/CNC/plugin/exec"
)


var dispatchMethod func(string, interface{})bool = nil
var deregisterPluginMethod func (plugin *exec.Plugin) = nil

func SetupDispatchMethod(in func(string, interface{})bool) {
  dispatchMethod = in
}

func SetupDeregisterMethod(in func (plugin *exec.Plugin)){
  deregisterPluginMethod = in
}

func DeregisterPluginMethod(plugin *exec.Plugin){
  if deregisterPluginMethod == nil{
    panic("deregisterPluginMethod == nil")
  }
  deregisterPluginMethod(plugin)
}

func DispatchEvent(typ string, data interface{})bool{
  if dispatchMethod != nil {
    return dispatchMethod(typ, data)
  }
  return false
}
