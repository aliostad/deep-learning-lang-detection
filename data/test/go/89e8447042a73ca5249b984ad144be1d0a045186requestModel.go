package travelModel

type ChannelInfo struct {
	Requester         string `json:"requester"`
	Instrument        string `json:"instrument"`
	ChannelInstanceID string `json:"channel_instance_id"`
	ChannelConsumerID string `json:"channel_consumer_id"`
}

type DeviceInfo struct {
	DeviceOs        string `json:"device_os"`
	DeviceOsVersion string `json:"device_os_version"`
	DeviceID        string `json:"device_id"`
	Imei            string `json:"imei"`
	Longitude       string `json:"longitude"`
	Latitude        string `json:"latitude"`
	ModelName       string `json:"model_name"`
}

type ServiceInfo struct {
	Operator string `json:"operator"`
	Category string `json:"category"`
}
