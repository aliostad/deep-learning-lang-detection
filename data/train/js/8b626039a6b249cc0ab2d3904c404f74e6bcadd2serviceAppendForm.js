/**
 * Created by vincentfxz on 15/7/1.
 */
/**
 * 服务表单处理
 *
 */
/**
 * 服务新增弹出表单
 */
var parentId;
$(function(){

    var node = $('.mxservicetree').tree('getSelected');
    if(node.serviceCategory !=null){
        parentId = node.serviceCategory.categoryId;
    }
    if(node.service != null){
        parentId = node.service.categoryId;
    }

    /**
     * 服务新增保持按钮事件
     */
    var saveService = function saveService(){
        var service = {};
        service.serviceId = $('#serviceId').val();
        service.serviceName = $('#serviceName').val();
        service.desc = $('#discription').val();
        service.categoryId = parentId;
        service.version = $('#version').val();
        service.state = $('#state').val();
        if(PROCESS_INFO && PROCESS_INFO.processId){
            service.processId = PROCESS_INFO.processId;
        }
        serviceManager.add(service,function(result){
            $('#w').window('close');
            $('.mxservicetree').tree('reload');
        });
    };
    $("#serviceAddBtn").click(function(){
        saveService();
    });

});

