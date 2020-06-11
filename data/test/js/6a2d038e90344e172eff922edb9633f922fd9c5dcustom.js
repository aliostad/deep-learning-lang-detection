$(document).ready(function(){
	var count_navAddBook=0;
	$('#decp').click(function(){
		$('#decp').addClass('hiddenDiv');
		$('#descDiv').removeClass('hiddenDiv');
		$('#descDiv').animate({
			marginLeft: '2.4em'	
		},500);
	});
	// $('#addBooksDiv').css('margin-top','-260px');
	$('#navAddBook').click(function(){
		// $('#addBooksDiv').removeClass('hiddenDiv');
		
        function slidedown(){
        	$('#addBooksDiv').removeClass('hiddenDiv');
        	$('#decp').removeClass('hiddenDiv');
			$('#descDiv').addClass('hiddenDiv');
			$('#navAddBook').addClass('navColor');
            $('#addBooksDiv').animate({
                marginTop: '0'
            }, 500);
            count_navAddBook=1;

        }
        function slideup(){
        	// $('#decp').removeClass('hiddenDiv');
            $('#addBooksDiv').animate({
                marginTop: '-260px'
            }, 500);
        	$('#descDiv').addClass('hiddenDiv');
        	$('#descDiv').css('margin-left','-50em');
			$('#navAddBook').removeClass('navColor');
        	// .delay(1000);
        	count_navAddBook=0;
        }
        if(count_navAddBook==0) {
        	slidedown();
        }
        else {
        	slideup();
        	// .delay(500).hideAddBookDiv;// delay 500 ms here and remove the next line from comment
        	setTimeout(function(){
            $('#addBooksDiv').addClass('hiddenDiv');
        	}, 500);
        	// hideAddBookDiv();
        }	
        
        
	})
	$('#navNoti').mouseover(function(){
		$('#navNoti').addClass('navColor');
	})
	$('#navNoti').mouseout(function(){
		$('#navNoti').removeClass('navColor');
	})
	$('#navNoti2').mouseover(function(){
		// console.log("24354");
		$('#navNoti').addClass('navColor');
	})
	$('#navNoti2').mouseout(function(){
		$('#navNoti').removeClass('navColor');
	})
	$('#navUser').mouseover(function(){
		$('#navUser').addClass('navColor');
	})
	$('#navUser').mouseout(function(){
		$('#navUser').removeClass('navColor');
	})
	$('#navUser2').mouseover(function(){
		// console.log("24354");
		$('#navUser').addClass('navColor');
	})
	$('#navUser2').mouseout(function(){
		$('#navUser').removeClass('navColor');
	})
	$('#navAddBook').mouseover(function(){
		if(count_navAddBook==0) $('#navAddBook').addClass('navColor');
	})
	$('#navAddBook').mouseout(function(){
		if(count_navAddBook==0) $('#navAddBook').removeClass('navColor');
	})
});