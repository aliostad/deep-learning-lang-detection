//导航栏置顶

//window.onload=function(){
//	

		
		var oNav=document.querySelector('.nav');
		
		setInterval(
			function(){
				var os_Top = document.documentElement.scrollTop || document.body.scrollTop;
				if(os_Top>183){
					oNav.style.position='fixed';
					oNav.style.top=0;
					$('.main-banner').css({'margin-top':'52px'});
				}else{
					oNav.style.position='static';
					$('.main-banner').css({'margin-top':'0px'});
				}
				},10
		);
							
		
		//顶栏响应式
		(
			window.onresize=function(){
				var nav_menu=document.querySelector('.nav-menu');
				var nav_menu_li_a=document.querySelectorAll('.nav-menu li a');
				var nav_front=document.querySelectorAll('.nav .front');
				var nav_back=document.querySelectorAll('.nav .back');
				
				var nav_padding_l_r=nav_menu.offsetWidth*0.0124+'px';
				
				var nav_width=nav_menu.offsetWidth*0.1+'px';
				
				for(var i=0,len=nav_menu_li_a.length;i<len;i++){
					
					nav_menu_li_a[i].style.width=nav_width;
					
					nav_menu_li_a[i].style.paddingLeft=nav_padding_l_r;
					nav_menu_li_a[i].style.paddingRight=nav_padding_l_r;
					
					nav_front[i].style.paddingLeft=nav_padding_l_r;
					nav_front[i].style.paddingRight=nav_padding_l_r;
					
					nav_back[i].style.paddingLeft=nav_padding_l_r;
					nav_back[i].style.paddingRight=nav_padding_l_r;
				}
			}
		)()
		
		
//}		
