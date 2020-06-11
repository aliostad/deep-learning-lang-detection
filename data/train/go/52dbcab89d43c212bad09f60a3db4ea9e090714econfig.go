package goemail

type Config struct {
	Host     string
	Port     int
	User     string
	Name     string
	Password string
	SSL      bool
	Size     int
}

func (c *Config) Valid() bool {
	return len(c.Host) != 0 && c.Port > 0 && len(c.User) != 0 && len(c.Password) != 0
}

// SetConfig set email sender config once
func SetConfig(cs ...*Config) {
	if cs == nil || len(cs) == 0 {
		panic(ERR_CONFIG)
	}
	dispatch_mux.Lock()
	pools = make([]*Pool, 0, len(cs))
	for _, c := range cs {
		if c == nil || !c.Valid() {
			continue
		}
		pools = append(pools, NewPool(c))
	}
	dispatch_mux.Unlock()
}
