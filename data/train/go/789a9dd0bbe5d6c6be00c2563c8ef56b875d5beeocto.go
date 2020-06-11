package octo

import (
	"runtime"
	"time"
)

// Contains sets of log levels usable in logging operation details.
const (
	LOGINFO         string = "INFO"
	LOGDEBUG        string = "DEBUG"
	LOGERROR        string = "ERROR"
	LOGTRANSMISSION string = "TRANSMISSION"
	LOGTRANSMITTED  string = "TRANSMITTED"
)

//================================================================================

// Logs defines an interface which provides the capability of structures to meet the
// interface for logging data details.
type Logs interface {
	Log(level string, namespace string, function string, message string, items ...interface{})
}

//================================================================================

// EventType defines a custom int type which signifies the giving type of event.
type EventType int

// contains the various value type of Events supported for the packages event
// notifications. Users can create more with higher value integers.
const (
	GoroutineOpened EventType = iota + 1000
	GoroutineClosed

	ConnectionConnet
	ConnectionDisconnect
	ConnectionAuthenticate
	ClusterConnection

	PingEvent
	PongEvent

	DataRead
	DataWrite
	DataTransform
)

// Event defines a struct which holds details pertaining to specific event.
type Event struct {
	Time       time.Time              `json:"time"`
	Sensor     string                 `json:"sensor"`
	Token      string                 `json:"token"`
	Type       EventType              `json:"type"`
	Data       interface{}            `json:"data"`
	Details    map[string]interface{} `json:"details"`
	Server     string                 `json:"server,omitempty"`
	Client     string                 `json:"client,omitempty"`
	LocalAddr  string                 `json:"localAddr,omitempty"`
	RemoteAddr string                 `json:"RemoteAddr,omitempty"`
}

// Events defines a interface which exposes a method to register and notify
// events which occur to some external API or internal recording log.
type Events interface {
	NotifyEvent(Event) error
}

//================================================================================

// MessageEncoding defines an interface which exposes the ability to encode and
// decode data recieved from server.
type MessageEncoding interface {
	Encode(interface{}) ([]byte, error)
	Decode([]byte) (interface{}, error)
}

//================================================================================

// TCPRequest defines the request which will be recieved from the client to make
// the tcp request and associated data.
type TCPRequest struct {
	UUID string `json:"uuid"`
	Addr string `json:"addr"`
	Data []byte `json:"data"`
}

// TCPResponse defines response object which will be delivered back to the client
// as tcp server response.
type TCPResponse struct {
	UUID    string     `json:"uuid"`
	Error   error      `json:"error"`
	Status  bool       `json:"status"`
	Data    []byte     `json:"data"`
	Request TCPRequest `json:"request"`
}

// TCPTransformer defines function type which takes the provided TCPRequest and transfroms
// it into the expected format for communicate through a tcp connection.
type TCPTransformer interface {
	TransformRequest(TCPRequest) ([]byte, error)
	TransformResponse(data []byte) (TCPResponse, error)
}

//================================================================================

// Contact defines a basic information regarding a specific connection.
type Contact struct {
	UUID   string `json:"uuid"`
	SUUID  string `json:"suuid"`
	Addr   string `json:"addr"`
	Remote string `json:"remote"`
	Local  string `json:"local"`
}

//================================================================================

// AuthCredential defines a struct which holds credentails related to
// the client connecting to the provider.
type AuthCredential struct {
	Scheme string `json:"scheme"`
	Key    string `json:"key"`
	Token  string `json:"token"`
	Data   string `json:"data"`
}

// Authenticator defines a interface type which exposes a method which handles
// the processing of credential authentication.
type Authenticator interface {
	Authenticate(AuthCredential) error
}

// Credentials defines a type which exposes a method to return the credentials
// for the giving entity.
type Credentials interface {
	Credential() AuthCredential
}

//================================================================================

// PingPongs defines an interface which exposes method for pingpong notifications.
type PingPongs interface {
	NotifyPing()
	NotifyPong()
}

// Instrumentation defines an interface for needed features that provided logging,
// metric measurements and time tracking, these instrumentation details allows us
// to measure the internal operations of systems.
type Instrumentation interface {
	Logs
	Events
}

// ConnectionInstrument defines a struct which stores the different data
// related to any connection/disconnection/authentication event that occurs
// for individual systems.
type ConnectionInstrument struct {
	Source string
	Target string
}

// NewConnectionInstrument returns a new instance of a DataInstrument.
func NewConnectionInstrument(source, target string) ConnectionInstrument {
	return ConnectionInstrument{
		Source: source,
		Target: target,
	}
}

//================================================================================

// GoroutineInstrument defines a single instance of a opened/closed goroutine
// including the goroutine stack trace at that point in time.
type GoroutineInstrument struct {
	Line  int
	File  string
	Stack []byte
	Time  time.Time
}

// NewGoroutineInstrument returns a new instance of a GoroutineInstrument with
// then needed details.
func NewGoroutineInstrument() GoroutineInstrument {
	_, file, line, _ := runtime.Caller(1)

	trace := make([]byte, 1<<16)
	trace = trace[:runtime.Stack(trace, true)]

	return GoroutineInstrument{
		Time:  time.Now(),
		Stack: trace,
		File:  file,
		Line:  line,
	}
}

//================================================================================

// DataInstrument defines a single unit of a DataInstrumentation object which
// records the reads, write and any error which occured for such an operation.
type DataInstrument struct {
	Data  []byte
	Error error
}

// NewDataInstrument returns a new instance of a DataInstrument.
func NewDataInstrument(d []byte, err error) DataInstrument {
	return DataInstrument{
		Data:  d,
		Error: err,
	}
}
