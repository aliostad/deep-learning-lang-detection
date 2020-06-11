import { connect } from 'react-redux';
import { setVisibleContent, selectMainLink, defaultInputMode } from '../actions';
import * as CONSTANTS from '../components/CONSTANTS';
import LeftMenuBar from '../components/LeftMenuBar';


const setDefault = (e, dispatch) => {
  e.preventDefault();
  dispatch(defaultInputMode());
};

const mapDispatchToProps = dispatch => ({
  onHomeClick: (e) => {
    dispatch(setVisibleContent([CONSTANTS.MAIN_LINK_LIST]));
    dispatch(selectMainLink(false));
    setDefault(e, dispatch);
  },
  onMainLinkFormClick: (e) => {
    dispatch(setVisibleContent([CONSTANTS.MAIN_LINK_FORM]));
    setDefault(e, dispatch);
  },
  onMainLinkListClick: (e) => {
    dispatch(setVisibleContent([CONSTANTS.MAIN_LINK_LIST]));
    setDefault(e, dispatch);
  },
  onSubLinkFormClick: (e) => {
    dispatch(setVisibleContent([CONSTANTS.SUB_LINK_FORM]));
    setDefault(e, dispatch);
  },
});

const LeftMenu = connect(
  undefined,
  mapDispatchToProps,
)(LeftMenuBar);

export default LeftMenu;
