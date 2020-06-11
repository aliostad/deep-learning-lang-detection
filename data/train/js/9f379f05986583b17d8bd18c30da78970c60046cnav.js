// JavaScript Document

var nav = new Array();
nav[0] = {name:"Home",url:"../index.html"}
nav[1] = {name:"1 - Variables",url:"1-variables.html"}
nav[2] = {name:"2 - innerHTML",url:"2-innerhtml.html"}
nav[3] = {name:"3 Class Styles",url:"3-class-styles.html"}
nav[4] = {name:"4 DOM",url:"4-dom.html"}
nav[5] = {name:"5 Events",url:"5-events.html"}
nav[6] = {name:"6 Arrays and Loops",url:"6-arrays.html"}

function outputNav(){
	var m =""
	for(i=0; i<nav.length; i++){
	m+="<a href='"+nav[i].url+"'>"+nav[i].name+"</a> ";
	}
	document.getElementsByTagName('nav')[0].innerHTML = m;
}