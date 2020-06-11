module.exports = {
  user : {
    eid: {show: 0, check: ['number']},
    sex: {show: 1, check: ['number']},
    username: {show: 1, check: ['string']},
    password: {show: 0, check: ['password']},
    email: {show: 1, check: ['email']},
    jointime: {show: 1, check: ['time']},
    leavetime: {show: 1, check: ['time']},
    tel_extension: {show: 1, check: ['number']},
    telephone: {show: 1, check: ['number']},
    deparyment: {show: 1, check: ['number']},
    position: {show: 1, check: ['string']},
    wangwang: {show: 1, check: ['string']},
    qq: {show: 1, check: ['string']},
    inoffice: {show: 0, check: ['boolean']},
    type: {show:0, check:[0, 1]}
  },
  work: {
    wid: {show: 0, check: ['number']},
    jointime: {show: 1, check: ['time']},
    starttime: {show: 1, check: ['time']},
    needtime: {show: 1, check: ['time']},
    endtime: {show: 1, check: ['time']},
    status: {show: 1, check: [0, 1, 2, 3, 4]},
    eid: {show: 0, check: ['number']},
    request: {show: 1, check: ['string']},
    content: {show: 1, check: ['string']},
    title: {show: 1, check: ['string']},
    link: {show: 1, check: ['url']}
  },
  alibaba_workers:{
    alibaba_id: {show: 0, check: ['number']},
    username: {show: 1, check: ['string']},
    wangwang: {show: 1, check: ['string']},
    email: {show: 1, check: ['email']},
    tel_extension: {show: 1, check: ['number']},
    telephone: {show: 1, check: ['number']},
    deparyment: {show: 1, check: ['number']},
    interface_person: {show: 1, check: ['string']}
  },
  check: function(){
  	return true;
  }
}