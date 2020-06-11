package server

import (
	"encoding/csv"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"regexp"
	"time"
)

var True = true
var False = false

const NumProcesses = 4
const NumMessages = 250

type Message struct {
	Message        string
	From           int
	To             int
	ProcessEpoch   int
	Frequency      int
	FrequencyEpoch int
	ElectionId     int
	Lag            time.Duration
	Packetloss     int
}

type Force struct {
	// All nil values represent properties that should be left alone
	Election   *bool
	Lag        *time.Duration
	Packetloss *int // See `NetworkState.Packetloss`
}

type Process struct {
	Id             int
	CurrentEpoch   int
	Frequency      int
	FrequencyEpoch int
	LastVoteEpoch  int
	NextElection   time.Time
	Election       *Election
	Inbox          chan *Message
	Outbox         chan *Message
	God            chan *Force
	Ticker         *time.Ticker
	ElectionForced bool
	NetworkState   *NetworkState
}

type Election struct {
	Id             int
	NewFrequency   int
	FrequencyEpoch int
	NumVotes       int
	NumProcesses   int
}

type NetworkState struct {
	Lag []time.Duration

	// int between 0 and 100 representing a percentage. 0 drops no
	// packets, 100 drops all packets
	Packetloss []int
}

func NewHealthyNetwork(numProcesses int) *NetworkState {
	return &NetworkState{
		Lag:        make([]time.Duration, numProcesses),
		Packetloss: make([]int, numProcesses),
	}
}

func (network *NetworkState) LagTo(peerId int) time.Duration {
	return network.Lag[peerId]
}

func (network *NetworkState) PacketlossTo(peerId int) int {
	return network.Packetloss[peerId]
}

func toCsv(processes []*Process) {
	file, err := os.Create("lag.csv")
	if err != nil {
		panic(err)
	}
	wr := csv.NewWriter(file)
	var header []string
	for i := range processes {
		header = append(header, fmt.Sprintf("process_%d", i+1))
	}
	wr.Write(header)
	for i := 0; i < len(processes); i++ {
		var durations []string
		for _, duration := range processes[i].NetworkState.Lag {
			durations = append(durations, fmt.Sprintf("%f", duration.Seconds()))
		}
		wr.Write(durations)
	}
	wr.Flush()
}

func NewProcess(id int, mailbox chan *Message) *Process {
	var nextElectionSeed time.Duration
	if NumProcesses == 4 {
		// Demo code
		if id != 3 {
			nextElectionSeed = 10 * time.Second
		}
	} else {
		if id > 0 {
			nextElectionSeed = 10 * time.Second
		}
	}

	return &Process{
		Id:             id,
		CurrentEpoch:   0,
		FrequencyEpoch: 0,
		Frequency:      -1,
		LastVoteEpoch:  0,
		NextElection:   time.Now().Add(nextElectionSeed),
		Inbox:          make(chan *Message, 10),
		Outbox:         mailbox,
		God:            make(chan *Force, 1),
		Ticker:         time.NewTicker(5 * time.Second),
		NetworkState:   NewHealthyNetwork(NumProcesses),
	}
}

func (process *Process) Spawn() {
	go process.Run()
}

func (process *Process) Run() {
	for {
		wantsNewElection := process.Frequency == -1 ||
			process.ElectionForced == true

		if wantsNewElection &&
			time.Now().After(process.NextElection) {

			process.ElectionForced = false
			// Random wait between attempts for an election.
			secondsToWait := time.Duration(10+rand.Int31n(10)) * time.Second
			process.NextElection = time.Now().Add(secondsToWait)
			process.ElectMe()
		}

		process.Iterate()
	}
}

func (process *Process) Iterate() {
	select {
	case message := <-process.Inbox:
		process.HandleMessage(message)
	case _ = <-process.Ticker.C:
		// Send an update to a random neighbor
		process.SendUpdate(int(rand.Int31n(NumProcesses)))
	case force := <-process.God:
		fmt.Printf("Process #%d Force: %#v\n", process.Id, force)
		if force.Election != nil {
			process.ElectionForced = *force.Election
		}
	}
}

func (process *Process) HandleMessage(message *Message) {
	if process.CurrentEpoch < message.ProcessEpoch {
		// Always update the current epoch
		process.CurrentEpoch = message.ProcessEpoch
	}

	switch message.Message {
	case "heartbeat":
		//fmt.Printf("Received heartbeat. Process: %v Frequency: %v Epoch: %v\n",
		//process.Id, process.Frequency, process.FrequencyEpoch)
		if process.FrequencyEpoch >= message.FrequencyEpoch {
			return
		}

		process.Frequency = message.Frequency
		process.FrequencyEpoch = message.FrequencyEpoch
		fmt.Printf("Updating from heartbeat. Process: %v New Frequency: %v New Epoch: %v\n",
			process.Id, process.Frequency, process.FrequencyEpoch)
	case "elect_me":
		history := elections[message.ElectionId]

		if process.CurrentEpoch > message.ProcessEpoch ||
			process.LastVoteEpoch >= process.CurrentEpoch ||
			process.FrequencyEpoch > message.FrequencyEpoch {

			history.ReceivedUnsuccessful(message, process)
			// Do not vote if: I have a more recent view of time than
			// the message, or I already voted for this epoch, or my
			// last observed frequency change is more recent than the
			// requesting machine.
			fmt.Printf("Not voting. Process: %v Epoch: %v LastVoteEpoch: %v FrequencyEpoch: %v Message: %#v\n",
				process.Id, process.CurrentEpoch, process.LastVoteEpoch, process.FrequencyEpoch, message)
			return
		}

		history.ReceivedSuccessful(message, process)
		fmt.Printf("You have my vote. Process %v Frequency: %v Epoch: %v\n",
			process.Id, message.Frequency, message.ProcessEpoch)
		process.LastVoteEpoch = process.CurrentEpoch

		response := process.NewMessage(message.From)
		response.Message = "you_have_my_vote"
		response.ProcessEpoch = process.CurrentEpoch
		response.ElectionId = message.ElectionId

		history.Sent(response)
		process.Outbox <- response
	case "you_have_my_vote":
		history := elections[message.ElectionId]
		if message.ProcessEpoch < process.CurrentEpoch {
			history.ReceivedUnsuccessful(message, process)
			return
		}

		history.ReceivedSuccessful(message, process)
		fmt.Printf("Received vote. Process: %v Frequency: %v Epoch: %v\n",
			process.Id, process.Election.NewFrequency, process.Election.FrequencyEpoch)
		process.Election.NumVotes++
		if process.Election.NumVotes*2 > process.Election.NumProcesses {
			history.Successful = true
			fmt.Println("New frequency elected. Frequency:", process.Election.NewFrequency)
			process.Frequency = process.Election.NewFrequency
			process.FrequencyEpoch = process.Election.FrequencyEpoch
			process.PropagateFrequency()
		}
	default:
		panic(fmt.Sprintf("Unknown message: %#v", message))
	}
}

func (process *Process) SendUpdate(toProcessId int) {
	message := process.NewMessage(toProcessId)
	message.ProcessEpoch = process.CurrentEpoch
	message.Frequency = process.Frequency
	message.FrequencyEpoch = process.FrequencyEpoch
	message.Message = "heartbeat"

	process.Outbox <- message
}

func (process *Process) PropagateFrequency() {
	for peerId := 0; peerId < NumProcesses; peerId++ {
		if process.Id == peerId {
			continue
		}

		process.SendUpdate(peerId)
	}
}

func (process *Process) ElectMe() {
	process.CurrentEpoch++
	process.LastVoteEpoch = process.CurrentEpoch
	process.Election = &Election{
		NewFrequency:   int(rand.Int31n(100)),
		FrequencyEpoch: process.CurrentEpoch,
		NumVotes:       1,
		NumProcesses:   NumProcesses,
	}

	fmt.Printf("Sending elect_me. Process: %v Election: %#v\n",
		process.Id, process.Election)

	electionHistory := NewElection(process.Id, process.Election.NewFrequency)
	process.Election.Id = electionHistory.Id
	for peerId := 0; peerId < NumProcesses; peerId++ {
		if process.Id == peerId {
			continue
		}

		message := process.NewMessage(peerId)
		message.Message = "elect_me"
		message.ProcessEpoch = process.CurrentEpoch
		message.Frequency = process.Election.NewFrequency
		message.FrequencyEpoch = process.FrequencyEpoch
		message.ElectionId = process.Election.Id
		electionHistory.Sent(message)

		process.Outbox <- message
	}
}

func (process *Process) NewMessage(recipientId int) *Message {
	return &Message{
		ProcessEpoch: process.CurrentEpoch,
		From:         process.Id,
		To:           recipientId,
		Lag:          process.NetworkState.LagTo(recipientId),
		Packetloss:   process.NetworkState.PacketlossTo(recipientId),
	}
}

var truncateRegex = regexp.MustCompile("(\\.\\d)(\\d*)")

func (process *Process) UntilNextElection() string {
	duration := process.NextElection.Sub(time.Now())
	if int64(duration) < 0 {
		return "0s"
	}

	raw := fmt.Sprintf("%s", duration)
	return truncateRegex.ReplaceAllString(raw, "$1")
}

func (process *Process) ClassColor(currentFrequency int) string {
	if process.Frequency == currentFrequency {
		return "green"
	}

	return "red"
}

func Mailbox(processes []*Process, mailbox chan *Message) {
	for messageNum := 0; messageNum < NumMessages; messageNum++ {
		message := <-mailbox
		if rand.Intn(100) < message.Packetloss {
			fmt.Printf("Dropped message: %#v\n", message)
			continue
		}

		if message.Lag > time.Duration(0) {
			go func(lag time.Duration) {
				<-time.After(lag)
				processes[message.To].Inbox <- message
			}(message.Lag)
			continue
		}

		if message.Message != "heartbeat" {
			fmt.Printf("Mailbox: %#v\n", message)
		}

		processes[message.To].Inbox <- message
	}
}

func Play() {
	mailbox := make(chan *Message, 10)
	processes := make([]*Process, 0, NumProcesses)
	for processNum := 0; processNum < NumProcesses; processNum++ {
		processes = append(processes, NewProcess(processNum, mailbox))
	}

	for _, process := range processes {
		process.Spawn()
	}

	go Mailbox(processes, mailbox)
	go toCsv(processes)
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		RootHandler(w, r, processes)
	})
	http.HandleFunc("/election", func(w http.ResponseWriter, r *http.Request) {
		ElectionHandler(w, r, processes)
	})
	http.HandleFunc("/lag", func(w http.ResponseWriter, r *http.Request) {
		LagHandler(w, r, processes)
	})
	http.HandleFunc("/img/lag.png", func(w http.ResponseWriter, r *http.Request) {
		path, _ := os.Getwd()
		lagPath := path + "/img/lag.png"
		http.ServeFile(w, r, lagPath)
	})
	http.HandleFunc("/network_split", func(writer http.ResponseWriter, request *http.Request) {
		NetworkSplitHandler(writer, request, processes)
	})
	http.HandleFunc("/heal", func(writer http.ResponseWriter, request *http.Request) {
		HealNetworkHandler(writer, request, processes)
	})
	http.HandleFunc("/history", DisplayElectionHistory)
	http.ListenAndServe(":8080", nil)
}
