function toggleCandidateVisibility() {
	var elementsShow = "";
	var elementsHide = "";
	
	$('input').each(function(index, element){
		if(element.checked) {
			if(elementsShow != "")
				elementsShow = elementsShow + ", ";
				
			elementsShow = elementsShow + "." + element.value;
		} else {
			if(elementsHide != "")
				elementsHide = elementsHide + ", ";
				
			elementsHide = elementsHide + "." + element.value;
		}
	});
	$(elementsShow).show();
	$(elementsHide).hide(150); 
}

function toggleFilterButton() {
	if($(".filters").is(':hidden')) {
		$(".btn").html("Hide filters");
		$(".filters").show(500); 
	} else {
		$(".btn").html("Show filters");
		$(".filters").hide(500); 
	}
}