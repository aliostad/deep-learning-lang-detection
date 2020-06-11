import React, { PropTypes as T } from 'react';
import 'normalize.css/normalize.css';
import 'react-mdl/extra/css/material.cyan-red.min.css';
import ShowItem from '../ShowItem/ShowItem';

import styles from './ShowList.scss';

class ShowList extends React.Component {
  static propTypes = {
  }
  render() {
    const shows = this.props.shows;
    return (
      <div>
        SHOWS
        {shows.map(function(show) {
          return <ShowItem key={show} show={show} />
        })}
      </div>
    );
  }
}

export default ShowList;
