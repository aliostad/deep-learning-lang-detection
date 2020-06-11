import React, { Component } from 'react';
import style from './style.scss';
import Show from '../../api/slideshows/liveshowData';

export default class show extends Component {
  constructor(props) {
    super();
    this.state = {
      isLoading: false,
      showId: props.params.showId, // taken from the route
      currentShow : Show,
      slides: Show.slides
    };
  }

  componentDidMount() {
    $(window).trigger('resize');
    console.log('resize event fired');
    console.log(this.state.slides);
  }

  getCurrentSlide() {
    debugger;
    this.setState({'currentShow' : Show});
  }



  render() {
    console.log('Show was rendered');
    let currentShow = this.state.currentShow;

    let fname = "Edo";
    console.log(`My name is ${fname}`);

    return(
    <div>
        {currentShow.custom_text}
        welcome to the show page for slide {currentShow.showId}
    </div>
    );
  }
}
