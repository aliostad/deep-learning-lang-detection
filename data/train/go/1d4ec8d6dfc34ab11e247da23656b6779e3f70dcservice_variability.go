package services

//variability service, call each Config/Variability_HiSeq_E.xml
import (
	"fmt"
	"github.com/astaxie/beego/orm"
	"github.com/ws6/raptor/models"
	"github.com/ws6/raptor/sgconn/sgmod"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
)

var (
	reVariablity = regexp.MustCompile("Variability_HiSeq_.")
)

type FlowcellInstrument struct {
	Id          int
	Location    string
	MachineName string
}

func GetInstrumentVariability(fcLocation string) (string, error) {
	configFolder := filepath.Join(fcLocation, "Config")
	configInfo, err := os.Stat(configFolder)
	if os.IsNotExist(err) {
		//		fmt.Println("no Config folder")
		return "", nil
	}
	if configInfo == nil {
		return "", fmt.Errorf("not getting any fileinfo %s", fcLocation)
	}
	if !configInfo.IsDir() {
		//		fmt.Println("Config is not a folder")
		return "", nil
	}
	files, err := ioutil.ReadDir(configFolder)
	if err != nil {
		//		fmt.Println("read Config folder err:", err.Error())
		return "", err
	}
	for _, f := range files {
		//		fmt.Println(f.Name())
		variabilityFile := reVariablity.FindString(f.Name())
		if variabilityFile != "" {
			//			fmt.Println("found ", variabilityFile)
			tmp := strings.Split(variabilityFile, "_")
			return tmp[len(tmp)-1], nil
		}

	}
	//	fmt.Println("not found variabilityFile")
	return "", nil
}

func rankByWordCount(wordFrequencies map[string]int) PairList {
	pl := make(PairList, len(wordFrequencies))
	i := 0
	for k, v := range wordFrequencies {
		pl[i] = Pair{k, v}
		i++
	}
	sort.Sort(sort.Reverse(pl))
	return pl
}

type Pair struct {
	Key   string
	Value int
}

type PairList []Pair

func (p PairList) Len() int           { return len(p) }
func (p PairList) Less(i, j int) bool { return p[i].Value < p[j].Value }
func (p PairList) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

func SummaryInstrument(machines map[string]map[string]int) []sgmod.InstrumentType {
	ret := []sgmod.InstrumentType{}
	for machineName, m := range machines {
		if len(m) == 0 {
			continue
		}
		toAdd := sgmod.InstrumentType{
			InstrumentName: machineName,
		}
		pl := rankByWordCount(m)
		toAdd.Variability = pl[0].Key
		for _, v := range m {
			toAdd.VariabilityTotal += v
		}
		toAdd.VariabilityCallRate = float64(pl[0].Value) / float64(toAdd.VariabilityTotal)
		ret = append(ret, toAdd)
	}
	return ret
}

func SummaryVariability() (bool, string) {
	//TODO
	//summary all flowcells variability by instrument name

	sql := `SELECT id, location, machine_name 
	From flowcell 
	 `
	o := orm.NewOrm()
	var flowcells []FlowcellInstrument

	if _, err := o.Raw(sql).QueryRows(&flowcells); err != nil {
		return false, "init query error:" + err.Error()
	}
	//machine type count for majority vote later
	machine := make(map[string]map[string]int)
	msg := []string{}
	for _, fc := range flowcells {
		//		fmt.Println("checking ", fc.Location)
		//pull variability files
		tag, err := GetInstrumentVariability(fc.Location)
		if err != nil {
			msg = append(msg, fmt.Sprintf("parse variability err:%s %s", fc.Location, err.Error()))
			continue
		}
		//no tag found
		if tag == "" {
			continue
		}
		//		fmt.Println("found tag", tag)
		if _, ok := machine[fc.MachineName]; !ok {
			machine[fc.MachineName] = make(map[string]int)
		}
		machine[fc.MachineName][tag]++
	}
	//	fmt.Printf("%+v\n", machine)
	toUpdate := SummaryInstrument(machine)
	sgApi, err := models.GetSgApi()
	if err != nil {
		msg = append(msg, fmt.Sprintf("variability sgClient err:%s", err.Error()))
		return false, strings.Join(msg, "\n")
	}
	for _, eachInstrument := range toUpdate {
		//		fmt.Printf("%+v\n", eachInstrument)
		if _, err := sgApi.UpdateOrCreateInstrument(&eachInstrument); err != nil {
			msg = append(msg, fmt.Sprintf("variability sgsync err:%s", err.Error()))
			continue
		}
	}
	return len(msg) == 0, strings.Join(msg, "\n")
}
