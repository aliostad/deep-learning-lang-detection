package com.zhenhui.demo.Study.staticproxy;

@SuppressWarnings("unused")
public class StaticProxy {
    static class Client {
        public static void main(String[] args) {

            Service service = ServiceFactory.getService();

            System.out.println(service.service());

        }
    }
}

interface Service {
    String service();
}

class ServiceFactory {
    public static Service getService() {
        return new ServiceProxy(new ServiceImpl());
    }
}

class ServiceImpl implements Service {
    @Override
    public String service() {
        return "hello, static proxy!";
    }
}

class ServiceProxy implements Service {
    private Service subject;

    public ServiceProxy(Service service) {
        this.subject = service;
    }
    @Override
    public String service() {
        return subject.service();
    }
}
