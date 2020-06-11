module.exports = {
	"get /latest/:page": "PostController.latest",

	"get /popular/:page": "PostController.popular",
	
	"get /popular": "PostController.popular",

	"get /latest": "PostController.latest",

	"get /details/:id": "PostController.details",

	"get /byauthor/:username/:page": "PostController.byauthor",

	"get /byauthor/:username": "PostController.byauthor",

	"get /tapePersonal/:page": "PostController.tapePersonal",

	"get /myfeed": "PostController.tapePersonal",

	"get /myfeed/:page": "PostController.tapePersonal"

};