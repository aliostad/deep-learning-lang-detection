goog.provide('cljs.core.async.impl.dispatch');
goog.require('cljs.core');
cljs.core.async.impl.dispatch.message_channel = null;
cljs.core.async.impl.dispatch.tasks = null;
if(typeof MessageChannel !== 'undefined')
{cljs.core.async.impl.dispatch.message_channel = (new MessageChannel());
cljs.core.async.impl.dispatch.tasks = [];
cljs.core.async.impl.dispatch.message_channel.port1.onmessage = (function (msg){
return cljs.core.async.impl.dispatch.tasks.shift().call(null);
});
} else
{}
cljs.core.async.impl.dispatch.queue_task = (function queue_task(f){
cljs.core.async.impl.dispatch.tasks.push(f);
return cljs.core.async.impl.dispatch.message_channel.port2.postMessage(0);
});
cljs.core.async.impl.dispatch.run = (function run(f){
if(typeof MessageChannel !== 'undefined')
{return cljs.core.async.impl.dispatch.queue_task.call(null,f);
} else
{if(typeof setImmediate !== 'undefined')
{return setImmediate(f);
} else
{if("\uFDD0:else")
{return setTimeout(f,0);
} else
{return null;
}
}
}
});
cljs.core.async.impl.dispatch.queue_delay = (function queue_delay(f,delay){
return setTimeout(f,delay);
});
