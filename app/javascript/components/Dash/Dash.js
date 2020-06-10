import React, { useEffect } from 'react';
import { Link, Redirect } from 'react-router-dom';
import { useSelector, useDispatch } from "react-redux";

import { fetchAppzaInfo, authenticateAppzaUser } from '../../store/actions/appzasAction';

import './Dash.css';

function Dash() {
  // Get the Redux Dispatch
  const dispatch = useDispatch();

  // Working on Appza ID URL Param
  const urlLocation = window.location.href;
  const url = new URL(urlLocation);
  const urlAppzaIdParam = url.searchParams.get("appza_id");
  const urlAppzaIdParamValue = parseInt(urlAppzaIdParam);

  // Get the Redux state
  const store = useSelector(store => store);
  const { user } = store.users;
  const userAuthToken = store.users.user_auth_token;
  const appza = store.appzas.appza;
  const appzaError = store.appzas.err;

  useEffect(() => {
    if(urlAppzaIdParamValue) {
      dispatch(fetchAppzaInfo(urlAppzaIdParamValue));
    }

    if(appza && userAuthToken) {
      const csrfToken = document.querySelector('[name="csrf-token"]').getAttribute('content');
      dispatch(authenticateAppzaUser(appza.id, userAuthToken, csrfToken));
    }
  }, [userAuthToken]);

  if(!user && urlAppzaIdParamValue) return <Redirect to={"/?appza_id=" + urlAppzaIdParamValue} />;
  if(!user) return <Redirect to="/" />;

  return (
    <React.Fragment>
      {
        appza ? (
          <div>
            <p>App Name: { appza.name }</p>
            <p>App URL: { appza.url }</p>
            <p>Permissions: { appza.requires.join(", ") }</p>
            <a href={ appza.url + "/auth/login?auth_token=" + userAuthToken }>Continue Sign In</a>
          </div>
        ) : ("")
      }

      {
        appzaError ? (
          <div>
            <p>{ appzaError.message }</p>
          </div>
        ) : ("")
      }

      {
        user ? (
          <div>
            <h1>Hello from Dash</h1>
            <p>Auth token: { userAuthToken }</p>
            <p>ID: { user.id }</p>
            <p>Email: {user.email}</p>
            <p>Username: {user.username}</p>
            <p>Admin: { user.admin ? "true" : "false"}</p>
            <p>Email confirmation: {user.email_confirmation}</p>
          </div>
        ) : ("")
      }

      {
        user && user.admin && (
          <div>
            <Link to="/appza">App Dashboard</Link>
          </div>
        )
      }

      <hr />
      <button onClick={ (e) => {
        localStorage.removeItem("authna_auth_token");
        window.location.href = "/";
      }}>Sign out local</button>
    </React.Fragment>
  );
}

export default Dash;