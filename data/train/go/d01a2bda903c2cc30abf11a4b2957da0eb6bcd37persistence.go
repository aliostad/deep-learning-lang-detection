package main

import (
    "log"
    "time"
    "errors"
    // "database/sql"
    // _ "github.com/couchbase/go_n1ql"
    // couchbase "github.com/couchbase/go-couchbase"
    "gopkg.in/couchbase/gocb.v1"
)

type DBContext struct {
	Cluster *gocb.Cluster
	Bucket *gocb.Bucket
}

// TODO: does cb reconnect on error?

func dbConnect(host string, bucketName string, password string) (DBContext, error) {
	log.Printf("Connecting to database: %s@%s", bucketName, host)
	cluster, err := gocb.Connect(host)
	if err != nil {
		return DBContext{}, errors.New("unable to connect: " + err.Error())
	}
	bucket, err := cluster.OpenBucket(bucketName, password)
	if err != nil {
		return DBContext{}, errors.New("unable to open bucket: " + err.Error())
	}
	return DBContext{
		Cluster: cluster,
		Bucket: bucket,
	}, nil
}

// Wrapper around Candle which includes resolution and instrument, to support indexing and searching
type DBCandle struct {
	Type        string  `json:"type"`
	Candle      Candle  `json:"candle"`
	Instrument  string  `json:"instrument"`
	Resolution  string  `json:"resolution"`
}

// TODO: test me
func getPath(instrument string, resolution string, candleTime time.Time) string {
	return "candle:" + instrument + ":" + resolution + ":" + candleTime.Format(time.RFC3339)
}

func persistCandles(dbContext DBContext, candles Candles, instrument string, resolution string) error {
	var upsertOps []gocb.BulkOp
	for _,candle := range candles {
		candle.Time = candle.Time.UTC()
		path := getPath(instrument, resolution, candle.Time)
		dbCandle := DBCandle{
			Type: "candle",
			Candle: candle,
			Instrument: instrument,
			Resolution: resolution,
		}
		upsertOps = append(upsertOps, &gocb.UpsertOp{Key: path, Value: dbCandle, Expiry: 0})
	}

	return dbContext.Bucket.Do(upsertOps)
}

func getCandles(dbContext DBContext, instrument string, resolution string, resolutionDuration time.Duration, startDate time.Time, endDate time.Time) (Candles, error) {
	startDate = startDate.UTC()
	endDate = endDate.UTC()

	var candles = Candles{}
	var itemsGet []gocb.BulkOp

	var candleTime time.Time = startDate
	for !candleTime.After(endDate) {
		path := getPath(instrument, resolution, candleTime)
		candleTime = candleTime.Add(resolutionDuration)
		itemsGet = append(itemsGet, &gocb.GetOp{Key: path, Value: &DBCandle{}})
	}
	log.Printf("Attempting to retrieve %d candles", len(itemsGet))

	batchSize := 5000 // can't handle much more than 5000 in bulk, although seems intermittent

	for i := 0; i < len(itemsGet); i += batchSize {
	    itemsGetBatch := itemsGet[i:min(i+batchSize, len(itemsGet))]
		err := dbContext.Bucket.Do(itemsGetBatch)
		if err != nil {
			return candles, errors.New("unable to retrieve candles: " + err.Error())
		}

		for i := 0; i < len(itemsGetBatch); i++ {
			result := itemsGetBatch[i].(*gocb.GetOp)
			if result.Err == nil {
				candles = append(candles, (*result.Value.(*DBCandle)).Candle)
			} else if result.Err.Error() != "Key not found." {
				return candles, errors.New("unable to retrieve candle: " + result.Err.Error())
			}
		}
	}

	return candles, nil
}

func min(a, b int) int {
    if a <= b {
        return a
    }
    return b
}

