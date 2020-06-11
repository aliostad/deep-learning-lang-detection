package main

import (
	"fmt"
	//"math/rand"
	"time"
)

func main() {
	//create a miner
	Bob := NewMiner(ent_Miner_Bob)
	if Bob == nil {
		fmt.Println("Create miner error")
		return
	}

	//create his wife
	Elsa := NewMinersWife(ent_Elsa)
	if Elsa == nil {
		fmt.Println("Create minerwife error")
		return
	}

	//register them with the entity manager
	EntityMgr_GetMe().RegisterEntity(Bob)
	EntityMgr_GetMe().RegisterEntity(Elsa)

	fmt.Println(Clock_GetMe().GetCurrentTime())
	//run Bob and Elsa through a few Update calls
	for i := 0; i < 30; i++ {
		Bob.Update()
		Elsa.Update()

		//dispatch any delayed messages
		Dispatch_Instance().DispatchDelayedMessages()

		time.Sleep(time.Millisecond*800)
	}
}
