export function readDocuments() {
  return (dispatch) => {
    dispatch({ type: 'DOCUMENTS_READ_S' })
  }
}


export function createEmptyDocument(title, docType) {
  return (dispatch) => {
    dispatch({
      type: 'DOCUMENT_CREATE_S',
      title,
      docType
    })
  }
}


export function readDocument(_id) {
  return (dispatch) => {
    dispatch({
      type: 'DOCUMENT_READ_S',
      document: { _id }
    })
  }
}

export function updateDocument(doc) {
  return (dispatch) => {
    dispatch({
      type: 'DOCUMENT_UPDATE_S',
      document: doc
    })
  }
}


export function removeDocument(doc) {
  return (dispatch) => {
    dispatch({
      type: 'DOCUMENT_REMOVE_S',
      document: doc
    })
  }
}
