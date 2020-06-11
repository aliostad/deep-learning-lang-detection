package de.slikey.batch.network.client;

import de.slikey.batch.network.protocol.PacketHandler;

/**
 * @author Kevin
 * @since 08.09.2015
 */
public class ClientPacketHandler<Client extends NIOClient> extends PacketHandler {

    private final ClientConnectionHandler<Client> connectionHandler;

    public ClientPacketHandler(ClientConnectionHandler<Client> connectionHandler) {
        this.connectionHandler = connectionHandler;
    }

    public ClientConnectionHandler<Client> getConnectionHandler() {
        return connectionHandler;
    }

    public Client getClient() {
        return connectionHandler.getInitializer().getClient();
    }

}
