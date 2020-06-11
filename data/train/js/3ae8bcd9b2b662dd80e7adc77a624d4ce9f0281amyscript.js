var navItem1 = document.getElementById('item1');
var navItem2 = document.getElementById('item2');
var navItem3 = document.getElementById('item3');
var tab1 = document.getElementById('tab1');
var tab2 = document.getElementById('tab2');
var tab3 = document.getElementById('tab3');

    navItem1.onclick = function(){
        this.className = 'item_active nav_item';
        navItem2.className = 'nav_item';
        navItem3.className = 'nav_item';
        tab1.style.visibility = 'visible';
        tab2.style.visibility = 'hidden';
        tab3.style.visibility = 'hidden';
}
    navItem2.onclick = function(){
        this.className = 'item_active nav_item';
        navItem1.className = 'nav_item';
        navItem3.className = 'nav_item';
        tab2.style.visibility = 'visible';
        tab1.style.visibility = 'hidden';
        tab3.style.visibility = 'hidden';
}
    navItem3.onclick = function(){
        this.className = 'item_active nav_item';
        navItem1.className = 'nav_item';
        navItem2.className = 'nav_item';
        tab3.style.visibility = 'visible';
        tab2.style.visibility = 'hidden';
        tab1.style.visibility = 'hidden';
}