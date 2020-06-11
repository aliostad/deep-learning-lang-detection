import alt from '../alt';

class ElasticActions {
  constructor() {
  }

  doQuery(args) {
    this.dispatch(args)
  }

  codeChanged(args) {
    this.dispatch(args)
  }

  reformatCode(args) {
    this.dispatch(args)
  }

  refreshIndexes(args) {
    this.dispatch(args)
  }

  setIndex(args) {
    this.dispatch(args)
  }

  setType(args) {
    this.dispatch(args)
  }

  refreshTypes(args) {
    this.dispatch(args)
  }

  codeChangedYaml(args) {
    this.dispatch(args)
  }

  jsonTabSelected(args) {
    this.dispatch(args)
  }
  yamlTabSelected(args) {
    this.dispatch(args)
  }

}

export default alt.createActions(ElasticActions)

