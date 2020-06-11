var nav = document.getElementById('navLinks');

var button =  document.getElementById('navButton');

button.addEventListener('click', function(){
    nav.classList.toggle('hideNav');
    nav.classList.toggle('showNav');
});

(function(){
    classSwitch();
}("docReady", window));

window.addEventListener('resize', classSwitch);

function classSwitch(){
    var width = window.innerWidth;
    if(width <= 768){
        nav.classList.add('hideNav');
        nav.classList.remove('showNav');
    }else{
        nav.classList.add('showNav');
        nav.classList.remove('hideNav');
    }
}