package com.iava.dp.behavioral.chain.demo2.inner;

import java.io.*; 

public class Application {
    public static void main(String[] args) 
                                 throws IOException { 
        Handler numberHandler = new NumberHandler(); 
        Handler characterHandler = new CharacterHandler(); 
        Handler symbolHandler = new SymbolHandler(); 

        numberHandler.setSuccessor(characterHandler); 
        characterHandler.setSuccessor(symbolHandler); 

        System.out.print("Press any key then return: "); 
        char c = (char)System.in.read(); 
        numberHandler.handleRequest(c); 
    } 
} 
