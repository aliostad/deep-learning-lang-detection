package com.tianjian.model;

import java.util.ArrayList;

public class DetailService {
private Service service;
private ArrayList<ShortService> shortServiceList;
public Service getService() {
	return service;
}
public void setService(Service service) {
	this.service = service;
}
public ArrayList<ShortService> getShortServiceList() {
	return shortServiceList;
}
public void setShortServiceList(ArrayList<ShortService> shortServiceList) {
	this.shortServiceList = shortServiceList;
}
public DetailService(Service service, ArrayList<ShortService> shortServiceList) {
	super();
	this.service = service;
	this.shortServiceList = shortServiceList;
}
public DetailService() {
	super();
	// TODO Auto-generated constructor stub
}
@Override
public String toString() {
	return "DetailService [service=" + service + ", shortServiceList="
			+ shortServiceList + "]";
}

}
