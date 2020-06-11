package main

import "main/dispatch"

var (
	dispatcher           *dispatch.Dispatcher
	medicationsSubject   *dispatch.CollectionSubject
	dosesSubject         *DosesSubject
	doseSummariesSubject *DoseSummariesSubject
	doseStatusesSubject  *DoseStatusesSubject
	prnSubject           *PRNSubject
)

func init() {
	// Create the dispatcher
	dispatcher = dispatch.NewDispatcher()

	// Create and register subjects with the dispatcher
	medicationsSubject = dispatch.NewCollectionSubject("medications", dispatcher)
	dosesSubject = NewDosesSubject(dispatcher)
	doseSummariesSubject = NewDoseSummariesSubject(dispatcher)
	doseStatusesSubject = NewDoseStatusesSubject(dispatcher)
	prnSubject = NewPRNSubject(dispatcher)
}
