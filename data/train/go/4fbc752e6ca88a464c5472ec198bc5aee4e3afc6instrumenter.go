package instrumenter

import (
	"math"
	"time"

	inst "github.com/HailoOSS/service/instrumentation"
	"github.com/HailoOSS/provisioning-manager-service/domain"
	"github.com/HailoOSS/provisioning-manager-service/registry"
)

type stats struct {
	name         string
	tcpu, ucpu   float64
	tmem, umem   uint64
	tdisk, udisk uint64
}

func (s *stats) update(p *domain.Provisioner) {
	fcpu := float64(p.Machine.Cores)
	s.tcpu += fcpu
	s.tmem += p.Machine.Memory
	s.tdisk += p.Machine.Disk
	s.ucpu += (p.Machine.Usage.Cpu * fcpu)
	s.umem += p.Machine.Usage.Memory
	s.udisk += p.Machine.Usage.Disk
}

func bytesToGb(i uint64) time.Duration {
	return time.Duration(float64(i)/math.Pow(1024, 3)) * time.Millisecond
}

func kbToGb(i uint64) time.Duration {
	return time.Duration(float64(i)/math.Pow(1024, 2)) * time.Millisecond
}

func (s *stats) instrument() {
	inst.Timing(1.0, "metrics."+s.name+".total_cpu", time.Duration(s.tcpu)*time.Millisecond)
	inst.Timing(1.0, "metrics."+s.name+".total_mem", bytesToGb(s.tmem))
	inst.Timing(1.0, "metrics."+s.name+".total_disk", kbToGb(s.tdisk))
	inst.Timing(1.0, "metrics."+s.name+".used_cpu", time.Duration(s.ucpu)*time.Millisecond)
	inst.Timing(1.0, "metrics."+s.name+".used_mem", bytesToGb(s.umem))
	inst.Timing(1.0, "metrics."+s.name+".used_disk", kbToGb(s.udisk))
}

func instrument() {
	provisioners, err := registry.List()
	if err != nil {
		return
	}

	metrics := make(map[string]*stats)
	total := &stats{name: "overall"}

	for _, provisioner := range provisioners {
		st, ok := metrics[provisioner.MachineClass]
		if !ok {
			st = &stats{name: provisioner.MachineClass}
			metrics[provisioner.MachineClass] = st
		}
		st.update(provisioner)
		total.update(provisioner)
	}

	metrics["overall"] = total

	for _, st := range metrics {
		st.instrument()
	}
}

func run() {
	ticker := time.NewTicker(time.Second * 30)
	for {
		select {
		case <-ticker.C:
			instrument()
		}
	}
}

func Run() {
	go run()
}
