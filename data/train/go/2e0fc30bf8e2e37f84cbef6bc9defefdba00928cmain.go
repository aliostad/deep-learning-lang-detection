package main

import(
	"time"
	"database/sql"
	_ "github.com/mattn/go-sqlite3"
	"github.com/coopernurse/gorp"
)

var dbmap *gorp.DbMap

func main() {
	db, err := sql.Open("sqlite3", "./medical-now.db")
	if err != nil {
		panic(err)
	}
	dbmap = &gorp.DbMap{Db: db, Dialect: gorp.SqliteDialect{}}


	dbmap.AddTable(Patient{}).SetKeys(true, "Id")
	dbmap.AddTable(Nurse{}).SetKeys(true, "Id")
	dbmap.AddTable(Scheduled_Procedure{}).SetKeys(true, "Id")
	dbmap.AddTable(Procedure_Template{}).SetKeys(true, "Id")
	dbmap.AddTable(Procedure{}).SetKeys(true, "Id")
	dbmap.AddTable(Device{}).SetKeys(true, "Id")
	err = dbmap.CreateTablesIfNotExists()
	if err != nil {
		panic(err)
	}


	
	var patients []*Patient
	_, err = dbmap.Select(&patients, "select * from Patient")
	if err != nil {
		panic(err)
	}
	
	dispatch := make(chan *Procedure)
	addChannels := make([]chan *Scheduled_Procedure, 0)
	
	for _,patient := range patients {
		addChannel := make(chan *Scheduled_Procedure)
		go patient.eventLoop(dispatch, addChannel)
		addChannels = append(addChannels, addChannel)
		
	}

	go dispatchProcedure(dispatch)
	go scheduleProcedures(addChannels)
	serve()
}

func scheduleProcedures(addChans []chan *Scheduled_Procedure) {
	var scheduledProcedures []*Scheduled_Procedure
	_, err := dbmap.Select(&scheduledProcedures, "select * from Scheduled_Procedure")
	if err != nil {
		panic(err)
	}
	for _, scheduledProc := range scheduledProcedures {
		for _, c := range addChans {
			c<-scheduledProc
		}
	}

}


func dispatchProcedure(incoming chan *Procedure) {
	for {
		<-incoming
		print("Got Procedure " + time.Now().Format(time.Kitchen))
	}
}

func (p *Patient) eventLoop(dispatch chan *Procedure, additem chan *Scheduled_Procedure) {
	responder := make(chan *Procedure)
	for {
		var scheduledprocedure *Scheduled_Procedure
		var procedure *Procedure
		select {
		case procedure = <-responder:
			dispatch <- procedure
		case scheduledprocedure = <-additem:
			if scheduledprocedure.Patient_Id == p.Id {
				go scheduledprocedure.dispatchWhenReady(responder)
			}
		}
	}
}

func (s *Scheduled_Procedure) dispatchWhenReady(dispatch chan *Procedure) {
	//We get the current unix time, the frequency of the
	//treatment, we then iterate adding that frequency to the
	//'first time' until we get to the present day. We then set up
	//a duration timer to wake us, at which point we will dispatch
	//a new procedure, then wait again.

	
	duration := time.Duration(s.Period) * time.Millisecond
	time_now := time.Now()

	first_occasion := time.Unix(s.First_Occasion, 0);

	for first_occasion.Before(time_now) {
		first_occasion = first_occasion.Add(duration)
	}

	sleep_time := first_occasion.Sub(time_now)
	time.Sleep(sleep_time)
	dispatch <- new(Procedure)
	for {
		time.Sleep(duration)
		dispatch <- new(Procedure)
	}
}
