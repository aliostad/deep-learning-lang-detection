'use strict';

const m = require('./dummy-api');
function logFactory(prefix){
  const st = process.hrtime();
  return (msg) => {
    const end = process.hrtime(st);
    return console.log(`${prefix}${end[0]}.${end[1]}\n${prefix}\t${msg.split("\n").join(`\n${prefix}\t`)}`);
  };
}
function captureAPI(log, prefix) {
  return (result) => {
    prefix = prefix || result.api;
    {
      let data = Object.assign({}, result);
      delete data.api;
      log(`${prefix}: ${JSON.stringify(data)}`);
    }
    return result;
  };
}

{
  const dummyAPI = new m.DummyAPIFactory().dummyAPI(300);
  const log = logFactory("*");
  log("start");
  Promise.resolve(1)
    .then((i) => dummyAPI(i))
    .then(captureAPI(log))
    .then((data) => dummyAPI(10, data))
    .then(captureAPI(log))
    .then(() => {
      log("finish");
    });
  log("end");
}

// nocache
{
  const factory = new m.DummyAPIFactory();
  const dummyAPI = factory.dummyAPI(300);
  const log = logFactory("$");
  Promise.all([
    dummyAPI(100).then(captureAPI(log)),
    dummyAPI(100).then(captureAPI(log))
  ])
    .then(captureAPI(log, "merged"));
}
// cached
{
  const factory = new m.DummyAPIFactory();
  const dummyAPI = factory.dummyAPI(300);
  const cachedAPI = factory.cachedAPI(dummyAPI);
  const log = logFactory("@");
  Promise.all([
    cachedAPI(100).then(captureAPI(log)),
    cachedAPI(100).then(captureAPI(log))
  ])
    .then(captureAPI(log, "merged"));
}
// bad cache
{
  const factory = new m.DummyAPIFactory();
  const dummyAPI = factory.dummyAPI(300);
  const cachedAPI = factory.badCachedAPI(dummyAPI);
  const log = logFactory("#");
  Promise.all([
    cachedAPI(100).then(captureAPI(log)),
    cachedAPI(100).then(captureAPI(log))
  ])
    .then(captureAPI(log, "merged"));
}
{
  const factory = new m.DummyAPIFactory();
  const dummyAPI = factory.dummyAPI(300);
  const mergeAPI = factory.mergeAPI(300);
  const cachedAPI = factory.cachedAPI(dummyAPI);
  const log = logFactory("%");
  const ps = dummyAPI(1).then(captureAPI(log));
  Promise.all([
    ps.then((data) => cachedAPI(2, data)).then(captureAPI(log)),
    ps.then((data) => cachedAPI(2, data)).then(captureAPI(log))
  ])
    .then((vs) => mergeAPI(1, vs))
    .then(captureAPI(log));
}
// convert is also async.
// hmm?関数でwrapしてくっつけてあげるだけで大丈夫?複数のasync actionの結果のmerge
// だめっぽいよね？
