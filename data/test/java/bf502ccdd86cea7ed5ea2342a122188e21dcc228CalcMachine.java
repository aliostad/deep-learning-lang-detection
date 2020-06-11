package com.addition;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class CalcMachine {
	InputService inputService;
	OutputService outputService;
	
	public int doAdd() {
		int x=inputService.getIntValue();
		int y=inputService.getIntValue();
		int z=x+y;
		return outputService.write(z);
	}

	public InputService getInputService() {
		return inputService;
	}

	public void setInputService(InputService inputService) {
		this.inputService = inputService;
	}

	public OutputService getOutputService() {
		return outputService;
	}

	public void setOutputService(OutputService outputService) {
		this.outputService = outputService;
	}
}
