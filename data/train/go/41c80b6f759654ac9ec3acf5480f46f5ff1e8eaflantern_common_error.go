package main

import "io"
import "fmt"
import "net/http"



func _errp( w http.ResponseWriter ) {

  io.WriteString(w, "{\n")
  io.WriteString(w, "  \"Type\":\"failure\", \"Message\":\"parse failure\"\n")
  io.WriteString(w, "}")

}

func _errm( w http.ResponseWriter ) {

  io.WriteString(w, "{\n")
  io.WriteString(w, "  \"Type\":\"failure\", \"Message\":\"max elements exceeded\"\n")
  io.WriteString(w, "}")

}


func _erre( w http.ResponseWriter, e error ) {

  io.WriteString(w, "{\n")
  io.WriteString(w, fmt.Sprintf("  \"Type\":\"failure\", \"Message\":\"%v\"\n", e) )
  io.WriteString(w, "}")

}


