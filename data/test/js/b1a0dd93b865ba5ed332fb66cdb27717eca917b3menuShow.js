const initialState = {
  showFontMenu: false,
  showDivMenu: false,
  showTemplateMenu: false,
  showUploadMenu: false
}

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case "SHOW_FONTMENU":
      return {...state, showFontMenu: action.show};
    case "SHOW_DIVMENU":
      return {...state, showDivMenu: action.show};
    case "SHOW_TEMPLATEMENU":
      return {...state, showTemplateMenu: action.show};
    case "SHOW_UPLOADMENU":
      return {...state, showUploadMenu: action.show};
    default:
      return state;
  }
}

export default reducer;