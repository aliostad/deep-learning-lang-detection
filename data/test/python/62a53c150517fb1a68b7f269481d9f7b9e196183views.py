from django.http import HttpResponse

from clients.models import Client
from unifi_control.models import UnifiController

from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt

# @login_required
@csrf_exempt
def create_site(request):
	site_id = request.POST['unifi_site_id']
	site_name = request.POST['unifi_site_name']
	
	controller = UnifiController.objects.get(pk = request.POST['unifi_controller'])
	controller = controller.controller()
	
	return HttpResponse(controller.add_site(site_id, site_name))

@csrf_exempt
def set_general_settings(request):
	site_id = request.POST['unifi_site_id']
	
	controller = UnifiController.objects.get(pk = request.POST['unifi_controller'])
	controller = controller.controller(site_id)
	
	controller.set_site_auto_upgrade(True)
	controller.set_site_timezone('Europe/Amsterdam')
	
	return HttpResponse(True)
	
@csrf_exempt
def set_guest_portal(request):
	site_id = request.POST['unifi_site_id']
	
	controller = UnifiController.objects.get(pk = request.POST['unifi_controller'])
	controller = controller.controller(site_id)
	
	return HttpResponse(controller.set_site_guest_access())
	
@csrf_exempt
def add_wlans(request):
	site_id = request.POST['unifi_site_id']
	
	ssid = request.POST['ssid']
	
	ssid_private = request.POST['ssid_private']
	password_private = request.POST['password_private']
	
	controller = UnifiController.objects.get(pk = request.POST['unifi_controller'])
	controller = controller.controller(site_id)
	
	wlangroup_id = controller.get_wlan_groups()[0]['_id']
	usergroup_id = controller.get_user_groups()[0]['_id']
	
	controller.add_wlan(ssid, wlangroup_id, usergroup_id)
	controller.add_wlan(ssid_private, wlangroup_id, usergroup_id, password_private, False)
	
	return HttpResponse(True)