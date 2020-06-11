window.onload = function(){
	//getElementsByClass
    function getByClass(classname, tagname, parent){
		var result=[],
			_array=parent.getElementsByTagName(tagname);
		for(var i=0,j=_array.length;i<j;i++){
			if((new RegExp("(?:^|\\s+)"+classname+"(?:\\s+|$)")).test(_array[i].className)){
				result.push(_array[i]);
			}
		}
		return result;
	}

	var nav = document.getElementById("nav");
	var navDetail = getByClass("navDetail","div",nav);
	//alert(navDetail.style.display);
    

	nav.onmouseover = function(){
		navDetail[0].style.display = "block";
	}
	nav.onmouseout = function(){
		navDetail[0].style.display = "none";	
	}

}