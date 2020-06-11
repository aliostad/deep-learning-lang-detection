Template.messageList.helpers({
    showMessageForm: function(){
        return AmplifiedSession.equals('showMessageForm', true);
    }
});

Template.messageList.events({
    'click #message-form-hide': function(){
        AmplifiedSession.set('showMessageForm', false);
    },
    'click #message-form-show': function(){
        AmplifiedSession.set('showMessageForm', true);
    }
});

Template.messageList.rendered = function(){
    initShowToggle();
};

var initShowToggle = function(){
    Deps.autorun(function(){
        var show = AmplifiedSession.equals('showMessageForm', true);

        if(show){
            $('#messageFormWrapper').show(300);
        }else{
            $('#messageFormWrapper').hide(300);
        }
    });
};