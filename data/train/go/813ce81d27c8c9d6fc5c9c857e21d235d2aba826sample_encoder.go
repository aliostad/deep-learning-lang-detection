package sample

import (
	"io"

	"github.com/benbjohnson/megajson/writer"
)

type MediaJSONEncoder struct {
	w *writer.Writer
}

func NewMediaJSONEncoder(w io.Writer) *MediaJSONEncoder {
	return &MediaJSONEncoder{w: writer.NewWriter(w)}
}

func NewMediaJSONRawEncoder(w *writer.Writer) *MediaJSONEncoder {
	return &MediaJSONEncoder{w: w}
}

func (e *MediaJSONEncoder) Encode(v *Media) error {
	if err := e.RawEncode(v); err != nil {
		return err
	}
	if err := e.w.Flush(); err != nil {
		return err
	}
	return nil
}

func (e *MediaJSONEncoder) RawEncode(v *Media) error {
	if v == nil {
		return e.w.WriteNull()
	}

	if err := e.w.WriteByte('{'); err != nil {
		return err
	}

	// Write key and colon.
	if err := e.w.WriteString("display_url"); err != nil {
		return err
	}
	if err := e.w.WriteByte(':'); err != nil {
		return err
	}

	// Write value.
	{
		v := v.DisplayURL

		if err := e.w.WriteString(v); err != nil {
			return err
		}

	}

	if err := e.w.WriteByte(','); err != nil {
		return err
	}

	// Write key and colon.
	if err := e.w.WriteString("expanded_url"); err != nil {
		return err
	}
	if err := e.w.WriteByte(':'); err != nil {
		return err
	}

	// Write value.
	{
		v := v.ExpandedURL

		if err := e.w.WriteString(v); err != nil {
			return err
		}

	}

	if err := e.w.WriteByte(','); err != nil {
		return err
	}

	// Write key and colon.
	if err := e.w.WriteString("id"); err != nil {
		return err
	}
	if err := e.w.WriteByte(':'); err != nil {
		return err
	}

	// Write value.
	{
		v := v.ID

		if err := e.w.WriteInt(v); err != nil {
			return err
		}

	}

	if err := e.w.WriteByte(','); err != nil {
		return err
	}

	// Write key and colon.
	if err := e.w.WriteString("id_str"); err != nil {
		return err
	}
	if err := e.w.WriteByte(':'); err != nil {
		return err
	}

	// Write value.
	{
		v := v.IDStr

		if err := e.w.WriteString(v); err != nil {
			return err
		}

	}

	if err := e.w.WriteByte(','); err != nil {
		return err
	}

	// Write key and colon.
	if err := e.w.WriteString("media_url"); err != nil {
		return err
	}
	if err := e.w.WriteByte(':'); err != nil {
		return err
	}

	// Write value.
	{
		v := v.MediaURL

		if err := e.w.WriteString(v); err != nil {
			return err
		}

	}

	if err := e.w.WriteByte(','); err != nil {
		return err
	}

	// Write key and colon.
	if err := e.w.WriteString("media_url_https"); err != nil {
		return err
	}
	if err := e.w.WriteByte(':'); err != nil {
		return err
	}

	// Write value.
	{
		v := v.MediaURLHTTPS

		if err := e.w.WriteString(v); err != nil {
			return err
		}

	}

	if err := e.w.WriteByte(','); err != nil {
		return err
	}

	// Write key and colon.
	if err := e.w.WriteString("type"); err != nil {
		return err
	}
	if err := e.w.WriteByte(':'); err != nil {
		return err
	}

	// Write value.
	{
		v := v.Type

		if err := e.w.WriteString(v); err != nil {
			return err
		}

	}

	if err := e.w.WriteByte(','); err != nil {
		return err
	}

	// Write key and colon.
	if err := e.w.WriteString("url"); err != nil {
		return err
	}
	if err := e.w.WriteByte(':'); err != nil {
		return err
	}

	// Write value.
	{
		v := v.URL

		if err := e.w.WriteString(v); err != nil {
			return err
		}

	}

	if err := e.w.WriteByte('}'); err != nil {
		return err
	}
	return nil
}
