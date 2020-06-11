package main

import (
	"cdnboss-middle/modules/dispatch"

	"github.com/gin-gonic/gin"
)

var DB = make(map[string]string)

func main() {
	// Disable Console Color
	// gin.DisableConsoleColor()
	r := gin.Default()
	// // Ping test
	// r.GET("/ping", func(c *gin.Context) {
	// 	c.String(200, "hello wolrd")
	// })
	rg1 := r.Group("/api/v1/admin")
	dispatch.Line(rg1)
	dispatch.View(rg1)
	dispatch.Record(rg1)

	// rg2 := r.Group("/common")
	// common.Platform(rg2)

	// Listen and Server in 0.0.0.0:6060
	r.Run(":6060")
}
