import * as HTTPUtil from '../../../../../components/fetch'
import * as ActionTypes from './ActionTypes'
const wechatData = data => ({
    type : ActionTypes.WECHART,
    data : data
})

export const changeName =(name) => dispatch => {
    dispatch({
        type : ActionTypes.Change_Name,
        name: name
    })
}
export const changePeople =(userSelectGroupId) => dispatch => {
    dispatch({
        type : ActionTypes.Change_userSelectGroupId,
        userSelectGroupId: userSelectGroupId
    })
}

export const changeTitle =(title) => dispatch => {
    dispatch({
        type : ActionTypes.Change_Title,
        title: title
    })
}
export const changeContent =(content) => dispatch => {
    dispatch({
        type : ActionTypes.Change_Content,
        content: content
    })
}
export const changeLogo =(logo) => dispatch => {
    dispatch({
        type : ActionTypes.Change_Logo,
        logo: logo
    })
}
export const changeUrl =(linkurl) => dispatch => {
    dispatch({
        type : ActionTypes.Change_Url,
        linkurl: linkurl
    })
}
export const changePic =(index,pic) => dispatch => {
    dispatch({
        type : ActionTypes.Change_Pic,
        pic: pic,
        index:index
    })
}
export const changeTxt =(txt,index) => dispatch => {
    dispatch({
        type : ActionTypes.Change_Txt,
        txt: txt,
        index:index
    })
}
export const addPic =(pic,txt) => dispatch => {
    dispatch({
        type : ActionTypes.Add_Pic,
        pic: pic,
        txt: txt
    })
}
export const removeData =(data) => dispatch => {
    dispatch({
        type : ActionTypes.REMOVE_DATA,
        data : data
    })
}

export const addTxt =(short) => dispatch => {
    dispatch({
        type : ActionTypes.Add_Short,
        short: short
    })
}
export const oDelete =(index) => dispatch => {
    dispatch({
        type : ActionTypes.Delete_file,
        index: index
    })
}
export const setFileString = (file) => dispatch => {
    dispatch({
        type : ActionTypes.File_String,
        file:file
    })
}
export const setUrl = (url) => dispatch => {
    dispatch({
        type : ActionTypes.Set_Url,
        url:url
    })
}

//保存数据
export const commitWechat = (data) => dispatch => {
    let url = "/activity/save";
    return dispatch(HTTPUtil.fetchGet(url, data, null))
}


//推送人群
export const getUserList = () => dispatch => {
    let url = "/portrayal/collection/allList";
    return dispatch(HTTPUtil.fetchGet(url, null, null))
}

