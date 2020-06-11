package applyd

import ()

type Runtime struct {
    Packages    *PackageManager
    Firewall    *FirewallManager
    IpNeighbors *IpNeighborProxyManager
    Vips        *VipsManager
    Tunnels     *TunnelsManager
    Routes4     *RoutesManager
    Routes6     *RoutesManager
}

func NewRuntime() (*Runtime, error) {
    runtime := &Runtime{}

    runtime.Packages = NewPackageManager(runtime)
    runtime.Firewall = NewFirewallManager(runtime)
    runtime.IpNeighbors = NewIpNeighborProxyManager(runtime)
    runtime.Vips = NewVipsManager(runtime)
    runtime.Tunnels = NewTunnelsManager(runtime)

    runtime.Routes4 = NewRoutesManager(runtime, false)
    runtime.Routes6 = NewRoutesManager(runtime, true)

    return runtime, nil
}
