/**
 * Created by DELL on 2015/12/28.
 */
var navTableGrid = null;
$(function () {
    var navTableOptions = {
        ajax: "./nav_manage_fetch.action",
        "columns": [
            {"data": "nav_name"},
            {"data": "nav_par"},
            {"data": "nav_sort"},
            {"data":"nav_url"},
            {"data": "nav_createtime"},
            {"data": "nav_user"},
            {"data": "nav_operation"}
        ]
    }
    $.extend(navTableOptions, options);
    navTableGrid = $("#navTable").DataTable(navTableOptions);
    //过滤表格的显示效果
    navTableGrid.on('xhr', function () {
        var result = navTableGrid.ajax.json().data;
        $.each(result, function (i, e) {
            if (e.childNavManageVoList.length > 0) {
                $.each(e.childNavManageVoList, function (j, childNav) {
                    result.push({
                        "nav_name": childNav.nav_name,
                        "nav_par": e.nav_name,
                        "nav_sort": childNav.nav_sort,
                        "nav_url": childNav.nav_url,
                        "nav_createtime": childNav.nav_createtime,
                        "nav_user": childNav.nav_user,
                        "nav_operation": "<button class=\"btn btn-info btn-sm\" onclick=\"editNav('" + childNav.nav_id + "')\">编辑 </button>" + "&nbsp;<button class=\"btn btn-primary btn-sm\" onclick=\"configNav(\'" + childNav.nav_id + "\')\">配置分类</button>" + "&nbsp;<button class=\"btn btn-danger btn-sm\" onclick=\"delNav(\'" + childNav.nav_id + "\')\">删除</button>"
                    });
                });
            }
            e.nav_par = e.nav_parent_id == "root" ? "根导航" : "";
            e.nav_operation = "<button class=\"btn btn-info btn-sm\" onclick=\"editNav('" + e.nav_id + "')\">编辑 </button>" +
            "&nbsp;<button class=\"btn btn-primary btn-sm\" onclick=\"configNav(\'" + e.nav_id + "\')\">配置分类</button>" + "&nbsp;<button class=\"btn btn-danger btn-sm\" onclick=\"delNav(\'" + e.nav_id + "\')\">删除</button>"
        });
        return result;
    });
    //绑定添加导航按钮
    $("#addNavBtn").on("click", function () {
        $("#addNavDialog").modal("show");
    });
    $("#addNavLevel").on("change", function () {
        var $sel = $(event.target);
        if ($sel.val() == 1) {
            //加载所有的顶级菜单
            $.post("./nav_manage_root_fetch.action", function (data) {
                var optionsTemplate = "";
                $.each(data.data, function (i, e) {
                    optionsTemplate += "<option value=\"" + e.nav_id + "\">" + e.nav_name + "</option>";
                });
                $("#addParentNav").html(optionsTemplate);
                $("#addParentNavDiv").removeClass("hidden");
            });
        } else {
            $("#addParentNavDiv").addClass("hidden");
        }
    });
    $("#editNavLevel").on("change", function () {
        var $sel = $(event.target);
        if ($sel.val() == 1) {
            //加载所有的顶级菜单
            $.post("./nav_manage_root_fetch.action", function (data) {
                var optionsTemplate = "";
                $.each(data.data, function (i, e) {
                    optionsTemplate += "<option value=\"" + e.nav_id + "\">" + e.nav_name + "</option>";
                });
                $("#editParentNav").html(optionsTemplate);
                $("#editParentNavDiv").removeClass("hidden");
            });
        } else {
            $("#editParentNavDiv").addClass("hidden");
        }
    });
});
//添加导航内容
function addNav() {
    var $navName = $("#addNavName");
    if ($.trim($navName.val()) == "") {
        alert("导航内容不能为空");
    } else {
        var params = new Object();
        params.navName = $.trim($navName.val());
        params.navParentId = $("#addNavLevel").val() == 1 ? $("#addParentNav").val() : "root";
        params.navUrl=$("#addNavUrl").val();
        params.navSort=$("#addNavSort").val();
        $.post("./nav_manage_add.action", params, function (data) {
            $("#addNavDialog").modal("hide");
            if (data.success) {
                navTableGrid.ajax.reload();
                alert("新增导航成功!");
            } else {
                alert("新增导航失败！");
            }
            $navName.val("");
        });
    }

}
//打开编辑对话框
function editNav(idVal) {
    var $navObj = $(event.target).parent("td");
    $("#editNavName").val($navObj.siblings("td:eq(0)").html());
    $("#editNavUrl").val($navObj.siblings("td:eq(3)").html());
    $("#editNavSort").val($navObj.siblings("td:eq(2)").html());
    if ($navObj.siblings("td:eq(1)").html() != "根导航") {
        $("#editNavLevel").val("1");
        //加载所有的顶级菜单
        $.post("./nav_manage_root_fetch.action", function (data) {
            var optionsTemplate = "";
            $.each(data.data, function (i, e) {
                optionsTemplate += "<option value=\"" + e.nav_id + "\">" + e.nav_name + "</option>";
            });
            $("#editParentNav").html(optionsTemplate);
        });
        $("#editParentNavDiv").removeClass("hidden");
    } else {
        $("#editNavLevel").val("0");
        $("#editParentNavDiv").addClass("hidden");
    }
    $("#editNavDialog").attr("data-idVal", idVal).modal("show");
}
//更新导航内容
function updateNav() {
    var $navName = $("#editNavName");
    if ($.trim($navName.val()) == "") {
        alert("导航名称不能为空！");
    } else {
        var params = new Object();
        params.navName = $.trim($navName.val());
        params.idVal = $("#editNavDialog").attr("data-idVal");
        params.navParentId = $("#editNavLevel").val() == 0 ? "root" : $("#editParentNav").val();
        params.navUrl=$("#editNavUrl").val();
        params.navSort=$("#editNavSort").val();
        $.post("./nav_manage_update.action", params, function (data) {
            $("#editNavDialog").modal("hide");
            if (data.success) {
                navTableGrid.ajax.reload();
                alert("更新导航内容成功！");
            } else {
                alert("更新导航内容失败！");
            }
        });
    }
}
//删除导航
function delNav(idVal) {
    if (window.confirm("确定要删除该导航吗？")) {
        $.post("./nav_manage_del.action", {"navId": idVal}, function (data) {
            if (data.success) {
                navTableGrid.ajax.reload();
                alert("删除导航成功！");
            }
        });
    }
}

//配置导航菜单
var zTreeObj=null;
function configNav(idVal) {
    if(zTreeObj!=null){
        zTreeObj.setting.async.otherParam= {"navId": idVal};
        zTreeObj.reAsyncChildNodes(null, "refresh");
    }else{
        //初始化树结构
        setting = {
            async: {
                enable: true,
                otherParam: {"navId": idVal},
                type: 'post',
                url: './nav_manage_classify_fetch.action',
                dataFilter: function (treeId, parentNode, responseData) {
                    return responseData.data;
                }
            },
            check: {
                enable: true
            },
            view: {
                selectedMulti: false,
                txtSelectedEnable: true
            },
            callback: {}
        },
            zTreeObj = $.fn.zTree.init($("#configNavClassifyTree"), setting, null);
    }
    //打开对话框
    $("#configNavClassifyDialog").attr("data-id", idVal).modal("show");
}
//保存导航分类配置
function saveConfigNavClassify() {
    var nodes = zTreeObj.getCheckedNodes(true);
    if (nodes.length <= 0) {
        alert("请选择要保存的配置分类");
    } else {
        var params = new Object();
        params.navId = $("#configNavClassifyDialog").attr("data-id");
        var classifyIds = new Array();
        $.each(nodes, function (i, e) {
            classifyIds.push(e.id);
        });
        params.classifyIds=classifyIds;
        $.post("./nav_manage_classify_update.action", params, function (data) {
            if (data.success) {
                alert("保存导航分类成功！");
            } else {
                alert("保存导航分类失败！");
            }
            $("#configNavClassifyDialog").modal("hide");
        });
    }

}
