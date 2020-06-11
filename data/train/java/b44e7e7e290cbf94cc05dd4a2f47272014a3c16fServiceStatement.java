package no.gfix.crawler.domain.service;

public class ServiceStatement {
    private final String statement;
    private final ServiceMethod serviceMethod;

    private ServiceStatement(String statement, ServiceMethod serviceMethod) {
        this.statement = statement;
        this.serviceMethod = serviceMethod;
    }

    public static ServiceStatement create(String statement, ServiceMethod serviceMethod) {
        return new ServiceStatement(statement, serviceMethod);
    }

    public String getStatement() {
        return statement;
    }

    public ServiceMethod getServiceMethod() {
        return serviceMethod;
    }
}
