/*
 * �������� 2006-10-25
 */
package com.cattsoft.coolsql.system;


/**
 * @author liu_xlin
 *��������ݿ������ص��̵߳Ļ���
 */
public class SystemThread extends Thread {
    /**
     * ϵͳ�����߼�
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
