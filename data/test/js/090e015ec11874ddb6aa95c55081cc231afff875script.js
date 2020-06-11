para=document.getElementById('message');


function show(msg){
	para.innerHTML+='<p>'+msg+'</p>';
}

//Window methods
show('name: '+window.name);
show('inwidth: '+window.innerWidth);
show('inheight: '+window.innerHeight);
show('outwidth: '+window.outerWidth);
show('screenx: '+window.screenX);
show('screeny: '+window.screenY);
window.scrollTo(0, 100);
show('xoff: '+window.pageXOffset);
show('yoff: '+window.pageYOffset);

//Opening a popup and displaying its information
var n = window.open('http://www.google.com', 'myname', 'width=400, height=300, toolbar=0, screenX=400, screenY=500');
show('name: '+n.window.name);
show('inwidth: '+n.innerWidth);
show('inheight: '+n.innerHeight);
show('outwidth: '+n.window.outerWidth);
show('screenx: '+n.window.screenX);
show('screeny: '+n.window.screenY)