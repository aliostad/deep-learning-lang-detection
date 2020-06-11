package vpsie

type Balance struct {
	CurrentBalance float32 `json:"current_balance"`
	BalanceCharged float32 `json:"balance_charged"`
	MonthlyCharge  float32 `json:"monthly_charge"`
}

type balanceResponse struct {
	baseResponse
	Balance Balance `json:"balance"`
}

func (c *client) GetBalance() (Balance, error) {
	out := balanceResponse{}
	return out.Balance, c.doGetRequest("balance", &out)
}

type ProcessStatus struct {
	Status    string `json:"status"`
	Success   bool   `json:"success"`
	Action    string `json:"action"`
	ProcessId string `json:"process_id"`
}

type processStatusResponse struct {
	baseResponse
	Process ProcessStatus `json:"process"`
}

func (c *client) GetProcessStatus(processId string) (ProcessStatus, error) {
	out := processStatusResponse{}
	return out.Process, c.doGetRequest("process/status/"+processId, &out)
}
