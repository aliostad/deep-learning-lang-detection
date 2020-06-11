package builtin


import (
  "github.com/twitchyliquid64/CNC/plugin/exec"
  "github.com/twitchyliquid64/CNC/logging"
  "github.com/twitchyliquid64/CNC/util"
  "github.com/robertkrimen/otto"
)

var TestEndpointGood_called bool = false

// Called when JS code executes testendpoint_good()
//
//
func function_onTestEndpointGood(plugin *exec.Plugin, call otto.FunctionCall)otto.Value{
  TestEndpointGood_called = true
  logging.Info("plugin-test", "testendpoint_good() called")
  return otto.Value{}
}




type DispatchTestHook struct {
  P *exec.Plugin
  Callback *otto.Value
}

func (h *DispatchTestHook)Destroy(){
  logging.Info("DispatchTestHook", "Destroy() called")
}
func (h *DispatchTestHook)Name()string{
  return "dispatchtest"
}
func (h *DispatchTestHook)Dispatch(data interface{}){
  h.P.PendingInvocations <- &exec.JSInvocation{Callback: h.Callback}
}

//Called to create a hook which can be run from tests
//
//
func function_onTestDispatchTriggered(plugin *exec.Plugin, call otto.FunctionCall)otto.Value{
  callback := util.GetFunc(call.Argument(0), plugin.VM)
  hook := DispatchTestHook{P: plugin, Callback: &callback}
  plugin.RegisterHook(&hook)
  return otto.Value{}
}
