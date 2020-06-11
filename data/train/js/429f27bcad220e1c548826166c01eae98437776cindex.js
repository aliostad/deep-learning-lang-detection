/**
 * Created by hpfs on 25/07/2015.
 */


/**
 * @decription Visualizza la pagina di benvenuto
 * 
 * @returns {} 
 */
function WelcomeCtrl() {

}


/**
 * Assegnazione dei controller ad angular
 */
app
    .controller("MenuController", MenuCtrl)
    .controller("LoginController", LoginCtrl)
    .controller("WelcomeController", WelcomeCtrl)
    .controller("EventiIscrittiMultiplaController", EventiIscrittiMultiplaCtrl)
    .controller("EventiIscrittiController", EventiIscrittiCtrl)
    .controller("EventiEditController", EventiEditCtrl)
    .controller("EventiAddController", EventiAddCtrl)
    .controller("EventiListController", EventiListCtrl)
    .controller("CategorieEditController", CategorieEditCtrl)
    .controller('CategorieListController', CategorieListCtrl);