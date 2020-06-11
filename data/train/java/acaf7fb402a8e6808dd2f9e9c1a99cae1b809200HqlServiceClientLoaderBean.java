package org.tools.hqlbuilder.client;

public class HqlServiceClientLoaderBean implements HqlServiceClientLoader {
    protected HqlServiceClient hqlServiceClient;

    public HqlServiceClientLoaderBean() {
        super();
    }

    public HqlServiceClientLoaderBean(HqlServiceClient hqlServiceClient) {
        this.hqlServiceClient = hqlServiceClient;
    }

    @Override
    public HqlServiceClient getHqlServiceClient() {
        return this.hqlServiceClient;
    }

    public void setHqlServiceClient(HqlServiceClient hqlServiceClient) {
        this.hqlServiceClient = hqlServiceClient;
    }
}
