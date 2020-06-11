'use strict';

function generateTemplate (stateName, controllerName, controllerAs, dest) {
    var start = '';

        start += '<ion-view>\n';
        start += '<ion-nav-title>' + stateName + '</ion-nav-title>\n';
        start += '  <ion-content>\n';

    var finish = '  </ion-content>\n';
        finish += '</ion-view>';

    var template = '';

    template += start;

    // add state name
    template += '  ' + 's: ' + stateName + '\n';

    // add controller name
    template += '  ' + '<br>c: {{' + controllerAs + '.controllerName' + '}}' + '\n';

    template += finish;

    if(dest && dest.template){
        dest.template = template;
        return dest;
    } else {
        return template;
    }
}

function generateController (controllerName, controllerAs, dest) {
    var controllerString = controllerName + ' as ' + controllerAs;

    if(dest && dest.controller){
        dest.controller = controllerString;
        return dest;
    } else {
        return controllerString;
    }

}

module.exports = function placeholderStateHelper (stateName, controllerName, controllerAs){
    if (!stateName || !controllerName || !controllerAs) {
        throw new Error('state helper generator: missing/invalid stateName, controllerName or controllerAs');
    } else {
        var output = {
            name: stateName,
            template: '',
            controller: controllerName
        };

        output.template = generateTemplate(stateName, controllerName, controllerAs);
        output.controller = generateController(controllerName, controllerAs);

        return output;
    }
};
