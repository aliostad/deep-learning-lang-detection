function navJS() {
    var nav = document.getElementsByTagName('nav');
    nav[0].className = 'navOff';
}

function toggleNav() {
    var header = document.getElementsByTagName('header');
    var nav = document.getElementsByTagName('nav');
    var navToggle = document.getElementById('navToggle')
    function getPositionValue(obj){
        if (obj.currentStyle) {
            return obj.currentStyle['position'];
        }
        else if (window.getComputedStyle) {
            var objStyle = window.getComputedStyle(obj, "");
            return objStyle.getPropertyValue('position');
        }
        else {
            return '-1'
        }
    }
    if (nav[0].className == 'navOff') {
        navToggle.className = 'toggleOn';
        if (getPositionValue(header[0]) == 'fixed') {
            nav[0].className = 'navFixed';
        }
        else {
            nav[0].className = 'navAbsolute';
        }
    }
    else {
        navToggle.className = 'toggleOff';
        nav[0].className = 'navOff';
    }
}