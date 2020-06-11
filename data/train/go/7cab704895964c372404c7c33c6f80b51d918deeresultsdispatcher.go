package jobworker

import "github.com/fatih/color"
import "time"

var stTime time.Time

func ResultsDispatcher(resultQueue chan JobResult, signaler chan int) {

	stTime = time.Now()
	for {

		select {

		case jr := <-resultQueue:
			ProcessResult(&jr)

		case <-signaler:
			return

		}
	}
}

var cnt int = 0
var TotalDone int = 0
var Rate float64

var resultsToDispatch [](*JobResult)

func ProcessResult(jresult *JobResult) {

	cnt += 1
	TotalDone += 1
	elapsed := time.Since(stTime)

	Rate = float64(cnt) / elapsed.Seconds()

	if elapsed.Seconds() > float64(15) {
		cnt = 1
		stTime = time.Now()
		// color.Blue("\nResetting Counter")
	}

	// color.Cyan("#%d - Rate: %f jobs/seconds\n", TotalDone, Rate)
	if jresult.Status != 0 {
		color.Red("Error: %s", jresult.ErrorMsg)
	}

	resultsToDispatch = append(resultsToDispatch, jresult)

	if len(resultsToDispatch) > Config.DispatchBufferSize {
		DispatchMassResults()
		resultsToDispatch = [](*JobResult){}
	}

}

func DispatchMassResults() {

	// color.Red("\nDispatching Mass Results\n")

	for i := 0; i < len(resultsToDispatch); i++ {

		DispatchResult(resultsToDispatch[i])
	}

	FlushCompletedJobs(Config.Fetch_Binkey)
	// color.Green("\nDispatching Done\n")
}
