import React from 'react';
import { Link, Redirect } from 'react-router-dom';
import { useSelector } from "react-redux";

import './Dash.css';

function Dash() {
  // Get the Redux state
  const store = useSelector(store => store);
  const { user } = store.users;

  if(!user) return <Redirect to="/" />;

  return (
    <React.Fragment>
      <h1>Hello from Dash</h1>
      <p>Auth token: {user.auth_token}</p>
      <p>Message: {user.message}</p>
      <p>Email: {user.user_email}</p>
      <p>Username: {user.user_username}</p>
      <p>Email confirmation: {user.user_email_confirmation}</p>

      <hr />
      <button onClick={ (e) => {
        localStorage.removeItem("authna_user");
        window.location.href = "/";
      }}>Sign out local</button>
    </React.Fragment>
  );
}

export default Dash;