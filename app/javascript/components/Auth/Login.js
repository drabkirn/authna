import React, { useState, useEffect } from 'react';
import { Link, Redirect } from 'react-router-dom';
import { useSelector, useDispatch } from "react-redux";

import './Auth.css';

import { createNewUserSessionWithEmail, createNewUserSessionWithUsername, fetchUserInfo } from '../../store/actions/usersAction';
import { fetchAppzaInfo } from '../../store/actions/appzasAction';

function Login() {
  const [authenticateWithValue, setAuthenticateWithValue] = useState("email");
  const [email, setEmail] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [otpCode, setOtpCode] = useState("");

  // Get the Redux Dispatch
  const dispatch = useDispatch();

  // Working on Appza ID URL Param
  const urlLocation = window.location.href;
  const url = new URL(urlLocation);
  const urlAppzaIdParam = url.searchParams.get("appza_id");
  const urlAppzaIdParamValue = parseInt(urlAppzaIdParam);

  // Get the Redux state
  const store = useSelector(store => store);
  const response = store.users;
  const userAuthToken = response.user_auth_token;
  const appza = store.appzas.appza;
  const appzaError = store.appzas.err;

  useEffect(() => {
    if(urlAppzaIdParamValue) {
      dispatch(fetchAppzaInfo(urlAppzaIdParamValue));
    }

    if(userAuthToken) {
      dispatch(fetchUserInfo(userAuthToken));
    }
  }, [userAuthToken]);

  if(response.user && urlAppzaIdParamValue) return <Redirect to={"/dash?appza_id=" + urlAppzaIdParamValue} />;
  if(response.user) return <Redirect to="/dash" />;

  return (
    <React.Fragment>
      <div>
        <h1>Login</h1>
        <Link to={"/signup"}>Signup</Link>
      </div>

      {
        appza ? (
          <div>
            <p>App Name: { appza.name }</p>
            <p>App URL: { appza.url }</p>
            <p>Permissions: { appza.requires.join(", ") }</p>
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
        response.user ? ("") : (
          <div>
            <form onSubmit={ (e) => {
                e.preventDefault();
                const csrfToken = document.querySelector('[name="csrf-token"]').getAttribute('content');
                if(authenticateWithValue === "email") {
                  dispatch(createNewUserSessionWithEmail(email, password, otpCode, csrfToken));
                }
                else {
                  dispatch(createNewUserSessionWithUsername(username, password, otpCode, csrfToken))
                }
              }
            }>
              <div>
                <label htmlFor="loginSelect">Authenticate with: </label>
                <select id="authenticateWithValue" value={ authenticateWithValue } onChange={ (e) => {
                  setAuthenticateWithValue(e.target.value);
                  setEmail("");
                  setUsername("");
                  document.getElementById(authenticateWithValue).value = "";
                }}>
                  <option value="email">Email</option>
                  <option value="username">Username</option>
                </select>
              </div>

              {
                authenticateWithValue === "email" ? (
                  <div>
                    <label htmlFor="email">Email: </label>
                    <input type="email" id="email" autoFocus autoComplete="email" onChange={ (e) => setEmail(e.target.value) } />
                  </div>
                ) : (
                  <div>
                    <label htmlFor="username">Username: </label>
                    <input type="text" id="username" autoFocus autoComplete="username" onChange={ (e) => setUsername(e.target.value) } />
                  </div>
                )
              }

              <div>
                <label htmlFor="password">Password: </label>
                <input type="password" id="password" onChange={ (e) => setPassword(e.target.value) } />
              </div>
              <div>
                <label htmlFor="otpCode">OTP Code(optional): </label>
                <input type="number" id="otpCode" onChange={ (e) => setOtpCode(e.target.value) } />
              </div>

              <br />
              
              {
                response.err ? (
                  <div>
                    {
                      response.err.message ? (
                        <div>
                          { "Error: " + response.err.message }
                        </div>
                      ) : ""
                    }
                  </div>
                ) : ("")
              }

              <div>
                <button>Login</button>
              </div>
            </form>
          </div>
        )
      }
    </React.Fragment>
  );
}

export default Login;