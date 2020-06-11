package mesoskafka

import (
	"sort"
	"strconv"

	"github.com/hashicorp/terraform/helper/schema"
)

func resourceMesosKafkaCluster() *schema.Resource {
	return &schema.Resource{
		Create: resourceMesosKafkaClusterCreate,
		Read:   resourceMesosKafkaClusterRead,
		Update: resourceMesosKafkaClusterUpdate,
		Delete: resourceMesosKafkaClusterDelete,

		Schema: map[string]*schema.Schema{
			"broker_count": &schema.Schema{
				Type:     schema.TypeInt,
				Required: true,
				ForceNew: false,
			},
			"constraints": &schema.Schema{
				Type:     schema.TypeString,
				Optional: true,
				ForceNew: false,
			},
			"cpus": &schema.Schema{
				Type:     schema.TypeFloat,
				Optional: true,
				ForceNew: false,
			},
			"memory": &schema.Schema{
				Type:     schema.TypeInt,
				Optional: true,
				ForceNew: false,
			},
			"heap": &schema.Schema{
				Type:     schema.TypeInt,
				Optional: true,
				ForceNew: false,
			},
			"failover_delay": &schema.Schema{
				Type:     schema.TypeString,
				Optional: true,
				ForceNew: false,
			},
			"failover_max_delay": &schema.Schema{
				Type:     schema.TypeString,
				Optional: true,
				ForceNew: false,
			},
			"failover_max_tries": &schema.Schema{
				Type:     schema.TypeInt,
				Optional: true,
				ForceNew: false,
			},
			"jvm_options": &schema.Schema{
				Type:     schema.TypeString,
				Optional: true,
				ForceNew: false,
			},
			"logfourj_options": &schema.Schema{
				Type:     schema.TypeString,
				Optional: true,
				ForceNew: false,
			},
			"options": &schema.Schema{
				Type:     schema.TypeString,
				Optional: true,
				ForceNew: false,
			},
		},
	}
}

func resourceMesosKafkaClusterCreate(d *schema.ResourceData, meta interface{}) error {
	c := meta.(Client)

	brokerCount := d.Get("broker_count").(int)

	brokerIDs := []int{}
	for i := 0; i < brokerCount; i++ {
		brokerIDs = append(brokerIDs, i)
	}

	expectedBrokers := populateBrokerFromResourceData(brokerIDs, d)
	err := c.ApiBrokersCreate(expectedBrokers)

	if err != nil {
		return err
	}

	status, _ := c.ApiBrokersStatus()
	// TODO: this should probably not be this. just a placeholder
	d.SetId(status.FrameworkID)

	return resourceMesosKafkaClusterRead(d, meta)
}

func resourceMesosKafkaClusterRead(d *schema.ResourceData, meta interface{}) error {
	c := meta.(Client)
	status, err := c.ApiBrokersStatus()
	if err != nil {
		return err
	}

	d.Set("broker_count", len(status.Brokers))

	return nil
}

func resourceMesosKafkaClusterUpdate(d *schema.ResourceData, meta interface{}) error {
	c := meta.(Client)
	status, err := c.ApiBrokersStatus()
	if err != nil {
		return err
	}

	brokerCount := d.Get("broker_count").(int)
	currentCount := len(status.Brokers)

	if currentCount > brokerCount {
		// remove some brokers
		howMany := currentCount - brokerCount

		currentBrokers := []int{}
		for _, broker := range status.Brokers {
			_id, _ := strconv.ParseInt(broker.ID, 10, 0)
			id := int(_id)
			currentBrokers = append(currentBrokers, id)
		}
		sort.Ints(currentBrokers)

		toDelete := currentBrokers[len(currentBrokers)-howMany : len(currentBrokers)]

		err := c.ApiBrokersDelete(toDelete)
		if err != nil {
			return err
		}

	}

	if currentCount > 0 && runOptionsHaveChanged(d, *status) {
		// update currently running brokers with new schema vars
		status, _ := c.ApiBrokersStatus()

		c.ApiBrokersUpdate(getUpdatedBrokers(d, *status))
	}

	if brokerCount > currentCount {
		// add some brokers
		howMany := brokerCount - currentCount

		maxBrokerID := 0

		for _, broker := range status.Brokers {
			_id, _ := strconv.ParseInt(broker.ID, 10, 0)
			id := int(_id)
			if id > maxBrokerID {
				maxBrokerID = id
			}
		}

		brokerIDs := []int{}
		for j := maxBrokerID + 1; j <= maxBrokerID+howMany; j++ {
			brokerIDs = append(brokerIDs, j)
		}

		brokers := populateBrokerFromResourceData(brokerIDs, d)
		err := c.ApiBrokersCreate(brokers)
		if err != nil {
			return err
		}

	}

	return nil
}

func resourceMesosKafkaClusterDelete(d *schema.ResourceData, meta interface{}) error {
	c := meta.(Client)

	status, _ := c.ApiBrokersStatus()

	brokerIDs := []int{}
	for i := 0; i < len(status.Brokers); i++ {
		brokerIDs = append(brokerIDs, i)
	}

	err := c.ApiBrokersDelete(brokerIDs)
	if err != nil {
		return err
	}

	return nil
}

func populateBrokerFromResourceData(brokerIDs []int, d *schema.ResourceData) *Brokers {
	brokers := Brokers{}
	for _, brokerID := range brokerIDs {
		broker := Broker{
			ID:           strconv.Itoa(brokerID),
			Memory:       d.Get("memory").(int),
			Heap:         d.Get("heap").(int),
			Cpus:         d.Get("cpus").(float64),
			Constraints:  d.Get("constraints").(string),
			Log4jOptions: d.Get("logfourj_options").(string),
			JVMOptions:   d.Get("jvm_options").(string),
			Options:      d.Get("options").(string),
			Failover: Failover{
				Delay:    d.Get("failover_delay").(string),
				MaxDelay: d.Get("failover_max_delay").(string),
				MaxTries: d.Get("failover_max_tries").(int),
			},
		}

		if v, ok := d.GetOk("active"); ok {
			broker.Active = v.(bool)
		}

		brokers.Brokers = append(brokers.Brokers, broker)
	}
	return &brokers
}

func runOptionsHaveChanged(d *schema.ResourceData, status Status) bool {

	currentBroker := status.Brokers[0]
	currentID, _ := strconv.Atoi(currentBroker.ID)
	expectedBroker := populateBrokerFromResourceData([]int{currentID}, d).Brokers[0]

	if currentBroker.Memory != expectedBroker.Memory {
		return true
	}

	if currentBroker.Heap != expectedBroker.Heap {
		return true
	}

	if currentBroker.Cpus != expectedBroker.Cpus {
		return true
	}

	if currentBroker.Constraints != expectedBroker.Constraints {
		return true
	}

	if currentBroker.Log4jOptions != expectedBroker.Log4jOptions {
		return true
	}

	if currentBroker.JVMOptions != expectedBroker.JVMOptions {
		return true
	}

	if currentBroker.Options != expectedBroker.Options {
		return true
	}

	if currentBroker.Failover.Delay != expectedBroker.Failover.Delay {
		return true
	}

	if currentBroker.Failover.MaxDelay != expectedBroker.Failover.MaxDelay {
		return true
	}

	if currentBroker.Failover.MaxTries != expectedBroker.Failover.MaxTries {
		return true
	}

	return false
}

func getUpdatedBrokers(d *schema.ResourceData, status Status) []Broker {

	brokerIds := []int{}
	for _, broker := range status.Brokers {
		id, _ := strconv.Atoi(broker.ID)
		brokerIds = append(brokerIds, id)
	}

	updatedBrokers := populateBrokerFromResourceData(brokerIds, d).Brokers

	return updatedBrokers
}
