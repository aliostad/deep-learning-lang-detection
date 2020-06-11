package com.yichang.kaku.obj;

import java.io.Serializable;

public class ShopService2Obj implements Serializable {

    private String name_service;
    private String remark_service;
    private String price_service;

    public String getName_service() {
        return name_service;
    }

    public void setName_service(String name_service) {
        this.name_service = name_service;
    }

    public String getRemark_service() {
        return remark_service;
    }

    public void setRemark_service(String remark_service) {
        this.remark_service = remark_service;
    }

    public String getPrice_service() {
        return price_service;
    }

    public void setPrice_service(String price_service) {
        this.price_service = price_service;
    }

    @Override
    public String toString() {
        return "ShopService2Obj{" +
                "name_service='" + name_service + '\'' +
                ", remark_service='" + remark_service + '\'' +
                ", price_service='" + price_service + '\'' +
                '}';
    }
}
