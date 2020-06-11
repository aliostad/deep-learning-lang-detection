/*	Name	Show And Hidden
	Type	javascript plugin
	Effect	mouse over then show,mouse out then hidden
	Editor	Biweiming
	Date		2013-11-11 10:05
-------------------------------------------------------------*/
function showAndHidden($container,$show){// $container and $show is ID name
	var handle=document.getElementById($container),// handle is container
		show=document.getElementById($show);// show is control element
	show.style.display='none';// first hidden
	handle.onmouseover=function(){
		//show.style.display='block';// show
		$(document.getElementById($show)).stop().slideToggle();
	}// end mouseover
	handle.onmouseout=function(){
		//show.style.display='none';// hidden
		$(document.getElementById($show)).stop().slideToggle();
	}
}