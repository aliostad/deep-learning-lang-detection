package trthrest

import "time"

//InstrumentIdentifier : defined type for instrument used in InstrumentIdentifierList. This type will be encoded to Json by Marshaller
type InstrumentIdentifier struct {
	Identifier     string
	IdentifierType string
}

//InstrumentValidationOptions : defined type for InstrumentValidationOptions used in InstrumentIdentifierList. This type will be encoded to Json by Marshaller
type InstrumentValidationOptions struct {
	AllowOpenAccessInstruments          bool `json:",omitempty"`
	AllowHistoricalInstruments          bool `json:",omitempty"`
	ExcludeFinrAsPricingSourceForBonds  bool `json:",omitempty"`
	UseExchangeCodeInsteadOfLipper      bool `json:",omitempty"`
	UseUsQuoteInsteadOfCanadian         bool `json:",omitempty"`
	UseConsolidatedQuoteSourceForUsa    bool `json:",omitempty"`
	UseConsolidatedQuoteSourceForCanada bool `json:",omitempty"`
	UseDebtOverEquity                   bool `json:",omitempty"`
}

//TickHistoryMarketDepthCondition : defined type for TickHistoryMarketDepthCondition used in TickHistoryMarketDepthExtractionRequest. This type will be encoded to Json by Marshaller
type TickHistoryMarketDepthCondition struct {
	View                TickHistoryMarketDepthViewOptions
	NumberOfLevels      int32 `json:",omitempty"`
	SortBy              TickHistorySort
	MessageTimeStampIn  TickHistoryTimeOptions
	ReportDateRangeType ReportDateRangeType
	//QueryStartDate is defined as pointer because it is optional
	QueryStartDate *time.Time `json:",omitempty"`
	//QueryEndDate is defined as pointer because it is optional
	QueryEndDate         *time.Time `json:",omitempty"`
	DaysAgo              int32      `json:",omitempty"`
	RelativeStartDaysAgo int32      `json:",omitempty"`
	RelativeEndDaysAgo   int32      `json:",omitempty"`
	RelativeStartTime    string     `json:",omitempty"`
	RelativeEndTime      string     `json:",omitempty"`
	DateRangeTimeZone    string     `json:",omitempty"`
	Preview              PreviewMode
	ExtractBy            TickHistoryExtractByMode
	DisplaySourceRIC     bool
}

//InstrumentIdentifierList : defined type for InstrumentIdentifierList used in TickHistoryMarketDepthExtractionRequest. This type will be encoded to Json by Marshaller
type InstrumentIdentifierList struct {
	//It uses 'json' metadata to change the fieldname from Metadata to @data.type
	//It uses user-defined 'odata' metadata to define the default value
	Metadata              string                 `json:"@odata.type" odata:"#ThomsonReuters.Dss.Api.Extractions.ExtractionRequests.InstrumentIdentifierList"`
	InstrumentIdentifiers []InstrumentIdentifier `json:",omitempty"`
	//ValidationOptions is defined as pointer because it is optional
	ValidationOptions                      *InstrumentValidationOptions `json:",omitempty"`
	UseUserPreferencesForValidationOptions bool                         `json:",omitempty"`
}

//Credential : The type is used Authentication/RequestToken request. It will be encoded to JSON by Marshaller
type Credential struct {
	Username string
	Password string
}
