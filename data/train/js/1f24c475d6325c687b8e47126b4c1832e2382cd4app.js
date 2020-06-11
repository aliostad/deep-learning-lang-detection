var TopNav = Backbone.View.extend({
    events:{
        "click #showChannelList":"showChannelList",
        "click #showCategoryList":"showCategoryList",
        "click #showProgramList":"showProgramList",
        "click .expand":"expand",
    },
    
    showChannelList:function(){
        //设置导航active
        //设置左侧导航
        //更新右侧列表区域
        //更新面包屑
        window.location.href = "channel.html";
    },
    showCategoryList:function(){
        //

    },
    showProgramList:function(){

    },
    expand:function(){

    },


    
});
