from pox.core import core

from utils import ControllerMixin, launch, Global

log = core.getLogger()


class HubController(ControllerMixin):
    def __init__(self, *args, **kwargs):
        super(HubController, self).__init__(*args, **kwargs)
        self.handle_packet = self.act_like_hub
        log.debug("Using HubController")

    def act_like_hub(self, packet, packet_in):
        """
        Implement hub-like behavior -- send all packets to all ports besides
        the input port.
        """
        self.flood(packet, packet_in)

Global.controller = HubController
