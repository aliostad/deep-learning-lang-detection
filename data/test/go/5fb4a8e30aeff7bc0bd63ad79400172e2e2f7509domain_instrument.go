package instruments

import (
	"github.com/cloudfoundry-incubator/receptor"
	"github.com/cloudfoundry-incubator/runtime-schema/metric"
)

const domainMetricPrefix = "Domain."

type domainInstrument struct {
	receptorClient receptor.Client
}

func NewDomainInstrument(receptorClient receptor.Client) Instrument {
	return &domainInstrument{receptorClient: receptorClient}
}

func (t *domainInstrument) Send() {
	// error intentionally dropped; report an empty set in the case of an error
	domains, _ := t.receptorClient.Domains()

	for _, domain := range domains {
		metric.Metric(domainMetricPrefix + domain).Send(1)
	}
}
