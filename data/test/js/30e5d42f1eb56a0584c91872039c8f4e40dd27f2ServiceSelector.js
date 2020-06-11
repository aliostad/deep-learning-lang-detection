/*Select Open311 service
    args: open311 services.json
*/

var ServiceSelector = {
  controller: function(serviceList, loadFunction) {
    loadFunction();
    this.serviceList = serviceList;

    this.update = function(e){
      open311.service_code(e.target.value);
    };
  },
  view: function(ctrl) {
  //add empty option to service list
    var serviceList =  [{service_name:"---", service_code: "-1"}].concat(ctrl.serviceList());
    return m("div", [
      m.component(InputLabel, {name: "Service", icon: "tags"}),
      m("select", {onchange: ctrl.update, class: "input"}, serviceList.map(function(option){
        return m("option", {value: option.service_code}, option.service_name);
      }))
    ]);
  }
};
