package common

/*
Sut contains the software under test used in the performance test
*/
type TestInfo struct {
	BrokerOsName      string `json:"broker_os_name"`
	BrokerOsType      string `json:"broker_os_type"`
	BrokerOsVersion   string `json:"broker_os_version"`
	BrokerSysInfo     string `json:"broker_sysinfo"`
	BrokerHWType      string `json:"broker_hw_type"`
	ConsumerCount     string `json:"consumer_count"`
	ConsumerSysInfo   string `json:"consumer_sysinfo"`
	SutKey            string `json:"sut_key"`
	SutVersion        string `json:"sut_version"`
	TestID            string `json:"test_id"`
	TestDuration      string `json:"test_duration"`
	TestComment       string `json:"test_comment"`
	TestResultComment string `json:"test_result_comment"`
	TestRun           string `json:"test_run"`
	TestStartTime     string `json:"test_start_time"`
	TestReqURL        string `json:"test_req_url"`
	MsgEndpointType   string `json:"msg_endpoint_type"`
	MsgProtocol       string `json:"msg_protocol"`
	MsgSize           string `json:"msg_size"`
	ProducerCount     string `json:"producer_count"`
	ProducerSysInfo   string `json:"producer_sysinfo"`
}
