$(function() {
	/*
	ページを開いた際に【0page】がどうしても表示できません。
	$('#nav_0').trigger('click');を実行してしまうと
	$.ajaxが【0page】を無限に読み込んでしまいます。
	ご回答いただければ幸いです。
	*/
	
	var
	$gNav = $('nav ul li a'),
	oldNav = 0,
	newNav = 0;
	
	/*ajax*/
	function ajaxFunc(padeID){
		$("#loading").html("<img src='common/img/loading.gif'/>");
		$.ajax({
				url:"page_" + padeID + "/index.html",
				success:function(data){
				$("#ajaxArea").html(data);
				},
               error:function() {
                   alert(String('読み込み失敗'));
               }
				
			});
	}
	
	/*clickEvent*/
	$gNav.each(function(newNav) {
		$(this).on('click',function(){
			console.log(newNav);
			if(newNav == oldNav) return;//クリック連打防止
			$('#nav_' + oldNav).removeClass('on');
			$('#nav_' + newNav).addClass('on');
			oldNav = newNav;
			/*ajaxにページIDを渡す*/
			ajaxFunc(newNav);
   		});
 	});
	
	//ページをロードした際に、page0が表示（バグ）
	//$('#nav_0').trigger('click'); 
	

});
