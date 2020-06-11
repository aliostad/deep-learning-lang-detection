package com.sclbxx.wisdomwork.vo;

import java.io.Serializable;

/**
 * Created by HuXingPeng
 * Date 2017/4/5
 */

public class HomeworkCourseDirtreeVo implements Serializable{

    private int courseDirtreeId;
    private String 	manageName;

    public HomeworkCourseDirtreeVo(int courseDirtreeId,String manageName) {
        this.manageName = manageName;
        this.courseDirtreeId = courseDirtreeId;
    }

    public int getCourseDirtreeId() {
        return courseDirtreeId;
    }

    public void setCourseDirtreeId(int courseDirtreeId) {
        this.courseDirtreeId = courseDirtreeId;
    }

    public String getManageName() {
        return manageName;
    }

    public void setManageName(String manageName) {
        this.manageName = manageName;
    }
}
