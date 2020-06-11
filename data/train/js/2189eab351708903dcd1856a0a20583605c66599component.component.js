import './<%= name %>.styl';
import {<%= upCaseName %>Component as controller} from './<%= name %>.component';
import {<%= upCaseService %>Service as <%= service %>Service} from './<%= service %>.service';
import template from './<%= name %>.html';

export const <%= name %>Directive = ()=> {
  return {
    controller,
    template,
    controllerAs: 'vm',
    scope: {},
    replace: true,
    restrict: 'E'
  }
};

class <%= upCaseName %>Component {
  constructor(<%= service %>Service) {
    this.greeting = '<%= upCaseName %>Component!';
    this.service = <%= service %>Service;
    this.serviceData = [];
  }

  queryService() {
  	/* The this.service.query() call returns a promise. 
  		Using an arrow function points 'this' to the class
  		context not the function context in ES5 */
  	// this.service.query()
		// .then(result => this.serviceData = result.data);
  }

}

<%= upCaseName %>Component.$inject = ['<%= service %>Service'];

export {<%= upCaseName %>Component};
