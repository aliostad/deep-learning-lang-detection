'use strict'
var dispatch = require('./lib/dispatch'),
    map = dispatch(require('./lib/map')),
    cat = dispatch(require('./lib/cat'))(),
    util = require('./lib/util'),
    compose = util.compose

module.exports = {
  compose: compose,
  iterable: require('./lib/iterable'),
  toArray: require('./lib/toArray'),
  dispatch: dispatch,
  map: map,
  filter: dispatch(require('./lib/filter')),
  remove: dispatch(require('./lib/remove')),
  take: dispatch(require('./lib/take')),
  takeWhile: dispatch(require('./lib/takeWhile')),
  drop: dispatch(require('./lib/drop')),
  dropWhile: dispatch(require('./lib/dropWhile')),
  cat: cat,
  mapcat: mapcat,
  partitionAll: dispatch(require('./lib/partitionAll')),
  partitionBy: dispatch(require('./lib/partitionBy'))
}

function mapcat(f){
  return compose(map(f), cat)
}
