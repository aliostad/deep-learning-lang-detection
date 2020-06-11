package rabbit

import (
	"strconv"
	"time"

	"github.com/smartystreets/messaging"
	"github.com/streadway/amqp"
)

func fromAMQPDelivery(delivery amqp.Delivery, channel Acknowledger) messaging.Delivery {
	return messaging.Delivery{
		SourceID:        parseUint64(delivery.AppId),
		MessageID:       parseUint64(delivery.MessageId),
		MessageType:     delivery.Type,
		ContentType:     delivery.ContentType,
		ContentEncoding: delivery.ContentEncoding,
		Timestamp:       delivery.Timestamp,
		Payload:         delivery.Body,
		Upstream:        delivery,
		Receipt:         newReceipt(channel, delivery.DeliveryTag),
	}
}
func parseUint64(value string) uint64 {
	parsed, _ := strconv.ParseUint(value, 10, 64)
	return parsed
}

func toAMQPDispatch(dispatch messaging.Dispatch, now time.Time) amqp.Publishing {
	if dispatch.Timestamp == zeroTime {
		dispatch.Timestamp = now
	}

	return amqp.Publishing{
		AppId:           strconv.FormatUint(dispatch.SourceID, base10),
		MessageId:       strconv.FormatUint(dispatch.MessageID, base10),
		Type:            dispatch.MessageType,
		ContentType:     dispatch.ContentType,
		ContentEncoding: dispatch.ContentEncoding,
		Timestamp:       dispatch.Timestamp,
		Expiration:      computeExpiration(dispatch.Expiration),
		DeliveryMode:    computePersistence(dispatch.Durable),
		Body:            dispatch.Payload,
	}
}
func computeExpiration(expiration time.Duration) string {
	if expiration == 0 {
		return ""
	} else if seconds := expiration.Seconds(); seconds <= 0 {
		return "0"
	} else {
		return strconv.FormatUint(uint64(seconds), base10)
	}
}
func computePersistence(durable bool) uint8 {
	if durable {
		return amqp.Persistent
	}

	return amqp.Transient
}

var zeroTime = time.Time{}

const base10 = 10
