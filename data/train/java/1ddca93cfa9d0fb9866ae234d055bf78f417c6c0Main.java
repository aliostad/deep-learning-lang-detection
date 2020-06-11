package com.omar.designpattern.dutychain;

/**
 * @author abaolei
 * @company DTDream
 * @date 2017/8/15 11:24
 */
public class Main {
    /**
     * 根据task的类型从上往下执行处理请求
     * @param args
     */
    public static void main(String[] args){
        ITask task0 = new JobTask(0);
        ITask task1 = new JobTask(1);

        Handler commonHandler = new CommonHandler();
        Handler vipHandler = new VipHandler();
        commonHandler.setNext(vipHandler);

        commonHandler.handle(task0);
        commonHandler.handle(task1);
    }
}
