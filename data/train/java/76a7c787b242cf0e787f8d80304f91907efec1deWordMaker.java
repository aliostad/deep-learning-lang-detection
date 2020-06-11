package com.fren.main;

import java.util.ArrayList;
import java.util.List;

import com.fren.entity.Param;
import com.fren.entity.Word;
import com.fren.handler.BuzzHandler;
import com.fren.handler.BuzzWhizzHandler;
import com.fren.handler.CommonNumberHandler;
import com.fren.handler.FizzBuzzHandler;
import com.fren.handler.FizzBuzzWhizzHandler;
import com.fren.handler.FizzHandler;
import com.fren.handler.FizzWhizzHandler;
import com.fren.handler.SpecialFizzHandler;
import com.fren.handler.WhizzHandler;
import com.fren.handler.WordHandler;

/**
 * 
 * @author Fren
 *
 */
public class WordMaker {

	/**
	 * [责任链模式]玩FizzBuzzWhizz游戏
	 * @param roll
	 * @param number
	 * @return
	 */
	public static Word translate(int roll , Param number) {
		WordHandler commonNumberHandler = new CommonNumberHandler();
		WordHandler whizzHandler = new WhizzHandler(commonNumberHandler);
		WordHandler buzzHandler = new BuzzHandler(whizzHandler);
		WordHandler fizzHandler = new FizzHandler(buzzHandler);
		WordHandler fizzBuzzHandler = new FizzBuzzHandler(fizzHandler);
		WordHandler fizzWhizzHandler = new FizzWhizzHandler(fizzBuzzHandler);
		WordHandler buzzWhizzHandler = new BuzzWhizzHandler(fizzWhizzHandler);
		WordHandler fizzBuzzWhizzHandler = new FizzBuzzWhizzHandler(buzzWhizzHandler);
		WordHandler specialFizzHandler = new SpecialFizzHandler(fizzBuzzWhizzHandler);
		
		return specialFizzHandler.hander(roll, number);
	}
	
	/**
	 * 输出处理后的数组
	 * @param number
	 * @return
	 */
	public static List<String> getItemList(Param number){
		List<String> result = new ArrayList<String>();
		for (int i = 1; i <= 100; i++) {
			result.add(WordMaker.translate(i,number).say());
		}
		return result;
	}
}
