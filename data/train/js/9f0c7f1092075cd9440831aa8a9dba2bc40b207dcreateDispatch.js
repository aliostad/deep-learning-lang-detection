import { is } from './util';

export default function createDispatch (originDispatch) {
    return function dispatch (actionType, payload, meta) {
        // 这边是为了兼容社区方案，允许直接传入一个 action 对象，比如路由跳转：
        // send(push('/a/b'))

        if (is.obj(actionType) && is.str(actionType.type)) {
            const externalAction = actionType;
            return originDispatch(externalAction);
        }

        const action = {
            type: actionType
        };

        action.payload = payload;
        action.meta = meta;

        return originDispatch(action);
    }
}
