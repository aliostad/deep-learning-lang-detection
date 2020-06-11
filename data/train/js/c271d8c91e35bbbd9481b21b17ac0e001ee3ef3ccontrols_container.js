import { connect } from 'react-redux';
import Controls from './controls';
import { clearSwitches } from '../../actions/switch_actions';
import { changeColumn } from '../../actions/column_actions';
import { startPlayback, stopPlayback } from '../../actions/stopped_actions';

const mapStateToProps = state => ({
  speed: state.speed
});

const mapDispatchToProps = dispatch => ({
  clearSwitches: () => dispatch(clearSwitches()),
  changeColumn: () => dispatch(changeColumn()),
  stopPlayback: () => dispatch(stopPlayback()),
  startPlayback: () => dispatch(startPlayback())
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Controls);
