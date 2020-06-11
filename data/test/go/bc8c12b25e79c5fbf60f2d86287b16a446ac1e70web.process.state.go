package web_models

import (
	"errors"
	"fmt"
	"github.com/gorilla/websocket"
	"github.com/tuomasvapaavuori/site_installer/app/models"
)

type WebProcess struct {
	ChannelOut      chan *ConnStatusMessage
	ProcessMessage  chan string
	StateChannel    chan models.SubProcessState
	Connection      *websocket.Conn
	State           int
	NumberProcessed int
	FailedProcesses int
	TotalSub        int
	SubProcesses    map[string]*models.SubProcess
	ProcessName     string
}

func NewWebProcess(processName string, channel chan *ConnStatusMessage, conn *websocket.Conn) *WebProcess {
	return &WebProcess{
		ChannelOut:      channel,
		Connection:      conn,
		State:           models.ProcessNotStarted,
		ProcessName:     processName,
		FailedProcesses: 0,
		TotalSub:        0,
		ProcessMessage:  make(chan string),
		SubProcesses:    make(map[string]*models.SubProcess),
		StateChannel:    make(chan models.SubProcessState),
	}
}

func (p *WebProcess) Start() {
	p.State = models.ProcessStarted

	// Send process started message.
	p.ChannelOut <- NewConnStatusMessage(
		p.Connection,
		fmt.Sprintf("Process: %v started.", p.ProcessName),
		ResponseProcessMessage,
	)

	go func() {
		for {
			if p.State == models.ProcessFinished {
				p.ChannelOut <- NewConnStatusMessage(
					p.Connection,
					fmt.Sprintf("Process: %v finished.", p.ProcessName),
					ResponseProcessMessage,
				)
				break
			}
			if p.State == models.ProcessAborted {
				p.ChannelOut <- NewConnStatusMessage(
					p.Connection,
					fmt.Sprintf("Process: %v aborted.", p.ProcessName),
					ResponseProcessMessage,
				)
				break
			}
			select {
			case message := <-p.ProcessMessage:
				// Send channel out
				p.ChannelOut <- NewConnStatusMessage(
					p.Connection,
					message,
					ResponseProcessMessage,
				)
			case subState := <-p.StateChannel:
				p.SubProcessState(subState)
			}
		}
	}()
}

func (p *WebProcess) SubProcessState(subState models.SubProcessState) {
	switch subState.State {

	case models.ProcessFinished:
		p.NumberProcessed++
		p.ChannelOut <- NewConnStatusMessage(
			p.Connection,
			fmt.Sprintf("Sub process: %v finished.", subState.ProcessName),
			ResponseProcessMessage,
		)
		break

	case models.ProcessAborted:
		p.FailedProcesses++
		p.ChannelOut <- NewConnStatusMessage(
			p.Connection,
			fmt.Sprintf("Sub process: %v aborted.", subState.ProcessName),
			ResponseProcessMessage,
		)
		break

	case models.ProcessStarted:
		p.ChannelOut <- NewConnStatusMessage(
			p.Connection,
			fmt.Sprintf("Sub process: %v started.", subState.ProcessName),
			ResponseProcessMessage,
		)
		break

	case models.ProcessUpdate:
		p.ChannelOut <- NewConnStatusMessage(
			p.Connection,
			fmt.Sprintf("%v: %v", subState.ProcessName, subState.Message),
			ResponseProcessMessage,
		)
	}
}

func (p *WebProcess) Abort() {
	p.State = models.ProcessAborted
	p.ChannelOut <- NewConnStatusMessage(
		p.Connection,
		fmt.Sprintf("Process: %v aborted.", p.ProcessName),
		ResponseProcessMessage,
	)
}

func (p *WebProcess) Finish() {
	p.State = models.ProcessFinished
	p.ChannelOut <- NewConnStatusMessage(
		p.Connection,
		fmt.Sprintf("Process: %v finished.", p.ProcessName),
		ResponseProcessMessage,
	)
}

func (p *WebProcess) AddSubProcess(processName string) (*models.SubProcess, error) {
	if _, exists := p.SubProcesses[processName]; exists {
		return &models.SubProcess{}, errors.New("Sub process exists already.")
	}

	p.SubProcesses[processName] = &models.SubProcess{
		StateChannel: p.StateChannel,
		State:        models.ProcessNotStarted,
		ProcessName:  processName,
	}

	return p.SubProcesses[processName], nil
}

func (p *WebProcess) GetSubProcess(processName string) (*models.SubProcess, error) {
	if sub, exists := p.SubProcesses[processName]; exists {
		return sub, nil
	}

	return &models.SubProcess{}, errors.New("Sub process doesn't exist.")
}
