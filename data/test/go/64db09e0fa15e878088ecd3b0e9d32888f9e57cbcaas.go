package ideamart

import (
	"strconv"
	"time"
)

// CaaS Subscriber account types
const (
	CaaSMobileAccount = "MobileAccount"
)

// CaasS Client.
type CaaSClient struct {
	ApplicationID       string
	Password            string
	BalanceEndpoint     string
	DirectDebitEndpoint string
}

type CaaSBalanceRequest struct {
	ApplicationID         string `json:"applicationId"`
	Password              string `json:"password"`
	SubscriberID          string `json:"subscriberId"`
	PaymentInstrumentName string `json:"paymentInstrumentName"`
}

type CaaSBalanceResponse struct {
	StatusCode        string `json:"statusCode"`
	StatusDetail      string `json:"statusDetail"`
	ChargeableBalance string `json:"chargeableBalance"`
	AccountStatus     string `json:"accountStatus"`
	AccountType       string `json:"accountType"`
}

type CaaSDirectDebitRequest struct {
	ApplicationID         string `json:"applicationId"`
	Password              string `json:"password"`
	SubscriberID          string `json:"subscriberId"`
	PaymentInstrumentName string `json:"paymentInstrumentName"`
	ExternalTransactionID string `json:"externalTrxId"`
	Amount                string `json:"amount"`
}

type CaaSDirectDebitResponse struct {
	StatusCode            string `json:"statusCode"`
	Timestamp             string `json:"timeStamp"`
	ShortDescription      string `json:"shortDescription"`
	StatusDetail          string `json:"statusDetail"`
	ExternalTransactionID string `json:"externalTrxId"`
	LongDescription       string `json:"longDescription"`
	InternalTransactionID string `json:"internalTrxId"`
}

func (client *CaaSClient) GetBalance(subscriberId, paymentInstrumentName string) (float64, error) {
	req := CaaSBalanceRequest{
		ApplicationID:         client.ApplicationID,
		Password:              client.Password,
		SubscriberID:          subscriberId,
		PaymentInstrumentName: paymentInstrumentName,
	}
	res := CaaSBalanceResponse{}
	err := doRequest(client.BalanceEndpoint, req, res)
	if err == nil {
		return 0, err
	}
	return strconv.ParseFloat(res.ChargeableBalance, 64)
}

func (client *CaaSClient) DirectDebit(subscriberId, paymentInstrumentName, externalTrxId string, amount float64) (string, time.Time, error) {
	req := CaaSDirectDebitRequest{
		ApplicationID:         client.ApplicationID,
		Password:              client.Password,
		SubscriberID:          subscriberId,
		PaymentInstrumentName: paymentInstrumentName,
		Amount:                strconv.FormatFloat(amount, 'f', 2, 64),
	}
	res := CaaSDirectDebitResponse{}
	err := doRequest(client.DirectDebitEndpoint, req, res)
	if err != nil {
		return "", time.Time{}, err
	}
	t, err := time.Parse(time.RFC3339, res.Timestamp)
	return res.InternalTransactionID, t, nil
}
