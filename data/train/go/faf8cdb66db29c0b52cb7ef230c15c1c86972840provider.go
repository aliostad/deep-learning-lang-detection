package provider

import (
        "fmt"
        "os"
        "cisco/micro/config"
)


type CommandFunction func([]config.Config, []string) int

type Provider struct {
        dispatchTable map[string]CommandFunction
}

func NewProvider(dispatchTable map[string]CommandFunction) *Provider {
        return &Provider{
                dispatchTable: dispatchTable}
}

var providers = map[string]*Provider{
        "aws": NewProvider(getAwsDispatchTable()),
        "gce": NewProvider(getGceDispatchTable()),

}

func Dispatch(cfgs []config.Config, args[]string) int {
        if provider, ok := providers[cfgs[0].Config.Provider]; ok {
                fmt.Printf("dispatching to provider %s with args %v", cfgs[0].Config.Provider, args)
                return provider.dispatch(cfgs, args)
        } else {
                fmt.Fprintf(os.Stderr, "Unsupported provider: \"%s\" found in \"%s\"\n", cfgs[0].Config.Provider, cfgs[0].Path)
                return 1
        }

}

func (provider *Provider) dispatch(cfgs []config.Config, args []string) int {

        dispatchTable := provider.dispatchTable

        if (len(args) == 0){
                fmt.Fprintf(os.Stderr, "No command specified. See help for details.\n")
                return 1
        }

        id := args[0]

        if commandFn, ok := dispatchTable[id]; ok {
                return commandFn(cfgs, args[1:])
        }

        fmt.Fprintf(os.Stderr, "Unknown command.\n")
        return 1
}



