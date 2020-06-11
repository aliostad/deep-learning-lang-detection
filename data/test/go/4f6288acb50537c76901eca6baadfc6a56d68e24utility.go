package database

import (
	"database/sql"
	"fmt"
	"golearn/rest_example/lib"
	"html/template"
	"net/http"
)

func GetFutureQuery() string {
	return fmt.Sprintf(`SELECT ident.Identifier, im.Currency, md.MarketName, 
                        fc.ExpirationDate, contract.* FROM InstrumentMaster AS im
                        JOIN IdentifierMap AS ident ON im.InstrumentID = ident.InstrumentID
                        JOIN MarketDefinition AS md ON im.MarketID = md.MarketID
                        JOIN FuturesCharacteristics AS fc ON im.InstrumentID = fc.InstrumentID
                        JOIN FuturesContractTypes AS contract ON fc.ContractTypeID = contract.ContractTypeID
                        WHERE ident.IdentifierTypeID = 1 AND im.InstTypeID = 2 GROUP BY im.InstrumentID;`)
}

func GetOptionsQuery() string {
	return fmt.Sprintf(`SELECT ident.Identifier, im.Currency, md.MarketName, 
		                max(instrTSM.StartDate) AS StartDt, instrTSM.Multiplier, instrTSM.TickSizeRegimeID, oc.* 
		                FROM InstrumentMaster AS im JOIN IdentifierMap AS ident ON im.InstrumentID = ident.InstrumentID 
	                    JOIN MarketDefinition AS md ON im.MarketID = md.MarketID 
	                    JOIN OptionsCharacteristics AS oc ON im.InstrumentID = oc.InstrumentID 
	                    JOIN InstrumentTickSizeMultiplier AS instrTSM ON im.InstrumentID = instrTSM.InstrumentID 
	                    WHERE ident.IdentifierTypeID = 1 im.InstTypeID = 3 GROUP BY im.InstrumentID;`)
}

func GetValidInt(a sql.NullInt64) int {
	if a.Valid {
		return int(a.Int64)
	}
	return 0
}

func GetValidString(a sql.NullString) string {
	if a.Valid {
		return string(a.String)
	}
	return ""
}

func GetValidFloat(a sql.NullFloat64) float64 {
	if a.Valid {
		return float64(a.Float64)
	}
	return 0
}

func WriteHtmlFutures(W http.ResponseWriter, results []lib.Futures) error {
	var futures = template.Must(template.New("futures").Parse(`
	  <h1>Future Symbols</h1>
	  <table>
	    <tr style='text-align: left'>
	      <th>Currency</th>
	      <th>MarketID</th>
	      <th>Identifier</th>
	      <th>CurrentRootSymbol</th>
	      <th>ExpirationDate</th>
	      <th>Underlier</th>
	      <th>SpreadTickSize</th>
	      <th>DeliveryType</th>
	      <th>InitialMargin</th>
	      <th>MaintenanceMargin</th>
	      <th>MemeberInitialMargin</th>
	      <th>MemeberMainenanceMargin</th>
	    </tr>
	    {{range .}}
	      <tr>
	        <td>{{.Currency}}</td>
	        <td>{{.MarketID}}</td>
	        <td>{{.Identifier}}</td>
	        <td>{{.CurrentRootSymbol}}</td>
	        <td>{{.ExpirationDate}}</td>
	        <td>{{.Underlier}}</td>
	        <td>{{.SpreadTicketSize}}</td>
	        <td>{{.DeliveryType}}</td>
	        <td>{{.InitialMargin}}</td>
	        <td>{{.MaintenanceMargin}}</td>
	        <td>{{.MemberInitialMargin}}</td>
	        <td>{{.MemberMaintenanceMargin}}</td>
	      </tr>
	    {{end}}
	  </table>`))
	return futures.Execute(W, results)
}
