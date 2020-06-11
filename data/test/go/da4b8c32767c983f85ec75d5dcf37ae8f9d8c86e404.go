package controller

import (
	"fmt"
	"net/http"
)

func gg(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("\"" + r.URL.String() + "\" What The Fuck You Write The Url !"))
}

func NotMatch(w http.ResponseWriter, r *http.Request) {
	fmt.Print("getnomarth" + r.URL.String())
	w.Write([]byte("\"" + r.URL.String() + "\" What The Fuck You Write The Url !" + "\n"))
	w.Write([]byte("\n\n"))
	w.Write([]byte("[HEADER]\n\n"))
	for k, v := range r.Header {
		var i = k + ":" + v[0] + "\n"
		w.Write([]byte(i))
	}
	w.Write([]byte("\n\n"))
	r.Write(w)
	// fmt.Println(r.Header)
	// w.Write(r.Body)
}
