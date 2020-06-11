var locomotive = require('locomotive')
    , Controller = locomotive.Controller;

var pagesController = new Controller();

pagesController.main = function () {
    this.render();
}

pagesController.thankyou = function () {
    this.render();
}

pagesController.postemail = function () {
    var controller = this;

    var email = {
        email: controller.req.body.email,
        created: new Date()
    }

    MELRegisterInterest.create(email, function(err, ri){
        controller.redirect('/thankyou')
    })

}

module.exports = pagesController;
