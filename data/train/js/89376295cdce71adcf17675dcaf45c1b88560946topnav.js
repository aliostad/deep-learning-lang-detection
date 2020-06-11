var React = require("react"),
	Link = require("react-router").Link;

var TopNav = React.createClass({
	render: function(){
		var navItems = {
				"/": "Dashboard",
				"/exchange-rate": "Exchange rate",
				"/current-block": "Current Block",
				"/transactions": "Transactions"
			},
			nav = Object.keys(navItems).map(function(route, i){
				var title = navItems[route];
				return (
					<Link to={route} key={i} title={title}>{title}</Link>
				);
			}, this);

		return (
			<nav>
				{nav}
			</nav>
		);
	}
});

module.exports = TopNav;
