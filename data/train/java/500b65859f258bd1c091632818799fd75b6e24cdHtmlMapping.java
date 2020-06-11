package controllers;

import models.Managers;

import java.util.List;

/**
 * Created by Administrator on 14-1-26.
 */
public class HtmlMapping extends Application {
    public static void html(String manage){
        String uid=session.get(LOGIN_USER_ID);
        if(uid==null){
            if(manage.indexOf("EditData")!=-1){
                render("/Manage/modalLogin.html");
            }
            render("/Manage/login.html");
        }else{
            if("printRecords".equals(manage)){
                List<Managers> managers=Managers.findAll();
                render("/Manage/"+manage+".html",managers);
            }
            else{
                render("/Manage/"+manage+".html");
            }
        }
    }
}
