package com.github.typesafe_query.handler;

import java.util.function.Consumer;
import java.util.function.Function;

import com.github.typesafe_query.BatchModelHandler;

//FIXME 名前ダサ男
public class BatchModelHandlerHandler<T> {
	
	private BatchModelHandler<T> handler;
	
	public BatchModelHandlerHandler(BatchModelHandler<T> handler){
		this.handler = handler;
	}
	
	public void execute(Consumer<BatchModelHandler<T>> consumer){
		try {
			consumer.accept(handler);
			handler.executeBatch();
		} finally {
			handler.close();
		}
	}
	
	public <R> R execute(Function<BatchModelHandler<T>,R> consumer){
		try {
			R r =consumer.apply(handler);
			handler.executeBatch();
			return r;
		} finally {
			handler.close();
		}
	}
}
