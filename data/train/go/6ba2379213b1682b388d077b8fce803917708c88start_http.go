package web

import (
//	"my_web/active"
//	"my_web/cdk"
	"my_web/conf"
//	"my_web/platform"
	"my_web/user"
	"my_web/web/route"
	"log"
	"net/http"
	"strconv"
)

func StartHttp() {
/*
	if !platform.Load() {
		log.Println("load platform failed")
		return
	}
	if !player.LoadNotice() || !player.LoadCompensation() {
		log.Println("load player failed")
		return
	}
	if !cdk.LoadCDK() {
		log.Println("load cdk failed")
		return
	}
	if !active.LoadActiveConfig() {
		log.Println("load active failed")
		return
	}
*/
	if !user.LoadUser() {
		log.Println("load user failed")
		return
	}
	route.StaticRoute()
	route.DynamicRoute()
	err := http.ListenAndServe(":"+strconv.Itoa(conf.Port), nil)
	if err != nil {
		log.Println(err)
	}
	log.Println("http started at ", conf.Port)
}
