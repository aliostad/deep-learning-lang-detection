import BaseStore from 'fluxible/addons/BaseStore';

export default class MessageStore extends BaseStore {
    static get storeName() {
        return 'MessageStore';
    }
    static get handlers() {
        return {
            'MESSAGE_ACTION': 'handleMessage'
        };
    }

    initialize() {
        this._message = null;
    }

    handleMessage(payload) {
        this._message = payload;
        this.emitChange();
    }

    get message() {
        return this._message;
    }

    dehydrate() {
        return {
            message: this.message
        };
    }
    rehydrate(state) {
        this._message = state.message;
    }

}