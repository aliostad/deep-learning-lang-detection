from django.http import HttpResponseRedirect, HttpResponse
from django.contrib.auth.decorators import login_required
from pickup_finder.controllers import *

def home(request):
    controller = CreateUserController(request)    
    return controller.create_user() #because a redirect is required, we break the normal pattern here

##PORTALS
@login_required
def dashboard(request):
    controller = DashboardController(request)    
    return controller.dashboard()

@login_required
def create_game(request):
    controller = CreateGameController(request)  
    return controller.create_game()

@login_required
def view_games(request):
    controller = ViewGamesController(request)
    return controller.view_games()

@login_required
def help(request):
    controller = HelpController(request)    
    return controller.help()

@login_required
def explore(request):
    controller = ExploreController(request)    
    return controller.explore()

def game_rsvp(request, game=None):
    controller = GameRsvpController(request, Game.for_id(game))
    return controller.rsvp()

def game_rsvp_thanks(request, game=None):
    controller = GameRsvpThanksController(request, Game.for_id(game))
    return controller.render()

@login_required
def logout_user(request):
    from django.contrib.auth import logout    
    
    logout(request)
    return HttpResponseRedirect(reverse('pickup_finder.views.home'))

##MOBILE
def mobile_home(request):
    controller = CreateUserController(request, mobile=True)
    return controller.create_user()

def mobile_view_games(request):
    controller = MobileViewGamesController(request)
    return controller.render()

def mobile_create_game(request):
    controller = CreateGameController(request, mobile=True)
    return controller.create_game()

def mobile_game_details(request, game=None):
    controller = MobileGameDetailsController(request, Game.for_id(game))
    return controller.render()

def mobile_game_rsvp(request, game=None):
    controller = GameRsvpController(request, Game.for_id(game), mobile=True)
    return controller.rsvp()

def mobile_game_rsvp_thanks(request, game=None):
    controller = GameRsvpThanksController(request, Game.for_id(game), mobile=True)
    return controller.render()

##AJAX
def ajax_seen_notifications(request):
    Notification.mark_as_seen(request.user)
    return HttpResponse()
    
    
def get_lineup(request):
    import json

    game = Game.for_id(request.GET.get('game_id', None))     
    player_games = PlayerGame.objects.filter(game=game).all()    
    result = [{'status' : pg.verbose_status, 'name' : pg.player.name} for pg in player_games]    
    return HttpResponse(json.dumps(result))
    



    
