from smartthings import smartthings

if __name__ == "__main__":
    username = ""
    password = ""
    api = smartthings(username=username, password=password)
    #print api.accounts()

    account_id = ""
    print api.locations(account_id)

    #api.events(account_id, max=1):

    #print api.hubs()
    #hub_id = ""
    #print api.hub(hub_id)
    #print api.hub_events(hub_id)
    #print api.hub_devices(hub_id)

    device_id = "xxx"
    #device_events =  api.device_events(device_id,max=1,source="DEVICE")
    #for e in device_events:
    #  print e

    #print api.device_roles(device_id)

    #print api.device_types()
