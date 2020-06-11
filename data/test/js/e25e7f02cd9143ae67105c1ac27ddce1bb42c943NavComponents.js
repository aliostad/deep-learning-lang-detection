console.log('#### Nav Components');

// ABSTRACT VIEW

var React = require('react');

module.exports = {

	// CSS - css/app-one/components/nav/top-nav.css
	topNav: function() {
		var TopNav = React.createClass({
			render: function() {
				return (
					<div className="top-nav">
						<p>Top Nav</p>
					</div>
				)
			}
		});
		return TopNav;
	},
	sideNav: function() {
		var SideNav = React.createClass({
			render: function() {
				return (
					<div className="side-nav">
						<p>Side Nav</p>
					</div>
				)
			}
		});
		return SideNav;
	}
}