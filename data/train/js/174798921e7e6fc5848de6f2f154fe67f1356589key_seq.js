var navKeys = 'asdfjkl'
var lastNavSeq = ''

function resetNavSeq(count) {
  var digits = 1;
  while (true) {
    var p = Math.pow(navKeys.length, digits)
    if (count <= p) {
      break
    }

    digits += 1
    count -= p
  }

  lastNavSeq = ''
  for (var i = 0; i < digits; i++) {
    lastNavSeq += navKeys[0]
  }
}

function nextNavSeq() {
  lastNavSeq = _generateNextNavSeq(lastNavSeq)
  return lastNavSeq
}

function isNavChar(ch) {
  return navKeys.indexOf(ch) >= 0
}

function _generateNextNavSeq(seq) {
  if (!seq) {
    return navKeys[0]
  }

  for (var i = 0; i < seq.length; i++) {
    var next = _nextKey(seq[i])
    if (next) {
      return seq.substr(0, i) + next + seq.substr(i + 1)
    } else {
      return navKeys[0] + _generateNextNavSeq(seq.substr(1))
    }
  }
}

function _nextKey(key) {
  var index = navKeys.indexOf(key)
  if (index == navKeys.length - 1) {
    return ''
  }
  return navKeys[index + 1]
}
