console.log('#### App Component');

var React = require('react');

var Router = require('react-router');
var RouteHandler = Router.RouteHandler;

var navComponents = require('./nav/NavComponents');
var TopNav = navComponents.topNav();
var SideNav = navComponents.sideNav();

module.exports = {
	AppComponent: function() {
		var AppComponent = React.createClass({
			render: function() {
				return (
					<div className="container">
						<div className="nav-content">
							<TopNav />
							<SideNav />
						</div>
						<div className="states-content">
							<RouteHandler {...this}/>
						</div>
					</div>
				)
			}
		});
		return AppComponent;
	}
}