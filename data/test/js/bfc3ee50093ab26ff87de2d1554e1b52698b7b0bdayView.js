var myScroll;
function  loaded(){
      myScroll = new iScroll('page-content',{
    	  useTransform: false,
    	  hScrollbar:false,
    	  vScrollbar: false
         });
            
}
        
//document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
//document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 1); }, false);
/*====年月日全局变量,可用于选择年月日，从而得到不同年月的月视图*/
var showYear = "";  
var showMonth = ""; 
var showDay = "";
var showWeek = "";
var showLunar= "";
/*====实现月视图*/
$(function() {
	loaded();
	/*====实现月视图*/
	showYear=getURLParam("showYear");
	showMonth=getURLParam("showMonth");
	showDay=getURLParam("showDay");
	if(showYear==""||showMonth==""||showDay==""){
		//从主菜单跳入日视图
		var dt = new Date();  
	    showYear=dt.getFullYear();
	    showMonth=dt.getMonth()+1;
	    showDay=dt.getDate();
	    showWeek=weekday(dt);
	    showLunar=lunarDay1(showYear,(showMonth-1),showDay);
	    showYearMonthDay(showYear,showMonth,showDay);
	    $("#week_lunar").html(showWeek+' '+showLunar);
	    showDayViewList(dt);

	}else{
		//从主页跳入日视图
		var dt=new Date(showYear,(showMonth-1),showDay);
		 showYear=dt.getFullYear();
		 showMonth=dt.getMonth()+1;
		 showDay=dt.getDate();
		 showWeek=weekday(dt);
		 showLunar=lunarDay1(showYear,(showMonth-1),showDay);
		 showYearMonthDay(showYear,showMonth,showDay);
		 $("#week_lunar").html(showWeek+' '+showLunar);		 
		 showDayViewList(dt);

	}
	$("#next_day").bind("touchstart", function() {
    	var date = new Date(showYear,(showMonth-1),showDay);
    	date.setDate(date.getDate()+1);
    	showYear=date.getFullYear();
    	showMonth=date.getMonth()+1;
    	showDay=date.getDate();
    	showWeek=weekday(date);
        showLunar=lunarDay1(showYear,(showMonth-1),showDay);
        showYearMonthDay(showYear,showMonth,showDay);
		$("#week_lunar").html(showWeek+' '+showLunar);
		showDayViewList(date);

	});
	/*====昨天*/
	$("#last_day").bind("touchstart", function() {
    	var date = new Date(showYear,(showMonth-1),showDay);
    	date.setDate(date.getDate()-1);
    	showYear=date.getFullYear();
    	showMonth=date.getMonth()+1;
    	showDay=date.getDate();
    	showWeek=weekday(date);
        showLunar=lunarDay1(showYear,(showMonth-1),showDay);
        showYearMonthDay(showYear,showMonth,showDay);
		$("#week_lunar").html(showWeek+' '+showLunar);
		showDayViewList(date);

	});
	$("#page-content").bind("swiperight", function(){
		var date = new Date(showYear,(showMonth-1),showDay);
    	date.setDate(date.getDate()-1);
    	showYear=date.getFullYear();
    	showMonth=date.getMonth()+1;
    	showDay=date.getDate();
    	showWeek=weekday(date);
        showLunar=lunarDay1(showYear,(showMonth-1),showDay);
        showYearMonthDay(showYear,showMonth,showDay);
		$("#week_lunar").html(showWeek+' '+showLunar);
		showDayViewList(date);
		
		
	});
	$("#page-content").bind("swipeleft", function(){
		var date = new Date(showYear,(showMonth-1),showDay);
    	date.setDate(date.getDate()+1);
    	showYear=date.getFullYear();
    	showMonth=date.getMonth()+1;
    	showDay=date.getDate();
    	showWeek=weekday(date);
        showLunar=lunarDay1(showYear,(showMonth-1),showDay);
        showYearMonthDay(showYear,showMonth,showDay);
		$("#week_lunar").html(showWeek+' '+showLunar);
		showDayViewList(date);
	});
	//点击新建，进入新建页面
	$("#newSchedule_btn").bind("click",function(){
		var date=$("#year_month_day").html();
		window.location.href="../index/newSchedule.html?date="+date;
	});
	
	//点击进入详细日程页面
	$(".rishitu_list").live("click",function(){
		activityId=$(this).attr("data-activityId");
		window.location.href="../index/dayViewDetail.html?activityId="+activityId;
	});
});

//显示头部年月日yyyy-mm-dd
function showYearMonthDay(showYear,showMonth,showDay){
	var month=showMonth;
	var day=showDay;
	if(month<10){month='0'+showMonth;}
	if(day<10){day='0'+showDay;}
	$("#year_month_day").html(showYear+'-'+month+'-'+day);
}




//显示日视图
function showDayViewList(date){
	Activity.findByDate(date, getResult);
	
	function getResult(result) {
		var dayViewHtml="";
		if(result.length != 0){
            for(var i=0;i<result.length;i++){
            	dayViewHtml+='<div class="rishitu_list_line"></div><table class="rishitu_list" data-activityId="'+result[i].activityId;
            	if(result[i].title==""){
            		dayViewHtml+='"><tr><td width="10%" height="40"><img src="../images/rishitu_17.png"45></td><td width="90%" height="100%" style="padding-left:15px">'+'无标题';
            	}else{           		
            		dayViewHtml+='"><tr><td width="10%" height="40"><img src="../images/rishitu_17.png"45></td><td width="90%" height="100%" style="padding-left:15px">'+result[i].title;
            	}
            	if(result[i].allDay==0 || result[i].allDay=="0"){            		
            		dayViewHtml+='</td></tr><tr><td width="10%" height="40"></td><td width="90%" height="100%" style="padding-left:15px"><span>'+result[i].startTime+" ~ "+result[i].endTime+'<span></td></tr></table>';
            	}else{
            		dayViewHtml+='</td></tr><tr><td width="10%" height="40"></td><td width="90%" height="100%" style="padding-left:15px"><span>'+'00:00 ~ 24:00 （全天）'+'<span></td></tr></table>';
            		
            	}
    		    
    		    
            }
            $("#showViewList").html(dayViewHtml);
            myScroll.refresh();
		}else{
			$("#showViewList").html('<div class="blank_page"><p><img src="../images/dog.png"></p><p>今天没有日程</p></div>');
			myScroll.refresh();
		}
		

	}			 			
}





