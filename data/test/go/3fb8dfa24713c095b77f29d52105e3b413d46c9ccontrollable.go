package controllable

func init() {

}

// Status of the broker
type Status int8

// Status constants
const (
	NotInitialized Status = 0 << iota // The broker have not been initialized
	Initialized                       // The broker have been initialized
	Started                           // The broker is started
	Stopped                           // The broker is stopped
	Shuwndown                         // The broker is shutdown
)

// Controllable interface
type Controllable interface {
	Initialize() (Status, error)
	Start() (Status, error)
	Stop() (Status, error)
	Shutdown() (Status, error)
}
