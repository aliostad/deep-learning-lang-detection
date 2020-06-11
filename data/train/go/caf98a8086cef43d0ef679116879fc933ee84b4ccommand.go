/*
 Reeve - Command RPC

 Copyright 2015 Evan Borgstrom

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

package command

import (
	"fmt"
	"net"
	"net/rpc"

	log "github.com/Sirupsen/logrus"

	"github.com/borgstrom/reeve/modules"

	// All of the modules in the command RPC are imported here
	_ "github.com/borgstrom/reeve/modules/file"
	_ "github.com/borgstrom/reeve/modules/test"
)

func ServeConn(conn net.Conn, c *CommandRPC) {
	rpc.RegisterName("Command", c)
	rpc.ServeConn(conn)
}

type DispatchRequest struct {
	Module   string
	Function string
	Args     modules.Args
}

type DispatchReply struct {
	Args modules.Args
}

type CommandRPC struct {
}

func NewRPC() *CommandRPC {
	c := new(CommandRPC)
	return c
}

// CommandClient is our custom rpc client for Command connections
type CommandClient struct {
	*rpc.Client
}

// NewCommandClient takes a net connection and returns a new CommandClient
func NewClient(conn net.Conn) *CommandClient {
	return &CommandClient{rpc.NewClient(conn)}
}

// Dispatch is a stub to the Command.Dispatch RPC method
func (c *CommandClient) Dispatch(request *DispatchRequest, reply modules.Args) error {
	reply = make(modules.Args)

	err := c.Call("Command.Dispatch", request, reply)
	if err != nil {
		return err
	}

	return nil
}

// Dispatch dispatches a command to a module
func (c *CommandRPC) Dispatch(request *DispatchRequest, reply *DispatchReply) error {
	var err error

	log.WithFields(log.Fields{
		"module":   request.Module,
		"function": request.Function,
		"args":     request.Args,
	}).Debug("Dispatching")

	fun := modules.FindFunction(request.Module, request.Function)
	if fun == nil {
		return fmt.Errorf("Invalid module/function: %s.%s", request.Module, request.Function)
	}

	reply.Args = make(modules.Args)
	err = fun(request.Args, reply.Args)
	if err != nil {
		return err
	}

	return nil
}
