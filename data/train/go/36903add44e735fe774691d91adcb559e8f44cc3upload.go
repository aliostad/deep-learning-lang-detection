package cloudvisionapi

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
)

func Upload(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		w.WriteHeader(405)
		return
	}

	file, handler, err := r.FormFile("image")
	if err != nil {
		w.WriteHeader(500)
		w.Write([]byte(err.Error()))
		return
	}
	defer file.Close()

	img, err := ioutil.ReadAll(file)

	if err != nil {
		w.WriteHeader(500)
		w.Write([]byte(err.Error()))
		return
	}

	if len(img) == 0 {
		w.WriteHeader(500)
		w.Write([]byte("could not read image"))
		return
	}

	resp, err := detect(img, handler.Filename)

	if err != nil {
		w.WriteHeader(500)
		w.Write([]byte(err.Error()))
		return
	}

	data, err := json.Marshal(resp)

	if err != nil {
		w.WriteHeader(500)
		w.Write([]byte(err.Error()))
		return
	}

	w.Write(data)
}
