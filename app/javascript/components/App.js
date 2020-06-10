import React from 'react';
import { Route, Switch } from 'react-router-dom';

import Login from './Auth/Login';
import Signup from './Auth/Signup';
import Dash from './Dash/Dash';
import Appza from './Appza/Appza';

function App() {
  return (
    <Switch>
      <Route exact path="/signup" component={ Signup } />
      <Route exact path="/dash" component={ Dash } />
      <Route exact path="/appza" component={ Appza } />
      <Route path="/" component={ Login } />
    </Switch>
  );
}

export default App;