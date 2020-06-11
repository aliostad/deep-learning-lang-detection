import React, { PropTypes } from 'react';

const Service = ({ activeService, service, title, onClick }) => {
  const active = activeService === title;
  const classes = active ? 'service-item service-item--active' : 'service-item';
  return (
    <li //eslint-disable-line
      className={classes}
      onClick={onClick}
      data-service={service}
    >{title}
    </li>);
};

Service.propTypes = {
  service: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  onClick: PropTypes.func.isRequired,
  activeService: PropTypes.string,
};

Service.defaultProps = {
  activeService: undefined,
};

export default Service;
