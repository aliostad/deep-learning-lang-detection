import CardBoard from '../../../Components/MainSection/Card/CardBoard'
import * as actions from '../../../Actions/Action'
import { connect } from 'react-redux'

const mapStateToProps = (props)  => {
  return props;
};

const mapDispatchToProps = (dispatch) => {
  return {
    onDecrement() {
      dispatch(actions.minusCount());
    },
    onIncrement() {
      dispatch(actions.addCount());
    },
    onRemoveCardInStorage(number) {
      dispatch(actions.removeCardInStorage(number));
    },
    onSaveMyCard(number) {
      dispatch(actions.savemycard(number));
    },
    onSendFetchData() {
      dispatch(actions.sendFetchData(dispatch));
    }
  }
};


const CardContainer = connect(mapStateToProps, mapDispatchToProps)(CardBoard);

export default CardContainer;
