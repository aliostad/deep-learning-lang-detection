package cloud_init_utils

import (
	"bytes"
	"encoding/base64"
	"errors"

	"github.com/twitchscience/config_distributor/datasource"
)

type CloudFileEncodings int

var (
	Base64Encoding CloudFileEncodings = CloudFileEncodings(0)
	GzipEncoding   CloudFileEncodings = CloudFileEncodings(1)
)

var CloudFileEncodingsTranslator = []string{
	"b64",
	"gzip",
}

type WriteFilesHelper struct {
	FilesToWrite []*FileToWrite
}

type FileToWrite struct {
	File        []byte
	Encoding    CloudFileEncodings
	Dir         string
	Permissions string
	Owner       string
}

const CloudInitFileWriterHeader = `#cloud-config
#
#
write_files:
`

func UnmarshalWriteFiles(resources []*datasource.Resource, encoder *base64.Encoding) *WriteFilesHelper {
	output := make([]*FileToWrite, len(resources))
	for idx, resource := range resources {
		output[idx] = &FileToWrite{
			File:        []byte(encoder.EncodeToString([]byte(resource.Value))),
			Encoding:    Base64Encoding,
			Dir:         resource.Path,
			Permissions: resource.Permissions,
			Owner:       resource.Owner,
		}
	}
	return &WriteFilesHelper{
		FilesToWrite: output,
	}
}

func (w *WriteFilesHelper) Marshal() ([]byte, error) {
	output := bytes.NewBufferString(CloudInitFileWriterHeader)

	for _, f := range w.FilesToWrite {
		if int(f.Encoding) >= len(CloudFileEncodingsTranslator) {
			return nil, errors.New("invalid encoding")
		}

		output.WriteString("-   encoding: ")
		output.WriteString(CloudFileEncodingsTranslator[int(f.Encoding)])
		output.WriteString("\n")

		output.WriteString("    content: ")
		output.Write(f.File)
		output.WriteString("\n")

		output.WriteString("    owner: ")
		output.WriteString(f.Owner)
		output.WriteString("\n")

		output.WriteString("    path: ")
		output.WriteString(f.Dir)
		output.WriteString("\n")

		output.WriteString("    permissions: '")
		output.WriteString(f.Permissions)
		output.WriteString("'\n")
	}

	output.WriteString("\n")
	return output.Bytes(), nil
}
