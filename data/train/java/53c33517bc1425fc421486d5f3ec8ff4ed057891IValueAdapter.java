package de.hub.clickwatch.connection.adapter.values;

import com.google.inject.ImplementedBy;

import de.hub.clickwatch.model.Handler;

@ImplementedBy(StringValueAdapter.class)
public interface IValueAdapter {

	public Handler create(Handler handler, IValueAdapter valueAdapter);
	
	public Handler create(Handler handler, String plainValue);
	
	public Handler create(String qualifiedName, long timestamp, String plainValue);
	
	public void update(Handler target, Handler source, IValueAdapter sourceValueAdapter);
	
	public String getPlainValue(Handler handler);
	
	public void clearValue(Handler handler);
	
	public void moveValue(Handler source, Handler target);
	
	public boolean valuesEquals(Handler h1, Handler h2);

}
