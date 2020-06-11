if (Modernizr.touch) {
  ;(function () {
    var navBtn = document.getElementsByClassName('nav-expander')[0]
      , navList = document.getElementsByClassName('nav-list')[0]
      , navOpen = false

    navBtn.addEventListener('click', function (ev) {
      if (navOpen) {
        removeClass(navBtn, 'is-nav-expanded')
        removeClass(navList, 'is-nav-list-expanded')
        navOpen = false
      } else {
        addClass(navBtn, 'is-nav-expanded')
        addClass(navList, 'is-nav-list-expanded')
        navOpen = true
      }
    })
  }())
}
