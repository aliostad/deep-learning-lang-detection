package com.wubinben.kata.fizzbuzz;

/**
 * User: Ben
 * Date: 13-12-18
 * Time: 下午2:20
 */
public class WordMaker {
    private WordMaker() {

    }
    public static String translate(int i) {
        WordHandler commonNumberHandler = new CommonNumberHandler();
        WordHandler whizzHandler = new WhizzHandler(commonNumberHandler);
        WordHandler buzzHandler = new BuzzHandler(whizzHandler);
        WordHandler fizzHandler = new FizzHandler(buzzHandler);
        WordHandler fizzBuzzHandler = new FizzBuzzHandler(fizzHandler);
        WordHandler fizzBuzzWhizzHandler = new FizzBuzzWhizzHandler(fizzBuzzHandler);

        Word word = fizzBuzzWhizzHandler.handle(i);
        return word.say();
    }
}
