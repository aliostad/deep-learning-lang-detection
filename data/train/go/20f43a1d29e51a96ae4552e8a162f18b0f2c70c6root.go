package cmd

import "github.com/spf13/cobra"

func NewRootCommand() *cobra.Command {

	var loadBalancerName string

	cmd := &cobra.Command{
		Use:   "k8s-ingress-elb-check",
		Short: "sidecar for kubernetes ingress pods",
	}

	cmd.PersistentFlags().StringVarP(&loadBalancerName, "load-balancer", "l", "",
		"name of the load balancer")

	cmd.AddCommand(NewVersionCommand())
	cmd.AddCommand(NewCheckCommand(&loadBalancerName))
	cmd.AddCommand(NewRegisterCommand(&loadBalancerName))
	cmd.AddCommand(NewDeregisterCommand(&loadBalancerName))

	return cmd
}
