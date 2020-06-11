/**
 * Created by vincentfxz on 15/7/1.
 */

$(function(){
    var node = $('.mxservicetree').tree('getSelected');
    $('#serviceName').val(node.service.serviceName);
    $('#discription').val(node.service.desc);
    $('#serviceCategory').val(node.service.categoryId);
    $('#serviceId').val(node.service.serviceId);
    $('#state').val(node.service.state);
    $('#version').val(node.service.version);
    $('#remark').val(node.service.remark);
    /**
     * 编辑对话框保存按钮事件
     */
    var saveByEdit = function saveByEdit(){
        var service = {};
        service.serviceName = $('#serviceName').val();
        service.desc = $('#discription').val();
        service.remark = $('#remark').val();
        var node = $('.mxservicetree').tree('getSelected');
        service.serviceId = node.id;
        service.categoryId = $('#serviceCategory').val();
        service.version = $('#version').val();
        service.state = $('#state').val();
        serviceManager.update(service,function(result){
            if(result){
                $('#w').window('close');
                $('.mxservicetree').tree('reload');
            }
        });
    };

    $("#serviceEditBtn").click(function(){
        saveByEdit();
    });
});
