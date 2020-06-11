define([
    "backbone",
    "gritter"
], function(Backbone) {
    return {
        addMessage:function(message,type){
            $.gritter.add({
                text:message,
                type:type,
                time:3000,
                class_name:"gritter-"+type
            });
        },
        addError:function(message){
            this.addMessage(message,"error");
        },
        addSuccess:function(message){
            this.addMessage(message,"success");
        },
        addNotice:function(message){
            this.addMessage(message,"notice");
        },
        addInfo:function(message){
            this.addMessage(message,"info");
        }
    };
});