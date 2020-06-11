$(document).ready(function(){
	$("#typeSelect").bind("change",function(){
		init_nav_type($(this).val());	
	});
	
	
	$("#mobileTypeSelect").bind("change",function(){	
		init_nav_cfg($(this).val());		
		init_nav_type($("#typeSelect").val());
	});
	
	init_nav_cfg($("#mobileTypeSelect").val());
	init_nav_type($("#typeSelect").val());
	
});


function init_nav_cfg(type)
{
	var navs = null;
	for(nav_key in nav_cfg)
	{
		nav_cfg_item = nav_cfg[nav_key];
		if(nav_cfg_item['mobile_type']==type)
		{
			navs = nav_cfg_item['nav'];
			break;
		}
	}
	if(type==0)
	{
		if($("#advposition").find("option[value='1']").length==0)
		{
			var opp = new Option("启动页","1");
			$("#advposition").append(opp);
		}
	}
	else
	{
		$("#advposition").find("option[value='1']").remove();
		//$("#advposition").val(0);
	}
	

	$("#typeSelect").empty();
	for(nav_key in navs)
	{
		nav_item = navs[nav_key];
		
		var select_str = "";
		if(nav_item['type']==adv_type)
		{
			select_str = "selected='selected'";
		}
		$("#typeSelect").append("<option value='"+nav_item['type']+"' "+select_str+" >"+nav_item['name']+"</option>");
	}
}
	
function init_nav_type(type)
{
	$("#type").hide();			


	var navs = null;
	for(nav_key in nav_cfg)
	{
		nav_cfg_item = nav_cfg[nav_key];
		if(nav_cfg_item['mobile_type']==$("#mobileTypeSelect").val())
		{
			navs = nav_cfg_item['nav'];
			break;
		}
	}
	
	var val = type;
	
	for(nav_key in navs)
	{
		nav_item = navs[nav_key];
		if(val==nav_item['type'])
		{
			if(nav_item['field']!="")
			{
				$("#type").show();		
				$("#type").find(".item_title").html(nav_item['fname']);
				$("#type").find(".item_input input").attr("name",nav_item['field']);
				
				
				var data_val = "";
				try{
					data_val = data_json[nav_item['field']];
				}catch(ex)
				{
					
				}
				
				if(data_val)
				{
					$("#type").find(".item_input input").val(data_val);
				}
				else
				{
					$("#type").find(".item_input input").val("");
				}
			}
			break;
		}
	}	
}
	