package signaling

import "github.com/go-martini/martini"
import "github.com/martini-contrib/cors"

var MembersBroker *Broker

func App() *martini.ClassicMartini {
	m := martini.Classic()
	// Make a new Broker instance
	MembersBroker = NewBroker()
	m.Map(MembersBroker)

	m.Get("/", func() string {
		return "Sup"
	})
	m.Use(cors.Allow(&cors.Options{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"POST", "OPTIONS"},
		AllowHeaders: []string{"Origin", "Content-type"},
	}))

	m.Post("/update/:room", UpdateHandler)
	m.Post("/failure", FailureHandler)

	m.Options("/update/:room", OptionsHandler)

	m.Get("/stream/:room", ClientStream)

	return m
}
