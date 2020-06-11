/** This file will be jQuery only **/

// show scalar*matrix input
$(document).ready(function(){
		$("#show_1").click(function(){
			$("#test_1").show();
		});
	});


// show matrix*matrix input
	$(document).ready(function(){
		$("#show_2").click(function(){
			$("#test_2").show();
		});
	});

// show Find L & U input
	$(document).ready(function(){
		$("#show_3").click(function(){
			$("#test_3").show();
		});
	});
	
// show point load example
	$(document).ready(function(){
		$("#show_4").click(function(){
			$("#test_4").show();
		});
	});
	
	// show point load example
	$(document).ready(function(){
		$("#show_5").click(function(){
			matrixInsert();
			$("#answer_5").show();
		});
	});
	