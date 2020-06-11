import React , { Component } from 'react';
import { connect } from 'react-redux';


function Counter({counterData, dispatch}){
	return(
		<div>
			<input type="button" value="Increment" onClick={() => dispatch({type : 'INCREMENT'})}/>
			<span> {counterData} </span>
			<input type="button" value="Decrement" onClick={() => dispatch({type : 'DECREMENT'})}/>
		</div>
	)
}

function mapStateToProps(state){
	return {
		counterData : state.counterData	
	}
}

function mapDispatchToProps(dispatch){
	return {
		dispatch : dispatch
	}
}


export default connect(mapStateToProps, mapDispatchToProps)(Counter);




