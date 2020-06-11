package main

import ( "fmt"
         "time"
         "os"
         "gortmpd/processor"
         "gortmpd/dispatcher"
         "gortmpd/file"
         "gortmpd/webm" 
         "gortmpd/web"
)

func main() {
    fmt.Println("goRTMPd starting...")

    if len(os.Args) < 2 {
        fmt.Printf("Usage: %s <input_file>\n", os.Args[0])
        return
    }

    channel := file.GetInputChannel(os.Args[1])
    dispatch_channel := make(chan webm.DispatchPacket, 10240)

    var context webm.Context
    context.InputChannel = channel
    context.DispatchChannel = dispatch_channel

    go processor.ProcessData(&context)   
    go dispatcher.DispatchPackets(&context) 
    // Setup output server
    go web.StartOutput(&context)

    for {
        time.Sleep(10000000000)
    }
}
