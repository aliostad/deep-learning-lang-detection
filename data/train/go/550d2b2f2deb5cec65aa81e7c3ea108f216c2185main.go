package main

import (
	"dispatch"
	"fmt"

	"github.com/kataras/iris"
	"github.com/kataras/iris/context"
)

func main() {
	app := iris.New()
	manager := dispatch.NewManager(500)
	manager.Setup()

	app.OnErrorCode(iris.StatusNotFound, func(ctx context.Context) {
		ctx.WriteString("not found")
	})

	from := 1
	step := 200
	app.Get("/start", func(ctx context.Context) {
		from = 1
		manager.Start()
		ctx.WriteString("start manager")
	})

	app.Get("/stop", func(ctx context.Context) {
		manager.Stop()
		ctx.WriteString("stop manager")
	})

	app.Get("/process", func(ctx context.Context) {
		if manager.IsReady() {
			for i := from; i < from+step; i++ {
				// two kind of jobs
				displayJob := &dispatch.DisplayJob{Title: "title" + fmt.Sprintln(i)}
				outputJob := dispatch.OutputJob{Output: "Output" + fmt.Sprintln(i)}
				//
				if err := manager.Accept(displayJob); err != nil {
					//
				}
				if err := manager.Accept(outputJob); err != nil {
					//
				}
			}
			from = from + step
			ctx.WriteString("accept jobs")
			return
		}
		ctx.WriteString("manager is not available")
	})

	app.Run(iris.Addr(":8080"))
}
