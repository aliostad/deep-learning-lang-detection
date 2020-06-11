package actors

import (
	"compress/gzip"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
)

type Disk struct {
	env  EnvInterface
	path string
}

func NewDiskStorage(path string, env EnvInterface) (*Disk, error) {
	disk := &Disk{
		path: path,
		env:  env,
	}

	return disk, nil
}

func (it *Disk) ListFiles() ([]string, error) {
	var result = []string{}

	var fileInfos, err = ioutil.ReadDir(it.path)
	if err != nil {
		return []string{}, it.env.ErrorDispatch(err)
	}

	for _, fileInfo := range fileInfos {
		if !fileInfo.IsDir() {
			result = append(result, fileInfo.Name())
		}
	}

	return result, nil
}

func (it *Disk) Archive(fileName string) error {
	archive := func() error {
		srcFile, err := os.Open(it.getFullFileName(fileName))
		if err != nil {
			return it.env.ErrorDispatch(err)
		}
		defer srcFile.Close()

		tgtFile, err := os.OpenFile(it.getFullFileName(fileName+".gz"), os.O_CREATE|os.O_WRONLY, 0660)
		if err != nil {
			return it.env.ErrorDispatch(err)
		}
		defer tgtFile.Close()

		archiver, err := gzip.NewWriterLevel(tgtFile, gzip.BestCompression)
		if err != nil {
			return it.env.ErrorDispatch(err)
		}

		_, err = io.Copy(archiver, srcFile)
		if err != nil {
			return it.env.ErrorDispatch(err)
		}

		return archiver.Close()
	}

	if err := archive(); err != nil {
		return it.env.ErrorDispatch(err)
	}

	if err := os.Remove(it.getFullFileName(fileName)); err != nil {
		it.env.ErrorDispatch(err)
	}

	return nil
}

func (it *Disk) GetReadCloser(fileName string) (io.ReadCloser, error) {
	var file, err = os.Open(it.getFullFileName(fileName))
	if err != nil {
		return nil, it.env.ErrorDispatch(err)
	}

	return file, nil
}

func (s *Disk) getFullFileName(fileName string) string {
	return filepath.Join(s.path, fileName)
}
