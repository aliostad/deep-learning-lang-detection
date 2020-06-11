
function clearMessages()
{
    $("span.debugMessage").remove();
}
function debugMessage(text)
{
    if(typeof(debugMessageTimer)!='undefined')
        {
            clearTimeout(debugMessageTimer);
        }
    var message=$("<span>"+text+"</span>");
    var others=$("span.debugMessage");
    message.attr("class","debugMessage");
    
    message.css("top",((others.length+1)*1.5)+"em");
    message.css("right","1em");
    message.css("position","fixed");
    message.css("display","block");
    message.css("z-index","1000");
    message.css("background","lightblue");
    $("body").append(message);
    debugMessageTimer=setTimeout("clearMessages()",3000);
    message.on({
        click:
            function()
        {
        if(debugMessageTimer!=null)
            {
                clearTimeout(debugMessageTimer);
                $("span.debugMessage").css("background","pink");
                debugMessageTimer=null;
                
            }
            else
                {
                    $("span.debugMessage").remove();
                }
            
        }
    })
}