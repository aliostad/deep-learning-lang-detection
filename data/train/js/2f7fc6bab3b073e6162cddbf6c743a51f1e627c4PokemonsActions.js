
import axios from "axios";


export function fetchPokemons() {
	return function(dispatch) {
		dispatch({type:"FETCH_POKEMONS"});
		axios.get("http://localhost:3000/pokemons").then((response) => {
			
			if(response){	
				dispatch({type:"FETCH_POKEMONS_FULFILLED",payload:response.data});
			}
		}).catch((err) => {
			dispatch({type:"FETCH_POKEMONS_ERROR",payload:err})
		})	
	}


}

export function lookForPokemons(text) {
	return function(dispatch) {
			dispatch({type:"LOOKFOR_POKEMONS"});
		axios.get("http://localhost:3000/search?name="+text).then((response) => {
			
			if(response){	
				dispatch({type:"LOOKFOR_POKEMONS_FULFILLED",payload:response.data});
			}
		}).catch((err) => {
			dispatch({type:"LOOKFOR_POKEMONS_ERROR",payload:err})
		})	
	}


	}

export function lookForPokemonsById(id) {
	return function(dispatch) {
			dispatch({type:"LOOKFOR_POKEMONS"});
		axios.get("http://localhost:3000/search?id="+id).then((response) => {
			console.log("response: "+JSON.stringify(response.data))
			if(response){	
				dispatch({type:"LOOKFOR_POKEMONS_FULFILLED",payload:response.data});
			}
		}).catch((err) => {
			dispatch({type:"LOOKFOR_POKEMONS_ERROR",payload:err})
		})	
	}


	}
export function PokemonStats(pokeid,types){
	return function(dispatch) {
	dispatch({type:"COMPARE_POKEMONS"});
	console.log("URL: "+"http://localhost:3000/compare?id="+pokeid+"&types="+types);
			axios.get("http://localhost:3000/compare?id="+pokeid+"&types="+types).then((response) => {
				console.log("response: "+JSON.stringify(response.data))
				if(response){	
					dispatch({type:"COMPARE_POKEMONS_FULFILLED",payload:response.data});
				}
		}).catch((err) => {
				dispatch({type:"COMPARE_POKEMONS_ERROR",payload:err})
		})
	}	
}

export function LikePokemons(pokeid,bool){
	return function(dispatch) {
	dispatch({type:"LIKE_POKEMONS"});
	console.log("URL: "+"http://localhost:3000/like?id="+pokeid+"&bool="+bool);
			axios.get("http://localhost:3000/like?id="+pokeid+"&bool="+bool).then((response) => {
				if(response){	
					dispatch({type:"LIKE_POKEMONS_FULFILLED",payload:response.data});
				}
		}).catch((err) => {
				dispatch({type:"LIKE_POKEMONS_ERROR",payload:err})
		})
	}	
}
