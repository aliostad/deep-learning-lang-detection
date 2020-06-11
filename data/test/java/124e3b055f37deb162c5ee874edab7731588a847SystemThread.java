/*
 * 创建日期 2006-10-25
 */
package com.coolsql.system;


/**
 * @author liu_xlin
 *所有与数据库操作相关的线程的基类
 */
public class SystemThread extends Thread {
    /**
     * 系统处理逻辑
     */
    private SystemProcess process=null;
    public SystemThread(SystemProcess process) 
    {
        super();
        this.process=process;
        if(process!=null)
            this.setName(process.getDescribe());
    }
    public void run()
    {
        if(process!=null)
            process.start();
    }
}
