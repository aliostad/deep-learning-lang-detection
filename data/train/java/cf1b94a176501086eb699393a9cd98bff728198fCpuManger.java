package com.company;

import java.util.ArrayList;

/**
 * Created by khaled on 08/04/17.
 */
public  class  CpuManger {
    private  ArrayList<Process> processes;
    private  ArrayList <ProcessResult> processResults;
    int length ;
    public CpuManger(ArrayList<Process> processes) {
         this.processes=processes;
         processResults = new ArrayList<>();
        int i = 0;
        int number;
        while (!processes.isEmpty()){
            number=findPriority(i);
            if(number !=0){
               i = addResult(deleteProcesses(number));
            }
            i++;
        }

    }
    public  ArrayList<ProcessResult> endResults (){
        return processResults;
    }
    private Process deleteProcesses (int number){
        Process process=new Process();
        length = processes.size();
        int i=0;
        do{
            if(processes.get(i).getNumber() == number){
                process = processes.get(i);
                i=length;
            }
            else {
                i++;
            }
        }while (i< length);
        processes.remove(process);
        return  process;
    }
    private int  addResult  (Process process){
        ProcessResult processResult = new ProcessResult();
        int start =0;
        int end;
        processResult.setNumber(process.getNumber());
        if(!processResults.isEmpty()){
            start = processResults.get(processResults.size()-1).getEndTime();
        }
        processResult.setStartTime(start);
        end=start+process.getBurstTime();
        processResult.setEndTime(end);
        processResult.setWaitingTime(start-process.getArrivalTime());
        processResult.setTurnaroundTime(end-process.getArrivalTime());
        processResults.add(processResult);
        return end;
    }
    private  int  findPriority (int time) {
        length = processes.size();
        Process proces = new Process();
        int miniPriority =0 ;
        int number =0 ;
        for (int i = 0; i < length; i++) {
            if (processes.get(i).getArrivalTime() <= time) {
                if (miniPriority == 0||miniPriority > processes.get(i).getPriority()){
                    number=processes.get(i).getNumber();
                   miniPriority = processes.get(i).getPriority();
                }

            }
        }

        return  number;
    }

}
