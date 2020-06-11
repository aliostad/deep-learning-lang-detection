import {Component, PropTypes, Children} from 'react'

export class Provider extends Component {
    static propTypes = {
        store: PropTypes.any,
        children: PropTypes.element.isRequired
    };

    static childContextTypes = {
        store: PropTypes.any,
        rootScopeDispatch: PropTypes.func.isRequired,
        parentScopeDispatch: PropTypes.func.isRequired,
        selfScopeDispatch: PropTypes.func.isRequired
    };

    constructor(props, context) {
        super(props, context)
        this.store = props.store
    }

    getChildContext() {
        const dispatch = this.store.global.dispatch
        return {
            store: this.store,
            rootScopeDispatch: dispatch,
            parentScopeDispatch: dispatch,
            selfScopeDispatch: dispatch
        }
    }

    render() {
        const {children} = this.props
        return Children.only(children)
    }
}
