'use strict';

module.exports = {
  brief: function() {
    return [
      {
        showEN: "hello, have fun with keying or clicking down !",
        showTW: "您好, 依序輸入或點擊下方文字將會有有趣事情發生唷 !"
      }
    ]
  },
  menu: function() {
    return [
      {
        title:  "lang",
        state:  "completed",
        showEN: "/ 中文版",
        showTW: "/ English"
      }, {
        title:  "aboutsite",
        state:  "padding",
        showEN: "about website",
        showTW: "關於<br>這個網站"
      }, {
        title:  "msgboard",
        state:  "completed",
        showEN: "message board",
        showTW: "留言板"
      }, {
        title:  "aboutme",
        state:  "completed",
        showEN: "more me",
        showTW: "認識<br>更多的我"
      }, {
        title:  "cv",
        state:  "completed",
        showEN: "CV",
        showTW: "簡歷"
      }
    ];
  }
};
