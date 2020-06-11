__author__ = 'dmarkey'


class ControlBase(object):
    @staticmethod
    def init(controller):
        pass

    @staticmethod
    def on_beacon(controller):
        pass

    @staticmethod
    def get_extra_items(controller):
        return None


class Sockets(ControlBase):
    @staticmethod
    def init(controller, number_of_sockets=4):
        from .models import Socket

        for i in range(1, number_of_sockets + 1):
            Socket(controller=controller, number=i).save()

    @staticmethod
    def event(controller, event):
        if event['event'] == "BEACON":
            from .models import Socket
            for s in Socket.objects.filter(controller=controller):
                s.send_state()


class Temperature(ControlBase):
    @staticmethod
    def init(controller):
        pass

    @staticmethod
    def event(controller, event):
        from .models import TemperatureRecord
        if event['event'] == "Temp":
            zone = Temperature.get_zone(controller, event)
            TemperatureRecord(temperature=event['value'], zone=zone).save()

    @staticmethod
    def get_extra_items(controller):
        from .models import TemperatureRecord
        try:
            return TemperatureRecord.objects.filter(zone__controller=controller).order_by("-pk").values()[0]
        except IndexError:
            return None

    @staticmethod
    def get_zone(controller, event):
        from .models import TemperatureZone
        zone = event.get("zone", "main")
        (zone_obj, _) = TemperatureZone.objects.get_or_create(controller=controller, name=zone)
        return zone_obj


class RemoteControl(ControlBase):
    @staticmethod
    def init(controller):
        pass

    @staticmethod
    def event(controller, event):
        print("RC Event")
        from .models import RemoteEvent, RegisteredRemoteEvent
        if event['event'] == "IRIN":
            RemoteEvent(encoding=event['encoding'], value=event['code'], controller=controller).save()
            for x in RegisteredRemoteEvent.objects.filter(value=event['code'], encoding=event['encoding']):
                x.execute()
        elif event['event'] == "BEACON":
            RemoteEvent.objects.filter(controller=controller).delete()


CONTROL_CLASSES = {"Sockets": Sockets,
                   "Temperature": Temperature, "RemoteControl": RemoteControl}
