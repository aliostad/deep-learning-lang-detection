import axios from "axios";

const mockAPIURL = 'http://58aa72ba5d517412004a56a7.mockapi.io/v1/articles';

export function fetchArticles() {
  return function(dispatch) {
    axios.get(mockAPIURL+'?sortBy=id&order=desc')
      .then((response) => {
        dispatch({type: "FETCH_ARTICLES", payload: response.data})
      })
      .catch((err) => {
        dispatch({type: "API_REJECTED", payload: err})
      })
  }
}

export function fetchingStarted(){
    return function(dispatch){
        dispatch({type: "LOADING_ARTICLES", payload: true})
    }
}

export function addArticle(article){
    return function(dispatch){
        axios.post(mockAPIURL,article)
        .then(function (response) {
            window.location = '/dashboard'
        })
        .catch(function (error) {
            dispatch({type: "API_REJECTED", payload: error})
        });
    }
}


export function updateArticle(articleId,article){
    return function(dispatch){
        axios.put(mockAPIURL+'/'+articleId,article)
        .then(function (response) {
            dispatch({type: "FETCH_ARTICLES", payload: response.data})
        })
        .catch(function (error) {
            dispatch({type: "API_REJECTED", payload: error})
        });
    }
}



export function deleteArticle(articleId){
    return function(dispatch){
        axios.delete(mockAPIURL+'/'+articleId)
        .then(function (response) {
            dispatch({type: "FETCH_ARTICLES", payload: response.data})
        })
        .catch(function (error) {
            dispatch({type: "API_REJECTED", payload: error})
        });
    }
}