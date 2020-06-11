package mc

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

const (
	LOAD_AVG1_IDX = iota
	LOAD_AVG5_IDX
	LOAD_AVG15_IDX
	KERNEL_SCHEDULE_IDX
	RECENT_CREATE_PID_IDX
	LOAD_AVG_FIELDS_LEN
)

type MetricLoad struct {
	LoadAvg1  float64
	LoadAvg5  float64
	LoadAvg15 float64
}

func GetLoadInfo() (load MetricLoad, _ error) {
	/*
		cat /proc/loadavg
		6.08 6.17 6.09 7/2132 11457
	*/
	file, err := os.Open("/proc/loadavg")
	if err != nil {
		return load, err
	}
	defer file.Close()

	reader := bufio.NewReader(file)
	scanner := bufio.NewScanner(reader)

	for scanner.Scan() {
		fields := strings.Fields(scanner.Text())
		if len(fields) != LOAD_AVG_FIELDS_LEN {
			return load, fmt.Errorf("load avg line is invalid, %s", scanner.Text())
		}
		var err error
		load.LoadAvg1, err = strconv.ParseFloat(fields[LOAD_AVG1_IDX], 64)
		if err != nil {
			return load, err
		}
		load.LoadAvg5, err = strconv.ParseFloat(fields[LOAD_AVG5_IDX], 64)
		if err != nil {
			return load, err
		}
		load.LoadAvg15, err = strconv.ParseFloat(fields[LOAD_AVG15_IDX], 64)
		if err != nil {
			return load, err
		}
		return load, nil
	}

	return load, fmt.Errorf("no content in /proc/loadavg")
}
