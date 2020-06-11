package messaging

type SerializationWriter struct {
	writer          Writer
	commitWriter    CommitWriter
	serializer      Serializer
	discovery       TypeDiscovery
	contentType     string
	contentEncoding string
}

func NewSerializationWriter(inner Writer, serializer Serializer, discovery TypeDiscovery) *SerializationWriter {
	commitWriter, _ := inner.(CommitWriter)
	return &SerializationWriter{
		writer:          inner,
		commitWriter:    commitWriter,
		serializer:      serializer,
		discovery:       discovery,
		contentType:     serializer.ContentType(),
		contentEncoding: serializer.ContentEncoding(),
	}
}

func (this *SerializationWriter) Write(dispatch Dispatch) error {
	if len(dispatch.Payload) > 0 && len(dispatch.MessageType) > 0 {
		return this.writer.Write(dispatch) // already have a payload a message type, forward to inner
	}

	if len(dispatch.Payload) == 0 && dispatch.Message == nil {
		return EmptyDispatchError // no payload and no message, this is a total fail
	}

	if dispatch.Message == nil && len(dispatch.MessageType) == 0 {
		return MessageTypeDiscoveryError // no message type and no way to get it
	}

	if payload, err := this.serializer.Serialize(dispatch.Message); err != nil {
		return err // serialization failed
	} else {
		dispatch.ContentType = this.contentType
		dispatch.ContentEncoding = this.contentEncoding
		dispatch.Payload = payload
	}

	if len(dispatch.MessageType) > 0 {
		return this.writer.Write(dispatch) // message type already exists, no need to discover
	}

	messageType, err := this.discovery.Discover(dispatch.Message)
	if err != nil {
		return err
	}

	dispatch.MessageType = messageType
	return this.writer.Write(dispatch)
}

func (this *SerializationWriter) Commit() error {
	if this.commitWriter == nil {
		return nil
	}

	return this.commitWriter.Commit()
}

func (this *SerializationWriter) Close() {
	this.writer.Close()
}
