from purpledefrag.app.controllers.maps import (
	RandomMapController, MapInfoController
)
from purpledefrag.app.controllers.misc import (
	HelpController, TimeController, MeController,
	TomController, ReminderController, HadesController
)
from purpledefrag.app.controllers.records import (
	LoginController, WhoController, FinishLineController,
	RankingsController, RegistrationController,
	LogoutController, BestTimeController, SpeedRankingsController,
	SpeedAwardController, WorldRecordController,
	LoginReminderController, SetPasswordController
)
import purpledefrag.app.g as g


routes = g.routes
#routes.addRule("reminder", ReminderController)
routes.addRule("entrance", LoginReminderController)
#routes.addRule("entrance", HadesController)
routes.addRule("login", LoginController)
routes.addRule("logout", LogoutController)
routes.addRule("register", RegistrationController)
routes.addRule("whoami", WhoController)
routes.addRule("random", RandomMapController)
routes.addRule("findmap", RandomMapController)
routes.addRule("h", HelpController)
routes.addRule("time", TimeController)
routes.addRule("me", MeController)
routes.addRule("mapinfo", MapInfoController)
routes.addRule("clienttimerstop", FinishLineController)
routes.addRule("clientspeedaward", SpeedAwardController)
routes.addRule("top", RankingsController)
routes.addRule("topspeed", SpeedRankingsController)
routes.addRule("mytop", BestTimeController)
routes.addRule("mypr", BestTimeController)
routes.addRule("pr", RankingsController)
routes.addRule("hip", TomController)
routes.addRule("wr", WorldRecordController)
routes.addRule("mdd", WorldRecordController)
routes.addRule("setpass", SetPasswordController)
routes.addRule("trouve", RandomMapController)


'''routes.addRule("newmaps", newmaps)
routes.addRule("request", maprequest)
routes.addRule("coolmap", upvote)
routes.addRule("crapmap", downvote)
routes.addRule("lastmap", lastmap)

def tom(request):
	from purpledefrag import BunnyResponse
	return BunnyResponse("^6Hippeh is piece full. Bunny luf hippeh.")

routes.addRule("tom", tom)

def me(request):
	from purple import ChatResponse
	return ChatResponse("^2^ --- that guy likes to talk in third person.")

routes.addRule("me", me)'''
