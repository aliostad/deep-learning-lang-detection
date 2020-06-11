// Copyright © 2016 Erno Rigo <erno@rigo.info>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	log "github.com/Sirupsen/logrus"
	"os"
	"os/signal"
	"syscall"
	"sync"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"time"
	"github.com/mcree/k51/backend"
)

type DispatcherFunc func(*Dispatcher) error

type Dispatcher struct {
	RunGroup     sync.WaitGroup
	CleanupGroup sync.WaitGroup
	Err error
}

var dispatcher Dispatcher

// dispatchCmd represents the dispatch command
var dispatchCmd = &cobra.Command{
	Use:   "dispatch",
	Short: "Dispatch services based on the config file.",
	Long: ``,
	Run: func(cmd *cobra.Command, args []string) {
		log := log.WithField("prefix", "dispatch")
		log.Info("starting")
		defer log.Info("exiting")
		dispatcher.RunGroup.Add(1)
		srvs := viper.GetStringSlice("dispatch.services")
		log.Info("services: ", srvs)
		for s := range srvs {
			switch srvs[s] {
			case "smstools":
				spawn(srvs[s], DispatcherFunc(smstools))
			}
		}
		time.Sleep(time.Second)
		log.Info("running - Ctrl-C to exit")
		dispatcher.RunGroup.Wait()
		log.Info("stopping - waiting for cleanup")
		dispatcher.CleanupGroup.Wait()
		backend.MQCleanup()
		log.Info("cleanup done - exiting")
	},
}

func spawn(service string, fn DispatcherFunc) {
	log := log.WithField("prefix", "dispatch").WithField("service", service)
	go func() {
		log.Info("spawning")
		err := fn(&dispatcher)
		if err != nil {
			log.Error("spawn error: ",err)
			dispatcher.Err = err
			dispatcher.RunGroup.Done()
			return
		}
		log.Info("stopping")
		dispatcher.CleanupGroup.Done()
	}()
	dispatcher.CleanupGroup.Add(1)
}

func init() {
	log := log.WithField("prefix", "dispatch")
	RootCmd.AddCommand(dispatchCmd)

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	signal.Notify(c, syscall.SIGTERM)
	go func(){
		<-c
		log.Warn("signal caught - dispatching stop request")
		dispatcher.RunGroup.Done()
	}()

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// dispatchCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// dispatchCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")

}
