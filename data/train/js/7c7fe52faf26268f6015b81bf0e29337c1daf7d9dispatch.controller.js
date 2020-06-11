$(function(){
	//选择产品列表
	$('#PID-selector a[data-value]').live('click',function(){
		select_product(this);
	});
	/* $('#add-dispatch-modal').on('show',function(){
		init_preview();
	}); */
	$('#add-dispatch-modal').on('hidden',function(){
		reset_preview();
	});
	$('#preview-submit').on('click',function(){
		init_preview();
		return false;
	});
	$('#add-dispatch-modal-submit').on('click',function(){
		dispatch_submit();
	});
	//$('#add-dispatch-modal').modal();
	$('#test').on('click',function(){
		$('#message-test').messagebox();
		return false;
	});
	init_product_list(0);
});