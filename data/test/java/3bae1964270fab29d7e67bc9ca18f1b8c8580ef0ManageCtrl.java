/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.myapp.erp.manage;

import com.myapp.erp.user.Member;

/**
 *
 * @author yongbam
 */
public class ManageCtrl{
    private String Name;
    private String Type;
    
    private ManageSrv manageSrv;
    private ManageSrvFactory factory;

    public ManageCtrl() {
    }
    
    public void show(Member member){
        manageSrv = factory.show(member);
        manageSrv.show();
    }

    public ManageSrv getManageSrv() {
        return manageSrv;
    }

    public void setManageSrv(ManageSrv manageSrv) {
        this.manageSrv = manageSrv;
    }

    public ManageSrvFactory getFactory() {
        return factory;
    }

    public void setFactory(ManageSrvFactory factory) {
        this.factory = factory;
    }

}
