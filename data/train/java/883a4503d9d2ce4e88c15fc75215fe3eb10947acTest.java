package com.pm.distest.rundisruptor;

import dolf.zhang.collect.core.disruptor.RunDisruptor;
import dolf.zhang.collect.core.handler.Step;
import com.pm.distest.Job;

/**
 * @author pengming  
 * @date 2016年12月30日 下午3:06
 * @description
 */
public class Test {


    public static void main(String[] args) {



        Test1EventHandler test1EventHandler = new Test1EventHandler();
        test1EventHandler.setKey("11");

        Test2EventHandler test2EventHandler = new Test2EventHandler();
        test2EventHandler.setKey("11");
        Test3EventHandler test3EventHandler = new Test3EventHandler();
        test3EventHandler.setKey("11");

        Test4EventHandler test4EventHandler = new Test4EventHandler();
        test4EventHandler.setKey("1");
        Test5EventHandler test5EventHandler = new Test5EventHandler();
        test5EventHandler.setKey("1");
        Test6EventHandler test6EventHandler = new Test6EventHandler();
        test6EventHandler.setKey("2");

//        Step step = new Step(test5EventHandler);
        Step step = new Step(test1EventHandler);
        Step step2 = new Step(test2EventHandler, test3EventHandler);
        Step step3 = new Step(test4EventHandler, test5EventHandler, test6EventHandler);

//        Step step = new Step(test1EventHandler, test2EventHandler);
//        Step step = new Step(test1EventHandler, test2EventHandler, test3EventHandler, test4EventHandler);
//        Step step = new Step(test1EventHandler, test2EventHandler, test6EventHandler);
//        Step step2 = new Step(test5EventHandler, test3EventHandler, test4EventHandler);
//        runDisruptor.setSteps(step, step2);

        RunDisruptor<Job> runDisruptor = new RunDisruptor<>(2048, step, step2, step3).init();

        long s = System.currentTimeMillis();

//        new Thread(() -> {
//            while (true) {
                for (int i = 0; i < 20; i++) {
                    Job event = new Job();
                    event.setJobId("jobId " + i);
                    runDisruptor.publishEvent(event);
                }
//                try {
//                    Thread.sleep(5000);
//                } catch (InterruptedException e) {
//                    e.printStackTrace();
//                }
//            }
//        }).start();



        runDisruptor.shutdown();

        long e = System.currentTimeMillis();
        System.out.println(
                (e - s)
        );
    }

}

