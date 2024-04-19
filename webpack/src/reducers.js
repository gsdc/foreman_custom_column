import { combineReducers } from 'redux';
import EmptyStateReducer from './Components/EmptyState/EmptyStateReducer';

const reducers = {
  foremanCustomColumn: combineReducers({
    emptyState: EmptyStateReducer,
  }),
};

export default reducers;
