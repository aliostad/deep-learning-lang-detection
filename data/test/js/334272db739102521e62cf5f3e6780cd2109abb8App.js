import React from 'react'

import Feed from './Feed'

export default class App extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      show: true
    }
  }

  toggleShow() {
    this.setState({
      show: !this.state.show
    })
  }

  render() {
    const toggleLabel = this.state.show ? 'Hide' : 'Show'

    return (
      <div>
        <h1>
          Feed <button onClick={this.toggleShow.bind(this)}>{toggleLabel}</button>
        </h1>

        {this.state.show && <Feed />}
      </div>
    )
  }
}
