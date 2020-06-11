package utilization

//TODO parsing duration of all flowcell from June 1st 2016
//TODO bin into instrument type and instrumen by total durations and idle?
import (
	"fmt"
	"os"
	"time"

	"github.com/astaxie/beego/orm"
	"github.com/ws6/sagecore/logger"
	"github.com/ws6/sagecore/models"
)

var (
	slack      = logger.GetLogger()
	SERVER_MAP = map[string]string{
		`sgnt-prd-venk01`:              `Singapore`,
		`ussf-prd-brln01`:              `Mission Bay`,
		`ukch-prd-lnah-saf-1`:          `Chesterford`,
		`ushw-prd-venk01.illumina.com`: `Hayward`,
		`usmd-prd-sage01.illumina.com`: `Madison`,
		//the rest are supposed San Diego
	}
)

const LIMIT = 1000

func getFlowcellChan() chan *models.Flowcell {
	ret := make(chan *models.Flowcell, LIMIT*3)

	o := orm.NewOrm()

	go func() {
		offset := 0
		for {
			var flowcells []*models.Flowcell
			query := o.QueryTable(&models.Flowcell{}).Filter(`run_start_date__gt`, `2017-03-31`).Filter(`run_start_date__lt`, `2017-06-30`)
			offset += LIMIT
			if _, err := query.Offset(offset).Limit(LIMIT).All(&flowcells); err != nil {
				break
			}

			if len(flowcells) == 0 {
				break
			}

			for _, flowcell := range flowcells {
				ret <- flowcell
				//				slack.Info("%s %s", flowcell.RunStartDate, flowcell.RunId)
			}

		}
		close(ret)
	}()
	return ret
}

type flowcellStat struct {
	flowcell     *models.Flowcell
	durationDays float64
	site         string
}
type instrumentStat struct {
	count          int
	durationDays   float64
	instrumentType string
	site           string
}

func StatDuration() error {
	flowcellChan := getFlowcellChan()
	uniqFlowcells := make(map[string]*flowcellStat)  //flowcell id ->duration
	byInstrument := make(map[string]*instrumentStat) //instrument type->stat
	instrumentTypes := make(map[string]bool)
	//instrumentStat
	emtpy := time.Time{}
	for flowcell := range flowcellChan {
		//do calculation
		if emtpy.Equal(flowcell.CifLatest) || emtpy.Equal(flowcell.CifFirst) {
			continue
		}
		site, ok := SERVER_MAP[flowcell.Server]
		if !ok {
			site = `San Diego`
		}
		dur := flowcell.CifLatest.Sub(flowcell.CifFirst)
		durHours := dur / time.Hour
		durDays := float64(durHours) / 24.

		if _, ok := uniqFlowcells[flowcell.RunId]; !ok {
			uniqFlowcells[flowcell.RunId] = &flowcellStat{
				flowcell:     flowcell,
				site:         site,
				durationDays: durDays,
			}
			//						slack.Info(`%s %s %s %s %.2f`, site, flowcell.RunId, flowcell.CifFirst, flowcell.CifLatest, durDays)

			//!!!do not over count on duplicates
			instrumentTypes[flowcell.InstrumentType] = true
			if _, ok := byInstrument[flowcell.MachineName]; !ok {
				byInstrument[flowcell.MachineName] = new(instrumentStat)
				byInstrument[flowcell.MachineName].instrumentType = flowcell.InstrumentType
				byInstrument[flowcell.MachineName].site = site

			}
			byInstrument[flowcell.MachineName].count++
			byInstrument[flowcell.MachineName].durationDays += durDays

		}

	}
	pivotFile := `Pivot.csv`
	fo, err := os.Create(pivotFile)
	if err != nil {
		return err
	}

	defer fo.Close()
	header := "InstrumentType,InstrumentName,Site,TotalDays,Counts\n"
	fo.Write([]byte(header))
	for typ, _ := range instrumentTypes {
		for machine, stat := range byInstrument {
			if stat.instrumentType != typ {
				continue
			}

			line := fmt.Sprintf("%s,%s,%s,%.2f,%d\n", typ, machine, stat.site, stat.durationDays, stat.count)
			fo.Write([]byte(line))
		}
	}
	utilFile := `Utilization_Data.csv`
	uo, err := os.Create(utilFile)
	if err != nil {
		return err
	}

	defer uo.Close()
	uheader := "DurationDays,Cycles,RunId,ApplicationName,Server,Status,RunStartedAt,Site\n"
	uo.Write([]byte(uheader))
	for _, stat := range uniqFlowcells {
		line := fmt.Sprintf("%.2f,%d,%s,%s,%s,%s,%s,%s\n",
			stat.durationDays,
			stat.flowcell.Cycles,
			stat.flowcell.RunId,
			stat.flowcell.ApplicationName,
			stat.flowcell.Server,
			stat.flowcell.Status,
			stat.flowcell.RunStartDate,
			stat.site,
		)
		uo.Write([]byte(line))
	}
	return nil
}
