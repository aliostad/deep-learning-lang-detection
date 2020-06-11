;(function () {
  var navProf = document.getElementById('nav-prof')
    , navDev = document.getElementById('nav-dev')
    , navWrite = document.getElementById('nav-write')

  if (document.getElementById(navProf.getAttribute('href').replace(/\/#/, '')))
    bind('click', navProf, navScroller)

  if (document.getElementById(navDev.getAttribute('href').replace(/\/#/, '')))
    bind('click', navDev, navScroller)

  if (document.getElementById(navWrite.getAttribute('href').replace(/\/#/, '')))
    bind('click', navWrite, navScroller)
}())
