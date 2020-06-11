package main

import (
	"highload/myHttp"
)

/*type WriterHeap []*Buffer
func (h WriterHeap) Len() int           { return len(h) }
func (h *WriterHeap) Push(x *Buffer) {
	*h = append(*h, x)
}
func (h *WriterHeap) Pop() *Buffer {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}
var heap = WriterHeap{}*/


func getUserJson(u *User, w *myHttp.Buffer){
	w.WriteString("{\"id\":")
	w.WriteUint(u.id)
	w.WriteString(",\"email\":\"")
	w.WriteString(u.email)
	w.WriteString("\",\"first_name\":\"")
	w.WriteString(u.first_name)
	w.WriteString("\",\"last_name\":\"")
	w.WriteString(u.last_name)
	w.WriteString("\",\"gender\":\"")
	if u.gender {
		w.WriteString("m")
	} else {
		w.WriteString("f")
	}
	w.WriteString("\",\"birth_date\":")
	w.WriteInt(u.birth_date)
	w.WriteString("}")
}

func getLocationJson(l *Location, w *myHttp.Buffer) {
	w.WriteString("{\"id\":")
	w.WriteUint(l.id)
	w.WriteString(",\"place\":\"")
	w.WriteString(l.place)
	w.WriteString("\",\"country\":\"")
	w.WriteString(l.country)
	w.WriteString("\",\"city\":\"")
	w.WriteString(l.city)
	w.WriteString("\",\"distance\":")
	w.WriteInt(l.distance)
	w.WriteString("}")
}

func getVisitJson(v *Visit, w *myHttp.Buffer) {
	w.WriteString("{\"id\":")
	w.WriteUint(v.id)
	w.WriteString(",\"location\":")
	w.WriteUint(v.location.id)
	w.WriteString(",\"user\":")
	w.WriteUint(v.user.id)
	w.WriteString(",\"visited_at\":")
	w.WriteInt(v.visited_at)
	w.WriteString(",\"mark\":")
	w.WriteInt(v.mark)
	w.WriteString("}")
}

func getVisitsJson(v Visits, w *myHttp.Buffer) {
	w.WriteString("{\"visits\":[")
	for i, vv := range v {
		if i > 0 {
			w.WriteString(",{\"mark\":")
		} else {
			w.WriteString("{\"mark\":")
		}
		w.WriteInt(vv.mark)
		w.WriteString(",\"visited_at\":")
		w.WriteInt(vv.visited_at)
		w.WriteString(",\"place\":\"")
		w.WriteString(vv.location.place)
		w.WriteString("\"}")
	}
	w.WriteString("]}")
}

func getAvgJson(avg float64, w *myHttp.Buffer) {
	w.WriteString("{\"avg\":")
	toFixed(&avg, 5)
	w.WriteFloat(avg)
	w.WriteString("}")
}
