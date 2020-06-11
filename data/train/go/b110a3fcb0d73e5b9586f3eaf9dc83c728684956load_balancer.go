package db

// A LoadBalancer row is created for each load balancer specified by the policy.
type LoadBalancer struct {
	ID int

	Name      string
	IP        string
	Hostnames []string
}

// LoadBalancerSlice is an alias for []LoadBalancer to allow for joins
type LoadBalancerSlice []LoadBalancer

// InsertLoadBalancer creates a new load balancer row and inserts it into the database.
func (db Database) InsertLoadBalancer() LoadBalancer {
	result := LoadBalancer{ID: db.nextID()}
	db.insert(result)
	return result
}

// SelectFromLoadBalancer gets all load balancers in the database that satisfy 'check'.
func (db Database) SelectFromLoadBalancer(check func(LoadBalancer) bool) []LoadBalancer {
	var result []LoadBalancer
	for _, row := range db.selectRows(LoadBalancerTable) {
		if check == nil || check(row.(LoadBalancer)) {
			result = append(result, row.(LoadBalancer))
		}
	}

	return result
}

// SelectFromLoadBalancer gets all load balancers in the database connection
// that satisfy 'check'.
func (conn Conn) SelectFromLoadBalancer(check func(LoadBalancer) bool) []LoadBalancer {
	var result []LoadBalancer
	conn.Txn(LoadBalancerTable).Run(func(view Database) error {
		result = view.SelectFromLoadBalancer(check)
		return nil
	})
	return result
}

func (lb LoadBalancer) getID() int {
	return lb.ID
}

func (lb LoadBalancer) String() string {
	return defaultString(lb)
}

func (lb LoadBalancer) less(row row) bool {
	lb2 := row.(LoadBalancer)

	switch {
	case lb.Name != lb2.Name:
		return lb.Name < lb2.Name
	default:
		return lb.ID < lb2.ID
	}
}

// Get returns the value contained at the given index
func (ls LoadBalancerSlice) Get(i int) interface{} {
	return ls[i]
}

// Len returns the number of items in the slice
func (ls LoadBalancerSlice) Len() int {
	return len(ls)
}

// Less implements less than for sort.Interface.
func (ls LoadBalancerSlice) Less(i, j int) bool {
	return ls[i].less(ls[j])
}

// Swap implements swapping for sort.Interface.
func (ls LoadBalancerSlice) Swap(i, j int) {
	ls[i], ls[j] = ls[j], ls[i]
}
