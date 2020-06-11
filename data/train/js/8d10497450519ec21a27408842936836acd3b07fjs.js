window.onload = function() {
  var pre = document.getElementById("left")
  var next = document.getElementById("right")

  var showNum = 1

  var change = function(showNum) {

    var img = "img" + showNum
    var circle = "circle" + showNum
    document.getElementsByClassName('show')[0].className = "hidden"

    document.getElementById(img).className = "show"
  }

  pre.onclick = function() {
    showNum == 1 ? showNum = 5 : showNum = showNum - 1
    change(showNum)
  }
  next.onclick = function() {
    debugger
    showNum == 5 ? showNum = 1 : showNum = showNum + 1
    change(showNum)
  }

}


// document.getElementById('pre').onclick = function() {
//   show === 1 ? show = 5 : show = show - 1
//   window.change(show)
//   clearInterval(timer)
// }
// document.getElementById('next').onclick = function() {
//   show === 5 ? show = 1 : show = show + 1
//   window.change(show)
//   clearInterval(timer)
// }
