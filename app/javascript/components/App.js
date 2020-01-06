import React from 'react';
import { Route, Switch } from 'react-router-dom';

import Login from './Auth/Login';
import Signup from './Auth/Signup';
import Dash from './Dash/Dash';

function App() {
  return (
    <Switch>
      <Route exact path="/signup" component={ Signup } />
      <Route exact path="/dash" component={ Dash } />
      <Route path="/" component={ Login } />
    </Switch>
  );
}

export default App;