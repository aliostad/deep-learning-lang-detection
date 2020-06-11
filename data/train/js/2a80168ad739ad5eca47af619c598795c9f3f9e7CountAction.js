import {AppDispatcher} from '../dispatcher/AppDispatcher';
import {CountConstants} from '../constants/CountConstants';


export var CountAction = {
    onChangeUp : function(){
      AppDispatcher.dispatch({
        actionType: CountConstants.DISPATCH_CHANGE_UP
      });
    },
    onChangeDown : function(){
      AppDispatcher.dispatch({
        actionType: CountConstants.DISPATCH_CHANGE_DOWN
      })
    },
    onChangeReset : function(){
      AppDispatcher.dispatch({
        actionType: CountConstants.DISPATCH_CHANGE_RESET
      })
    }
};
