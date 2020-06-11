var React=require('react');
var NavLink=require('./NavLink');
var Navbar=React.createClass({

render:function()
{
    return(
<div>
  <div className="container-fluid">

        <ul className="nav navbar-nav">
          <li>
            <NavLink to="/home">Home</NavLink>
          </li>
          <li>
            <NavLink to="/about">AboutUs</NavLink>
          </li>
          <li>
            <NavLink to="/moviebox">Movie</NavLink>
          </li>
          <li>
            <NavLink to="/learn/react">Learn React</NavLink>
          </li>
          <li>
            <NavLink to="/learn/mern">Learn Mern</NavLink>
          </li>
          <li>
            <NavLink to="/allmovie">All Movie</NavLink>
          </li>
        </ul>
      </div>
      </div>
    );
}
});

module.exports=Navbar;
