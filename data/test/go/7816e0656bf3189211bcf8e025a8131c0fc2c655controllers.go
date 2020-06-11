package main

import (
    "net/http"
    "encoding/json"
    "time"
    "io"
    "io/ioutil"
    "strings"

    "github.com/gorilla/mux"
)

type Link struct {
    Rel      string    `json:"rel"`
    Href     string    `json:"href"`
}

type Links []Link

func IndexController(w http.ResponseWriter, r *http.Request) {
    var links = Links{
        Link{Rel: "self", Href: config.BaseURI+"/"},
        Link{Rel: "status", Href: config.BaseURI+"/status"},
        Link{Rel: "instruments", Href: config.BaseURI+"/instruments"},
    }

    w.Header().Set("Content-Type", "application/json; charset=UTF-8")
    w.WriteHeader(http.StatusOK)
    if err := json.NewEncoder(w).Encode(links); err != nil {
        panic(err)
    }
}

type Status struct {
    Status      string    `json:"status"`
}

func StatusController(w http.ResponseWriter, r *http.Request) {
    var status = Status{Status: "OK"}
    w.Header().Set("Content-Type", "application/json; charset=UTF-8")
    w.WriteHeader(http.StatusOK)
    if err := json.NewEncoder(w).Encode(status); err != nil {
        panic(err)
    }
}

func InstrumentsController(w http.ResponseWriter, r *http.Request) {
    var instruments = Instruments{
        getInstrument("CS.D.GBPUSD.TODAY.IP", false),
    }

    w.Header().Set("Content-Type", "application/json; charset=UTF-8")
    w.WriteHeader(http.StatusOK)
    if err := json.NewEncoder(w).Encode(instruments); err != nil {
        panic(err)
    }
}

func getInstrument(id string, includeResolutions bool) Instrument {
    // TODO: Query database to make sure instrument exists (cache in memory since this will be called a lot and instruments cannot be deleted)
    // TODO: Add in links after (this function shouldn't add them.. then we don't need the bool)
    return Instrument{Id: id, Links: instrumentLinks(id, includeResolutions)}
}

func instrumentLinks(id string, includeResolutions bool) Links {
	var links = Links{
        Link{Rel: "self", Href: config.BaseURI+"/instruments/"+id},
    }
    if includeResolutions {
        // TODO: Query database to get all resolutions (don't have to be specific to this instrument - could just be a globally collected list)
    	// TODO: Some caching (e.g., refresh every 60sec)
        for resolution,_ := range resolutions {
    		links = append(links, Link{Rel: resolution, Href: config.BaseURI+"/instruments/"+id+"/"+resolution})
    	}
    }
	return links
}

func InstrumentController(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	var instrumentId string = strings.ToUpper(vars["instrumentId"])
	var instrument = getInstrument(instrumentId, true)

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
    w.WriteHeader(http.StatusOK)
    if err := json.NewEncoder(w).Encode(instrument); err != nil {
        panic(err)
    }
}

func ResolutionController(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    var instrumentId string = strings.ToUpper(vars["instrumentId"])
    var resolution string = strings.ToUpper(vars["resolution"])
    resolutionDuration := resolutions[resolution]
    if resolutionDuration == 0 {
        setHttpError(w, 400, "UNKNOWN_RESOLUTION", "Unknown resolution.")
        return
    }

    var instrument = getInstrument(instrumentId, false)
    startDate, endDate := getDateRangeNCandlesAgo(time.Now(), 10, resolutionDuration)
    instrument.Links = append(instrument.Links, Link{Rel: "recent", Href: config.BaseURI+"/instruments/"+instrumentId+"/"+resolution+"/"+startDate.Format(time.RFC3339)+"/"+endDate.Format(time.RFC3339)})
    
    w.Header().Set("Content-Type", "application/json; charset=UTF-8")
    w.WriteHeader(http.StatusOK)
    if err := json.NewEncoder(w).Encode(instrument); err != nil {
        panic(err)
    }
}

// TODO: test me
func getDateRangeNCandlesAgo(now time.Time, candles int, resolutionDuration time.Duration) (time.Time, time.Time) {
    var endDate = now.Truncate(resolutionDuration)
    var startDate = endDate.Add(-time.Duration(candles) * resolutionDuration)
    return startDate, endDate
}

func CandlesController(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    instrumentId := strings.ToUpper(vars["instrumentId"])
    resolution := strings.ToUpper(vars["resolution"])
    resolutionDuration := resolutions[resolution]
    if resolutionDuration == 0 {
        setHttpError(w, 400, "UNKNOWN_RESOLUTION", "Unknown resolution.")
        return
    }

    startDate, err := time.Parse(time.RFC3339, vars["startDate"])
    if err != nil {
        setHttpError(w, http.StatusBadRequest, "INVALID_START_DATE", "Invalid start date. Must conform to RFC3339.")
        return
    }
    startDate = startDate.Truncate(resolutionDuration)

    endDate, err := time.Parse(time.RFC3339, vars["endDate"])
    if err != nil {
        setHttpError(w, http.StatusBadRequest, "INVALID_END_DATE", "Invalid end date. Must conform to RFC3339.")
        return
    }
    endDate = endDate.Truncate(resolutionDuration)

    instrument := getInstrument(instrumentId, false)
    candles, err := getCandles(dbContext, instrumentId, resolution, resolutionDuration, startDate, endDate)
    if err != nil {
        setHttpError(w, 500, "INTERNAL_ERROR", "An internal error occurred while trying to retrieve candles: " + err.Error())
        return
    }

    response := CandlesResponse{Instrument: instrument, Resolution: resolution, StartDate: startDate, EndDate: endDate, Candles: candles}

    w.Header().Set("Content-Type", "application/json; charset=UTF-8")
    w.WriteHeader(http.StatusOK)
    if err := json.NewEncoder(w).Encode(response); err != nil {
        panic(err)
    }
}

func UpdateCandlesController(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    instrumentId := strings.ToUpper(vars["instrumentId"])
    resolution := strings.ToUpper(vars["resolution"])
    resolutionDuration := resolutions[resolution]
    if resolutionDuration == 0 {
        setHttpError(w, 400, "UNKNOWN_RESOLUTION", "Unknown resolution.")
        return
    }

    var candlesRequest CandlesResponse
    body, err := ioutil.ReadAll(io.LimitReader(r.Body, 50*1048576)) // 50MB
    if err != nil {
        panic(err)
    }
    if err := r.Body.Close(); err != nil {
        panic(err)
    }
    if err := json.Unmarshal(body, &candlesRequest); err != nil {
        setHttpError(w, 422, "UNPROCESSABLE_ENTITY", "Unable to unmarshal entity JSON.")
        return
    }

    candles := candlesRequest.Candles
    if candles == nil {
        setHttpError(w, 422, "MISSING_CANDLES_FIELD", "Candles field must be set.")
        return
    } else if len(candles) <= 0 {
        setHttpError(w, 422, "EMPTY_CANDLES_FIELD", "Candles field must contain at least one candle.")
        return
    }

    // Dates must be aligned to enforce consistency
    candles = truncateCandleDates(candles, resolutionDuration)

    // Remove duplicates by date (truncation may have caused duplication)
    candles = removeDuplicateCandles(candles)

    // Work out start and end dates for the response
    startDate, endDate := candlesDateRange(candles)

    instrument := getInstrument(instrumentId, false)
    response := CandlesResponse{Instrument: instrument, Resolution: resolution, StartDate: startDate, EndDate: endDate, Candles: candles}

    // Store candles to the database
    err = persistCandles(dbContext, candles, instrumentId, resolution)
    if err != nil {
        setHttpError(w, 500, "INTERNAL_ERROR", "An internal error occurred while trying to save candles: " + err.Error())
        return
    }

    w.Header().Set("Content-Type", "application/json; charset=UTF-8")
    w.WriteHeader(http.StatusOK)
    if err := json.NewEncoder(w).Encode(response); err != nil {
        panic(err)
    }
}

// TODO: test me
func truncateCandleDates(candles []Candle, resolutionDuration time.Duration) []Candle {
    truncatedCandles := Candles{}
    for _,candle := range candles {
        candle.Time = candle.Time.Truncate(resolutionDuration)
        truncatedCandles = append(truncatedCandles, candle)
    }
    return truncatedCandles
}

// TODO: test me
func candlesDateRange(candles []Candle) (time.Time, time.Time) {
    var startDate time.Time
    var endDate time.Time
    for _,candle := range candles {
        if startDate.IsZero() || candle.Time.Before(startDate) {
            startDate = candle.Time
        }
        if endDate.IsZero() || candle.Time.After(endDate) {
            endDate = candle.Time
        }
    }
    return startDate, endDate
}

// TODO: test me
func removeDuplicateCandles(candles []Candle) []Candle {
    result := []Candle{}
    seen := map[time.Time]Candle{}
    for _, val := range candles {
        if _, ok := seen[val.Time]; !ok {
            result = append(result, val)
            seen[val.Time] = val
        }
    }
    return result
}

type ErrorResponse struct {
    Error Error `json:"error"`
}

type Error struct {
    Code    string `json:"code"`
    Message string `json:"message"`
}

func setHttpError(w http.ResponseWriter, statusCode int, errorCode string, errorMessage string) {
    w.Header().Set("Content-Type", "application/json; charset=UTF-8")
    w.WriteHeader(statusCode)
    response := ErrorResponse{
        Error: Error{Code: errorCode, Message: errorMessage},
    }
    if err := json.NewEncoder(w).Encode(response); err != nil {
        panic(err)
    }
}

