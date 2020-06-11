package com.example.guojian.weekcook.bean;

import java.io.Serializable;

/**
 * Created by guojian on 11/15/16.
 */
public class ProcessBean implements Serializable{
    private String process_pcontent;
    private String process_pic;

    public ProcessBean(String process_pcontent, String process_pic) {
        this.process_pcontent = process_pcontent;
        this.process_pic = process_pic;
    }

    public String getProcess_pcontent() {
        return process_pcontent;
    }

    public void setProcess_pcontent(String process_pcontent) {
        this.process_pcontent = process_pcontent;
    }

    public String getProcess_pic() {
        return process_pic;
    }

    public void setProcess_pic(String process_pic) {
        this.process_pic = process_pic;
    }
}
