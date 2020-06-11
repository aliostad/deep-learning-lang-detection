import React from 'react';
import { connect } from 'react-redux';
import { SHOW_ALL , SHOW_ACTIVE , SHOW_COMPLETED } from '../actions/visibilityfilter';

function FooterLink({dispatch}) {

 
       
 return(

        <div className="btn-group btn-group-justified">

		   <a onClick={
			   	() => {
			   		SHOW_ALL_HANDLER(dispatch);
			   	}
		   }
		    href="javascript:void(0);" className="btn btn-warning">SHOW ALL</a>

		    <a onClick={
			   	() => {
			   		SHOW_ACTIVE_HANDLER(dispatch);
			   	}
		   } href="javascript:void(0);" className="btn btn-info">SHOW ACTIVE</a>

			<a onClick={
			   	() => {
			   		SHOW_COMPLETE_HANDLER(dispatch);
			   	}
		   } href="javascript:void(0);" className="btn btn-success">SHOW COMPLETED</a>

		</div>

       );

     

}
function SHOW_ALL_HANDLER(dispatch){
	dispatch(SHOW_ALL());
}
function SHOW_ACTIVE_HANDLER(dispatch){
	dispatch(SHOW_ACTIVE());
	
}
function SHOW_COMPLETE_HANDLER(dispatch){
	dispatch(SHOW_COMPLETED());
	
}
export default connect()(FooterLink);