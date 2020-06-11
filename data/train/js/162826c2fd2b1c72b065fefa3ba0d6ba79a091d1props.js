/**
 * Created by liangkuaisheng on 15/11/23.
 */

"use strict";

import * as ACT from './actions';

/**
 * 属性
 * */

export function mapStateToProps(state)  {
    return {
        imgcode: state.ImgCode.url,
        btnstatus: state.BtnState.status
    };
}

/**
 * 操作
 * */

export function mapDispatchToProps(dispatch) {
    return {
        dispatch,
        // 更新验证码
        changeImgCode: () => dispatch(ACT.sImgCode),
        // 按钮禁止
        btnEnable: () => dispatch(ACT.sBtnEnable),
        btnDisable: () => dispatch(ACT.sBtnDisable),
        login: data => dispatch(ACT.fPostLogin(data))
    };
}