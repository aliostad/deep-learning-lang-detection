// JScript 文件

SureSubstationInto=function(row){
    var dispatchOrderItemIdsplit = "";
    var realIntoQuantitysplit = "";
    var dispatchOrderId = 0
    for(var i=0;i<row.length;i++){
           if(row.length==1){
               dispatchOrderItemIdsplit=row[i].data.id;
               realIntoQuantitysplit=row[i].data.realIntoQuantity;
               dispatchOrderId = row[i].data.dispatchOrderId;
           }else{
               
               if(i<(row.length-1)){
                   dispatchOrderItemIdsplit=row[i].data.id+","+dispatchOrderItemIdsplit;
                   dispatchOrderId = row[i].data.dispatchOrderId;
                   realIntoQuantitysplit=row[i].data.realIntoQuantity+","+realIntoQuantitysplit;
               }
               if(i==(row.length-1)){
                   dispatchOrderId = row[i].data.dispatchOrderId;
                   dispatchOrderItemIdsplit=dispatchOrderItemIdsplit+row[i].data.id;
                   realIntoQuantitysplit=realIntoQuantitysplit+row[i].data.realIntoQuantity;
              } 
           }
     } 
     Ext.Ajax.request({
           url:"substationInto.do?actionType=doSubstationInto",
           method:"POST",
           params:{
	           	dispatchOrderItemId:dispatchOrderItemIdsplit,
	           	realIntoQuantity:realIntoQuantitysplit,
	           	dispatchOrderId:dispatchOrderId
           },
           success:function(){
           	SubstationIntoStore.reload({params : {dispatchOrderId : dispatchOrderIdTemp}});
           	
                  Ext.Msg.alert("不好意思","修改成功了!");
                  SubstationIntoStore.reload();
           },
           failure:function(){
           	SubstationIntoStore.reload({params : {dispatchOrderId : dispatchOrderIdTemp}});
			Ext.Msg.alert("不好意思","修改失败了!");
            //      Ext.Msg.alert("提 示","删除失败了!");
           }
     });
     
}
