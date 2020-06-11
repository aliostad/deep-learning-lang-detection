package service

import "net/http"

type Route struct {
	Name        string
	Method      string
	Pattern     string
	HandlerFunc http.HandlerFunc
}

type Routes []Route

var RoutesArray = Routes{
	Route{
		"Index",
		"GET",
		"/",
		Index,
	},
	Route{
		"InsertVista",
		"POST",
		"/insertVista",
		InsertVista,
	},
	Route{
		"SelectManager",
		"GET",
		"/selectManager",
		SelectManager,
	},
	Route{
		"DeleteManager",
		"GET",
		"/deleteManager",
		DeleteManager,
	},
	Route{
		"InsertManager",
		"GET",
		"/insertManager",
		InsertManager,
	},
}
