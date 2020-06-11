/**
 * Created by vincentfxz on 15/6/30.
 *
 * 使用于 index.html 中服务树右键菜单
 *
 */
$(function(){
    /**
     * 服务树右键菜单新增按钮事件
     */
    $("#serviceTreeAddBtn").click(function (){
        serviceUIHelper.appendServiceForm();
    });
    /**
     * 服务树右键菜单编辑按钮事件
     */
    $("#serviceTreeEditBtn").click(function(){
        serviceUIHelper.editServiceForm();
    });
    /**
     * 服务树右键菜单编辑按钮事件
     */
    $("#serviceTreeDeleteBtn").click(function(){
        serviceUIHelper.deleteServiceFormTree();
    });
    /**
     * 服务树右键菜单编辑按钮事件
     */
    $("#servicePdf").click(function(){
        serviceUIHelper.exportPdf();
    });
    $("#serviceExcel").click(function(){
        serviceUIHelper.exportExcel();
    });
    $("#serviceView").click(function(){
        serviceUIHelper.exportView();
    });
});