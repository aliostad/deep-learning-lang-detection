package process

import (
	"log"
	"pricehistory/crawler"
	"pricehistory/database"
//	"pricehistory/process/status"
)

func Process() {
	log.Println("Start processing")
	defer func() {
		if r := recover(); r != nil {
			log.Println("Recovered in f", r)
		}
	}()
	for {
		processID, link := database.GetUnprocessedLink()
//		database.UpdateLinkProcessStatus(processID, status.InProgress)
		log.Printf("Processing LinkProcess (ID: %d)", processID)
		if processID == 0 {
			log.Printf("Finished processing. No more links", processID)
			break
		}
		crawler.ProcessCatalog(link)
//		database.UpdateLinkProcessStatus(processID, status.Processed)
		log.Printf("Processed  LinkProcess (ID: %d)", processID)
	}

}
