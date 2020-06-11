func print_stack(start int, end int){
        var pc uintptr
        for i := end; i >= start; i-- {
                pc, _ ,_ ,_ = runtime.Caller(i)
                log.Infof(runtime.FuncForPC(pc).Name())
        }
}

func (e *L2Fwd) dispatchFlow(f interface{},  args... interface{}) {
        var     msgs []*core.Message

        msg := new(core.Message)
        msg.Type = core.MSG_OF_NXT_FLOW_MOD
        flowfunc := reflect.ValueOf(f)
        in := make([]reflect.Value, len(args))
        for k, param := range args{
            in[k] = reflect.ValueOf(param)
        }

        //print debug function stack from 2 to 4
        print_stack(2, 4)
        log.Infof("dispatchFlow:%v, args:%v",
        runtime.FuncForPC(flowfunc.Pointer()).Name(), args)

        result := flowfunc.Call(in)
        for _, r := range result {
                msg.Body = r.Interface().(*ofp13.FlowMod)
        }

        msgs = append(msgs, msg)
        e.L2FlowSend(msgs)

}

e.dispatchFlow(AddIngressVRDPReturnFlow)
e.dispatchFlow(DelDhcpReplyFlow, metadata)
e.dispatchFlow(DelRemoteComputeTunlOutPutFlow, comTunlOfport, metadata)

e.dispatchFlow(AddMetadataReturnFlow, pktIn)

