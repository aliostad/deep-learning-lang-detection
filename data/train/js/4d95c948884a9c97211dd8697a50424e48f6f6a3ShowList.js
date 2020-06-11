import React, { Component } from "react";

import Show from "./Show";

import "./ShowList.css";

function isTicketForShow(showDate) {
  return (ticket) => ticket.date === showDate;
}

class ShowList extends Component {
  render() {
    const tickets = Object.values(this.props.tickets);
    return <ul className="shows">
      {Object.values(this.props.shows).map((show) => {
        const ticketsForThisShow = tickets.filter(isTicketForShow(show.date));
        return <li key={show.date}>
          <Show
            {...show}
            tickets={ticketsForThisShow}
            addPerson={this.props.addPerson}
            chooseSong={this.props.chooseSong}
            url={show.url}
            location={show.location}
            removeShow={this.props.removeShow.bind(null, show.date)}
            removeSong={this.props.removeSong}
            removeTicket={this.props.removeTicket}
            runTheNumbers={this.props.runTheNumbers.bind(null, show)}
            venue={show.venue}
          />
        </li>;
      })}
    </ul>;
  }
}

export default ShowList;
