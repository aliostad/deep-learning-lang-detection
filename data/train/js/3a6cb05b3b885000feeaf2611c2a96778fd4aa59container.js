import React from "react";
import {connect} from "react-redux";
import {Edit, Delete} from "./view";
import {Map} from "immutable";
import * as modalAction from "../modal/action";


export const EditContainer = connect(
    (state) => {
        return {};
    },
    (dispatch, router) => {
        return {
            submit: (data, action) => {
                dispatch(action);
                dispatch(modalAction.closemodal())
            },
            cancel: () => {
                dispatch(modalAction.closemodal())
            }

        }
    }
)
(Edit);

export const DeleteContainer = connect(
    (state, router) => {
        return {}
    },
    (dispatch, router) => {
        return {
            validate: (action) => {
                dispatch(action);
                dispatch(modalAction.closemodal())
            },
            cancel: () => {
                dispatch(modalAction.closemodal())
            }

        }
    }
)(Delete);