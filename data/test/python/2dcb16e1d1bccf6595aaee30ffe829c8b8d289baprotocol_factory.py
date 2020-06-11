from twisted.internet.protocol import Factory

class ProtocolFactory(Factory):
    def __init__(self, TransportProtocol, packing, client_controller_factory, authentication_controller_factory):
        self._TransportProtocol = TransportProtocol
        self._packing = packing
        self._client_controller_factory = client_controller_factory
        self._authentication_controller_factory = authentication_controller_factory

    def buildProtocol(self, addr):
        protocol = self._TransportProtocol(self._packing)
        authentication_controller = self._authentication_controller_factory.build_authentication_controller(protocol)
        controller = self._client_controller_factory.build(addr, protocol, authentication_controller)

        protocol.controller = controller
        protocol.factory = self

        return protocol
