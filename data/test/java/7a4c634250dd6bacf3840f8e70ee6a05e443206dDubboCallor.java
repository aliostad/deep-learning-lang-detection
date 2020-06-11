package com.xiaohao.dubbodemo.consumer;

import com.xiaohao.dubbodemo.service.IDubboDemoService;
import com.xiaohao.dubbodemo.service.IDubboHessianDemoService;
import com.xiaohao.dubbodemo.service.IDubboRmiDemoService;
import com.xiaohao.dubbodemo.service.IDubboWebServiceDemoService;

/**
 * Created by xiaohao on 2014/8/1.
 *
 */
public class DubboCallor {

    IDubboDemoService service;

    IDubboHessianDemoService hessianDemoService;

    IDubboRmiDemoService rmiDemoService;

    IDubboWebServiceDemoService webServiceDemoService;


    public void test(){
        System.out.println("####################################################################################################");
        System.out.println();
        String result =service.sayHello("xiaopang");
        System.out.println(result);
        String rmiResult =rmiDemoService.rmiSayHello("xiaohaohao");
        System.out.println(rmiResult);
        String hasseinResult =hessianDemoService.hasseinSayHello("xiaohaolilili");
        System.out.println(hasseinResult);
        System.out.println();
        System.out.println("####################################################################################################");
       // String webService = webServiceDemoService.webServiceSayHello("web Service");
       // System.out.println(webService);
    }

    public IDubboDemoService getService() {
        return service;
    }

    public void setService(IDubboDemoService service) {
        this.service = service;
    }

    public IDubboHessianDemoService getHessianDemoService() {
        return hessianDemoService;
    }

    public void setHessianDemoService(IDubboHessianDemoService hessianDemoService) {
        this.hessianDemoService = hessianDemoService;
    }

    public IDubboRmiDemoService getRmiDemoService() {
        return rmiDemoService;
    }

    public void setRmiDemoService(IDubboRmiDemoService rmiDemoService) {
        this.rmiDemoService = rmiDemoService;
    }

    public IDubboWebServiceDemoService getWebServiceDemoService() {
        return webServiceDemoService;
    }

    public void setWebServiceDemoService(IDubboWebServiceDemoService webServiceDemoService) {
        this.webServiceDemoService = webServiceDemoService;
    }
}
