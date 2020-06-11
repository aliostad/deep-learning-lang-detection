package harvest

import (
	"fmt"
	"strconv"

	"github.com/cristian-sima/Wisply/models/action"
	"github.com/cristian-sima/Wisply/models/database"
	"github.com/cristian-sima/Wisply/models/harvest/remote"
	"github.com/cristian-sima/Wisply/models/repository"
)

// Process is a link between controller and repository
type Process struct {
	*action.Process
	HarvestID                                  int
	repository                                 *repository.Repository
	remote                                     remote.RepositoryInterface
	controller                                 Controller
	Records, Formats, Identifiers, Collections int
	notifyController                           bool
}

// Start starts the process
func (process *Process) Start() {
	go process.run()
	go process.verify()
}

func (process *Process) run() {
	fmt.Println("Run harvest process...")
	for {
		select {
		case message := <-process.Process.GetOperationConduit():
			if message.GetName() == "operation-failed" {
				process.processFails()
			} else {
				process.chooseAction(message)
			}
		}
	}
}

func (process *Process) chooseAction(message action.OperationMessager) {

	switch message.GetOperation().Content {
	case "Harvest Verification":
		if message.GetValue() == "normal" {
			go process.identify()
		} else {
			process.processFails()
		}
		break
	case "Harvest Identifying":
		if message.GetValue() == "normal" {
			go process.harvestFormats()
		} else {
			process.processFails()
		}
		break
	case "Harvest Formats":
		if message.GetValue() == "normal" {
			go process.harvestCollections()
		} else {
			process.processFails()
		}
		break
	case "Harvest Collections":
		if message.GetValue() == "normal" {
			go process.harvestRecords()
		} else {
			process.processFails()
		}
		break
	case "Harvest Records":
		if message.GetValue() == "normal" {
			go process.harvestIdentifiers()
		} else {
			process.processFails()
		}
	case "Harvest Identifiers":
		if message.GetValue() != "normal" {
			process.processFails()
		}
		process.ChangeRepositoryStatus("ok")
		process.succeeded()
		break
	default:
		fmt.Println("No such operation: " + message.GetOperation().Content)
	}
}

// It starts the process from a certain stage
func (process *Process) startFrom(name string) {
	switch name {
	case "Harvest Verification":
		go process.verify()
		break
	case "Harvest Identifying":
		go process.identify()
		break
	case "Harvest Formats":
		go process.harvestFormats()
		break
	case "Harvest Identifiers":
		go process.harvestIdentifiers()
		break
	case "Harvest Records":
		go process.harvestRecords()
		break
	case "Harvest Collections":
		go process.harvestCollections()
		break
	}
}

// Stage 1

func (process *Process) verify() {
	verification := newVerificationOperation(process)
	process.ChangeCurrentOperation(verification)
	verification.Start()
}

// Stage 2

func (process *Process) identify() {
	identification := newIdentificationOperation(process)
	process.ChangeCurrentOperation(identification)
	identification.Start()
}

// Stage 3

func (process *Process) harvest() {
	process.ChangeRepositoryStatus("updating")
}

// FORMATS

func (process *Process) harvestFormats() {
	process.harvest()
	harvestingFormats := newHarvestingFormats(process)
	process.ChangeCurrentOperation(harvestingFormats)
	harvestingFormats.Start()
}

// COLLECTIONS

func (process *Process) harvestCollections() {
	process.harvest()
	harvestingCollections := newHarvestingCollections(process)
	process.ChangeCurrentOperation(harvestingCollections)
	harvestingCollections.Start()
}

// RECORDS

func (process *Process) harvestRecords() {
	process.harvest()
	harvestingRecords := newHarvestingRecords(process)
	process.ChangeCurrentOperation(harvestingRecords)
	harvestingRecords.Start()
}

// IDENTIFIERS

func (process *Process) harvestIdentifiers() {
	process.harvest()
	identifiers := newHarvestingIdentifiers(process)
	process.ChangeCurrentOperation(identifiers)
	identifiers.Start()
}

// --- end activity

// SuccessFinish tells the constructor that the process is finished
func (process *Process) succeeded() {
	process.GetRepository().SetLastProcess(process.Action.ID)
	process.delete()
	process.ChangeResult("success")
	process.Process.Finish()
}

func (process *Process) delete() {
	process.tellController(&Message{
		Name: "process-finished",
	})
}

func (process *Process) processFails() {
	process.ChangeRepositoryStatus("problems")
	process.ChangeResult("warning")
	process.delete()
	process.Suspend()
}

// GetRepository returns the wisply repository
func (process *Process) GetRepository() *repository.Repository {
	return process.repository
}

// GetRemoteServer returns the interface of a remote repository
func (process *Process) GetRemoteServer() remote.RepositoryInterface {
	return process.remote
}

// ForceFinish changes the status of repository to ok
func (process *Process) ForceFinish() {
	sql := "UPDATE `repository` SET `status` = 'ok' WHERE id=?"
	stmt, err := database.Connection.Prepare(sql)
	if err != nil {
		fmt.Println(err)
	}
	stmt.Exec(process.GetRepository().ID)

	process.Process.ForceFinish()
}

// ChangeCurrentOperation informs the controller about the change and it calls its father
func (process *Process) ChangeCurrentOperation(operation Operationer) {
	process.Process.ChangeCurrentOperation(operation.GetOperation())
}

// UpdateFormats updates the number of formats
func (process *Process) updateFormats(number int) error {
	process.Formats = process.Formats + number
	return process.updateStatistics("formats", number)
}

// UpdateCollections updates the number of collections
func (process *Process) updateCollections(number int) error {
	process.Collections = process.Collections + number
	return process.updateStatistics("collections", number)
}

// UpdateRecords updates the number of records
func (process *Process) updateRecords(number int) error {
	process.Records = process.Records + number
	return process.updateStatistics("records", number)
}

// updateIdentifiers updates the number of identifiers
func (process *Process) updateIdentifiers(number int) error {
	process.Identifiers = process.Identifiers + number
	return process.updateStatistics("identifiers", number)
}

func (process *Process) updateStatistics(name string, number int) error {
	sql := "UPDATE `process_harvest` SET `" + name + "`=`" + name + "` + ? WHERE id=?"
	stmt, err := database.Connection.Prepare(sql)
	if err != nil {
		message := "Error when updating the number of " + name + " to " + strconv.Itoa(number) + ": "
		fmt.Println(message)
		fmt.Println(err)
		return err
	}
	_, err = stmt.Exec(number, process.HarvestID)
	if err == nil {
		process.broadcastStatistics(name, number)
	}
	return err
}

// broadcastStatistics tells the controller the number of "name" items where name is the parameter
func (process *Process) broadcastStatistics(name string, newValue int) {
	value := &struct {
		Operation string
		Number    int
	}{
		Operation: name,
		Number:    newValue,
	}
	process.tellController(&Message{
		Name:  "harvest-update",
		Value: value,
	})
}

// GetStatistics returns the number of formats, collections, records, identifiers
func (process *Process) GetStatistics() (int, int, int, int) {
	var formats, collections, records, identifiers int
	fieldList := "`formats`, `collections`, `records`, `identifiers`"
	sql := "SELECT " + fieldList + " FROM `process_harvest` WHERE id=? LIMIT 0,1"
	query, err := database.Connection.Prepare(sql)

	if err != nil {
		fmt.Println("Error when selecting statistics id:")
		fmt.Println(err)
	}
	query.QueryRow(process.HarvestID).Scan(&formats, &collections, &records, &identifiers)

	return formats, collections, records, identifiers
}

// ChangeRepositoryStatus changes the status of local repository
func (process *Process) ChangeRepositoryStatus(newStatus string) {
	process.repository.ModifyStatus(newStatus)
	process.tellController(&Message{
		Name:  "repository-status-changed",
		Value: newStatus,
	})
}

// GetToken returns the token for a particular name
func (process *Process) GetToken(name string) string {
	return GetProcessToken(process.HarvestID, name)
}

// SaveToken saves the token for a particular name
func (process *Process) SaveToken(name string, token string) {
	sql := "UPDATE `process_harvest` SET `token_" + name + "`=? WHERE id=?"
	stmt, err := database.Connection.Prepare(sql)
	if err != nil {
		fmt.Println("Error 1 when updating the token for " + name + " inside harvesting process: ")
		fmt.Println(err)
	}
	_, err = stmt.Exec(token, process.HarvestID)
	if err != nil {
		fmt.Println("Error 2 when updating the token for " + name + " inside harvesting process: ")
		fmt.Println(err)
	}
}

func (process *Process) tellController(simple *Message) {

	if process.notifyController && process.controller != nil && process.controller.GetConduit() != nil {
		channel := process.controller.GetConduit()
		msg := &ProcessMessage{
			Repository: process.GetRepository().ID,
			ProcessMessage: action.ProcessMessage{
				Process: process,
				Message: &action.Message{
					Name:  simple.Name,
					Value: simple.Value,
				},
			},
		}
		channel <- msg
	}
}

// Delete deletes the harvest process and calls its parent method
func (process *Process) Delete() {
	process.Process.Delete()
}

// Recover loads the process in memory and starts executing the last stage
func (process *Process) Recover() {
	var name string
	lastOperation := process.Process.GetCurrentOperation().ID

	// gets the name of the current stage
	sql := "SELECT `content` FROM `operation` WHERE id=? LIMIT 0,1"
	query, err := database.Connection.Prepare(sql)
	query.QueryRow(lastOperation).Scan(&name)

	if err != nil {
		fmt.Println("Error when selecting the harvest id:")
		fmt.Println(err)
	}

	process.Process.Recover()

	// start channel
	go process.run()

	// execute stage
	process.startFrom(name)
}
