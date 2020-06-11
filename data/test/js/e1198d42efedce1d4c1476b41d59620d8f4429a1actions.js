import Constants from '../constants/constants';
import { dispatch } from '../dispatchers/dispatcher';

export default {
  addCommand() {
    dispatch({ actionType: Constants.ADD_COMMAND });
  },
  saveCommands() {
    dispatch({ actionType: Constants.SAVE_COMMANDS });
  },
  updateCommand(command) {
    dispatch({
      actionType: Constants.UPDATE_COMMAND,
      command });
  },
  deleteCommand(index) {
    dispatch({
      actionType: Constants.DELETE_COMMAND,
      index });
  },
  loadPackage(filePath) {
    dispatch({
      actionType: Constants.LOAD_PACKAGE,
      filePath });
  },
  changeConfig(config) {
    dispatch({
      actionType: Constants.CHANGE_CONFIG,
      config });
  },
  saveConfig(config) {
    dispatch({
      actionType: Constants.SAVE_CONFIG,
      config });
  },
};
