import usersReducer from './usersReducer';
import appzasReducer from './appzasReducer';

import { combineReducers } from 'redux';

const rootReducer = combineReducers({
  users: usersReducer,
  appzas: appzasReducer
});

export default rootReducer;