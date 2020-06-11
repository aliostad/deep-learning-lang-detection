// inspired by https://gist.github.com/james2doyle/5694700

var nav_button,
    nav_anchorList,
    nav_index = 0 ,
    nav_anchorLen,
    nav_startY,
    nav_destinationY,
    nav_currentDiffY,
    nav_event = 'click',
    nav_duration = 500,
    nav_startTime,
    nav_currentTime,
    nav_timeIncrement = 20,
    nav_callback = updateArrowDirection,
    // figure out if this is moz || IE because they use documentElement
    nav_doc = (navigator.userAgent.indexOf('Firefox') != -1 || navigator.userAgent.indexOf('MSIE') != -1) ? document.documentElement : document.body;

toolBox.readyAndWilling(initNavJumper) ;

function initNavJumper ()
{
    'use strict' ;
    nav_button = document.querySelector('.js-nav-jumper__button');
    nav_anchorList = document.querySelectorAll('section');
    nav_anchorLen = nav_anchorList.length  ;

    

    // set current index.
    refreshCursorIndex();

    if (nav_button.addEventListener) 
    { nav_button.addEventListener(nav_event, nav_clickHandler); } 
    else 
    {
        nav_button.attachEvent('on' + nav_event, function()
        { nav_clickHandler.call(nav_button); });
    }


    
}

function refreshCursorIndex()
{
    'use strict' ;
    nav_startY = nav_doc.scrollTop ;

    var anchor,
    anchorPos;
    nav_index = 0 ;
    while (nav_index<nav_anchorLen  )
    {
        anchor = nav_anchorList[nav_index] ;
        anchorPos = anchor.offsetTop ;
        if (nav_startY<anchorPos)
        { break ; }
        nav_index++;
    }

    updateArrowDirection();

    anchor = null;
    anchorPos = null ;
}

function updateArrowDirection()
{
    'use strict' ;
    nav_button.dataset.direction = (nav_index == nav_anchorLen) ? 'up' : 'down'
}

function nav_clickHandler(event)
{
    'use strict' ;
    refreshCursorIndex();

    if (nav_index == nav_anchorLen) 
    {
        nav_destinationY = 0 ;
        nav_index = 0 ;
    }
    else
    {
        var anchor = nav_anchorList[nav_index] ;
        nav_destinationY = anchor.offsetTop ;
        nav_index = nav_index+1 ;    
    }
    nav_startTime = null;
    nav_doScroll();
}


 
function nav_doScroll( ) 
{
 'use strict' ;
  nav_startY = nav_doc.scrollTop,
  nav_currentDiffY = nav_destinationY - nav_startY,
  nav_currentTime = 0;

  nav_animateScroll();
}

// see https://gist.github.com/james2doyle/5694700
function nav_animateScroll()
{
    'use strict' ;
    // increment the time
    nav_currentTime += nav_timeIncrement;
    // find the value with the quadratic in-out easing function
    var val = Math.easeInOutQuad(nav_currentTime, nav_startY, nav_currentDiffY, nav_duration);
    // move the document.body
    nav_doc.scrollTop = val;
    // do the animation unless its over
    if(nav_currentTime < nav_duration) {
      window.requestAnimationFrame(nav_animateScroll);
    } else {
      if (nav_callback && typeof(nav_callback) === 'function') {
        // the animation is done so lets callback
        nav_callback();
      }
    }
}
