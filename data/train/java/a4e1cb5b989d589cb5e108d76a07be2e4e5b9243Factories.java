package cn.feng.thinkInJava.模式.工厂方法设计模式;

import static cn.feng.utils.Print.println;

interface Service {

    void method1();

    void method2();
}

interface ServiceFactory {

    /**
     * 工厂对象将生成接口的某个实现对象
     */
    Service getService();
}

public class Factories {

    /**
     * 理论上代码将完全的与接口的实现分离
     */
    public static void service(ServiceFactory serviceFactory) {
        Service service = serviceFactory.getService();
        service.method1();
        service.method2();

    }

    public static void main(String args[]) {

        service(new ServiceFactoryImplA());
        service(new ServiceFactoryImplB());
    }

}

class ServiceImplA implements Service {

    @Override
    public void method1() {
        println("ServiceImplA method1");
    }

    @Override
    public void method2() {
        println("ServiceImplA method2");

    }

}

class ServiceFactoryImplA implements ServiceFactory {

    @Override
    public Service getService() {

        return new ServiceImplA();
    }

}

class ServiceImplB implements Service {

    @Override
    public void method1() {
        println("ServiceImplB method1");

    }

    @Override
    public void method2() {

        println("ServiceImplB method2");
    }

}

class ServiceFactoryImplB implements ServiceFactory {

    @Override
    public Service getService() {
        return new ServiceImplB();
    }

}
