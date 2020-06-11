package com.neph.annotatedcallback;

import com.neph.annotatedcallback.provider.BetradarHandler;
import com.neph.annotatedcallback.provider.EnetpulseHandler;
import com.neph.annotatedcallback.provider.ImgHandler;
import com.neph.annotatedcallback.provider.RunningballHandler;
import com.neph.annotatedcallback.util.Helper;

public class Main {

    public static void main(String[] args) {
        RunningballHandler runningballHandler = new RunningballHandler();
        BetradarHandler betradarHandler = new BetradarHandler();
        EnetpulseHandler enetpulseHandler = new EnetpulseHandler();
        ImgHandler imgHandler = new ImgHandler();

        runningballHandler.start();
        //betradarHandler.start();
        //enetpulseHandler.start();
        //imgHandler.start();
        //Helper.sleep(1000);
        //imgHandler.start();
        //Helper.sleep(1000);
        //imgHandler.start();
        //Helper.sleep(1000);
        //imgHandler.start();
        //Helper.sleep(1000);
        //imgHandler.start();
    }

}
