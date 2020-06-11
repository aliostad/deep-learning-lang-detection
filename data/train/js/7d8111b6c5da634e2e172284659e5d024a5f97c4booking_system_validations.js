var $service = jQuery.noConflict();
function validate_service_form(){
	var service_name = $service("#service_name").val();
	var service_price = $service("#service_price").val();
	var service_sort_order = $service("#service_sort_order").val();
	
	function isNumber(n) {
	   return !isNaN(parseFloat(n)) && isFinite(n);
	 }
	if(service_name==""){
		$service("#service_name").focus();
		$service("#name_service .service_add_error").html("Service name is required field.");
		$service('#service_name').change(function(){
			$service("#name_service .service_add_error").html("");
		});
		return false;
	}else if(service_price==""){
		$service("#service_price").focus();
		$service("#price_service .service_add_error").html("Service price is required field.");
		$service('#service_price').change(function(){
			if(!isNumber(service_price)){
				$service("#price_service .service_add_error").html("Only numbers are allowed.");
			}else{
				$service("#price_service .service_add_error").html("");
			}
		});
		return false;
	}else if(!isNumber(service_price)){
		$service("#service_price").focus();
		$service("#price_service .service_add_error").html("Only numbers are allowed.");
		$service('#service_price').change(function(){
			$service("#price_service .service_add_error").html("");
		});		
		return false;
	}else if(service_sort_order==""){
		$service("#service_sort_order").focus();
		$service("#order_sort .service_add_error").html("Sort order is required field.");
		$service('#service_sort_order').change(function(){
			$service("#order_sort .service_add_error").html("");
		});
		return false;
	}else if(!isNumber(service_sort_order)){
		$service("#service_sort_order").focus();
		$service("#service_sort_order").focus();
		$service("#order_sort .service_add_error").html("Only numbers are allowed.");
		$service('#service_sort_order').change(function(){
			$service("#order_sort .service_add_error").html("");
		});		
		return false;
	}
}