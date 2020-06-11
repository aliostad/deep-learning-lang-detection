package com.thoughtworks.exam;

import java.util.ArrayList;
import java.util.List;

import com.thoughtworks.exam.handler.AbstractHandler;
import com.thoughtworks.exam.handler.BuzzHandler;
import com.thoughtworks.exam.handler.BuzzWhizzHandler;
import com.thoughtworks.exam.handler.FizzBuzzHandler;
import com.thoughtworks.exam.handler.FizzBuzzWhizzHandler;
import com.thoughtworks.exam.handler.FizzContainsHandler;
import com.thoughtworks.exam.handler.FizzHandler;
import com.thoughtworks.exam.handler.FizzWhizzHandler;
import com.thoughtworks.exam.handler.NormalHandler;
import com.thoughtworks.exam.handler.WhizzHandler;

public class NumberWorker {
	
	private AbstractHandler handler;

	public NumberWorker(int a, int b, int c) {
		FizzBuzzWhizz fizzBuzzWhizz = new FizzBuzzWhizz(a, b, c);
		NormalHandler normalHandler = new NormalHandler();
		FizzHandler fizzHandler = new FizzHandler(normalHandler, fizzBuzzWhizz);
		BuzzHandler buzzHandler = new BuzzHandler(fizzHandler, fizzBuzzWhizz);
		WhizzHandler whizzHandler = new WhizzHandler(buzzHandler, fizzBuzzWhizz);
		FizzBuzzHandler fizzBuzzHandler = new FizzBuzzHandler(whizzHandler, fizzBuzzWhizz);
		FizzWhizzHandler fizzWhizzHandler = new FizzWhizzHandler(fizzBuzzHandler, fizzBuzzWhizz);
		BuzzWhizzHandler buzzWhizzHandler = new BuzzWhizzHandler(fizzWhizzHandler, fizzBuzzWhizz);
		FizzBuzzWhizzHandler fizzBuzzWhizzHandler = new FizzBuzzWhizzHandler(buzzWhizzHandler, fizzBuzzWhizz);
		handler = new FizzContainsHandler(fizzBuzzWhizzHandler, fizzBuzzWhizz);
	}
	
	public List<String> getNumbers(){
		List<String> list = new ArrayList<String>();
		for (int i = 1; i <= 100; i++) {
			list.add(this.getNumber(i));
		}
		return list;
	}
	
	public String getNumber(int number){
		return handler.handle(number);
	}

}
