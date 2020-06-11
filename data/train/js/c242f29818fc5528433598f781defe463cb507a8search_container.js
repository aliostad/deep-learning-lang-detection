import { updateBounds } from '../../actions/filter_actions';
import { fetchBenches } from '../../actions/bench_actions';
import { connect } from 'react-redux';
import { Search } from './search';


const mapStateToProps = (state) => {
  return {
    benches: state.benches
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    fetchBenches: () => dispatch(fetchBenches()),
    updateBounds: (bounds) => dispatch(updateBounds(bounds))
  };
};

export default connect(mapStateToProps, mapDispatchToProps)(Search);
