/*
	author: @nixzhu (zhuhongxu@gmail.com)
	description: 配置手数显示等辅助功能，TODO 撤销、同色等
	license: GPL
*/

var move_show_flag = false;
function deal_button() {
	var move_show_button = document.getElementById("move_show");	
	if (move_show_button) {
		move_show_button.onclick = function() {
			//alert(move_show_button);
			if (move_show_flag) {
				move_show_button.innerHTML="显示手数";
				move_show_flag = false;
			} else {
				move_show_button.innerHTML="取消显示手数";
				move_show_flag = true;
			}
			showPan();
		}
	}
}
addLoadEvent(deal_button);
