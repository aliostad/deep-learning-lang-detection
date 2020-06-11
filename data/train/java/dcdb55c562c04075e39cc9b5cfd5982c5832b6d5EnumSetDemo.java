package com.sai.java.lesserknownclasses;

import java.util.EnumSet;
import java.util.HashSet;
import java.util.Set;

public class EnumSetDemo {

	private enum ProcessType { TYPE1, TYPE2, TYPE3, TYPE4, TYPE5,
								TYPE6, TYPE7, TYPE8, TYPE9, TYPE0};
	
	public static void main(String[] args) {
		EnumSetDemo obj = new EnumSetDemo();
		
		 Set<ProcessType> s = new HashSet<ProcessType>();
	     s.add(ProcessType.TYPE1);
	     s.add(ProcessType.TYPE2);
	     s.add(ProcessType.TYPE3);
	     s.add(ProcessType.TYPE4);
	     s.add(ProcessType.TYPE5);
	     s.add(ProcessType.TYPE6);
	     s.add(ProcessType.TYPE7);
	     s.add(ProcessType.TYPE8);
	     s.add(ProcessType.TYPE9);
	     s.add(ProcessType.TYPE0);
	     obj.processForTypes(s,"s");
	     
	     // Order is maintained and easy to add
	     EnumSet<ProcessType> s1 = EnumSet.allOf(ProcessType.class);
	     obj.processForTypes(s1,"s1");
	     
	  // Thought elements are added in random , they maintain the order 
	     EnumSet<ProcessType> s2 = EnumSet.of(ProcessType.TYPE6, ProcessType.TYPE7, ProcessType.TYPE8, ProcessType.TYPE9, ProcessType.TYPE0,
	    		 						  ProcessType.TYPE1, ProcessType.TYPE2, ProcessType.TYPE3, ProcessType.TYPE4, ProcessType.TYPE5 );
	     obj.processForTypes(s2,"s2");
	     
	  // Thought elements are added in random , they maintain the order 
	     EnumSet<ProcessType> s3 = EnumSet.of(ProcessType.TYPE0, ProcessType.TYPE3, ProcessType.TYPE2, ProcessType.TYPE9 );
	     obj.processForTypes(s3,"s3");
	     
	     // Provides set of values which are not present in s3.
	     Set<ProcessType> s4 = EnumSet.complementOf(s3);
	     obj.processForTypes(s4,"s4");
	     
	     Set<ProcessType> s5 = EnumSet.range(ProcessType.TYPE3, ProcessType.TYPE8);
	     obj.processForTypes(s5,"s5");
	     
	     // Throws exception as TYPE0 is later to TYPE8
	     // Set<ProcessType> s5 = EnumSet.range(ProcessType.TYPE0, ProcessType.TYPE8);
		   
	}

	private void processForTypes(Set<ProcessType> s, String f) {
		System.out.print(f+"\t:\t");
		for (ProcessType processType : s) {
			System.out.print(processType+"\t");
		}
		System.out.println("");
	}

}
