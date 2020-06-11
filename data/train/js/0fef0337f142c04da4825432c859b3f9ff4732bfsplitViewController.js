var util = require('util'),
    ViewController = require('./viewController.js');

function SplitViewController() {
    ViewController.apply(this, arguments); 
    this.view.element.style.display = '-webkit-flex';
}

util.inherits(SplitViewController, ViewController);

SplitViewController.prototype.setLeftViewController = function (viewController) {
    this.leftViewController = viewController;
    this.leftViewController.view.element.style.flex = '1';
    this.view.appendChild(this.leftViewController.view);
    
    this.leftViewController.parentViewController = this;
    if (this.leftViewController.viewDidLoad) {
        this.leftViewController.viewDidLoad();    
    }
};

SplitViewController.prototype.setRightViewController = function (viewController) {
    this.rightViewController = viewController;
    this.rightViewController.view.element.style.flex = '1';
    this.view.appendChild(this.rightViewController.view);
    
    this.rightViewController.parentViewController = this;
    if (this.rightViewController.viewDidLoad) {
        this.rightViewController.viewDidLoad();    
    }
};

module.exports = SplitViewController;